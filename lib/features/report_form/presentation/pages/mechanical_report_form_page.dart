import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/providers/dev_mode_provider.dart';
import '../../../../core/services/firestore_cadastros_service.dart';
import '../../../sync/presentation/widgets/sync_status_badge.dart';
import '../../data/constants/mechanical_constants.dart';
import '../controllers/report_form_controller.dart';
import '../widgets/mechanical_om_card.dart';

class MechanicalReportFormPage extends ConsumerStatefulWidget {
  const MechanicalReportFormPage({super.key});

  @override
  ConsumerState<MechanicalReportFormPage> createState() =>
      _MechanicalReportFormPageState();
}

class _MechanicalReportFormPageState
    extends ConsumerState<MechanicalReportFormPage> {
  final ScrollController _scrollController = ScrollController();
  StreamSubscription? _tagsSubscription;
  StreamSubscription? _areaSubscription;

  // Modal controller para nova OM
  String _selectedRota = '';
  String _manualLocSel = '';
  String _manualLocOutro = '';
  String _manualOmNum = '';

  @override
  void initState() {
    super.initState();
    _initFirestoreTagsListener();
  }

  void _initFirestoreTagsListener() {
    // Garante que todas as TAGs pré-existentes do app estejam salvas no Cloud Firestore
    FirestoreCadastrosService().popularTodasTagsEstaticasNoFirestore();

    // 1. Escutar coleção dedicada 'mechanical_tags'
    _tagsSubscription = FirestoreCadastrosService().escutarTagsMecanica(
      onData: (tags) {
        MechanicalConstants.updateDynamicTags(tags);
        if (mounted) setState(() {});
      },
    );


    // 2. Escutar documento consolidado 'cmoc_cadastros/mecanica'
    _areaSubscription = FirestoreCadastrosService().escutarCadastrosArea(
      area: 'mecanica',
      onData: (data) {
        if (data['tags'] != null && data['tags'] is Map) {
          final tagsMap = data['tags'] as Map<String, dynamic>;
          final List<Map<String, dynamic>> parsedTags = [];
          tagsMap.forEach((equipType, tagList) {
            if (tagList is List) {
              for (final item in tagList) {
                if (item is Map) {
                  parsedTags.add({
                    'tag': item['tag'] ?? item['codigo'] ?? '',
                    'desc': item['desc'] ?? item['descricao'] ?? '',
                    'equipmentType': equipType,
                    'location': item['location'] ?? item['local'] ?? '',
                  });
                }
              }
            }
          });
          if (parsedTags.isNotEmpty) {
            MechanicalConstants.updateDynamicTags(parsedTags);
            if (mounted) setState(() {});
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _tagsSubscription?.cancel();
    _areaSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  // ─── Validação ─────────────────────────────────────────────────────────────

  List<String> _validateMechanicalForm() {
    final state = ref.read(reportFormControllerProvider);
    final List<String> erros = [];

    // Executantes
    final hasExecutante = state.operators.any(
      (op) => op.name.trim().isNotEmpty || op.registration.trim().isNotEmpty,
    );
    if (!hasExecutante) {
      erros.add('• Nenhum executante selecionado');
    }

    if (state.observations.trim().isEmpty) {
      erros.add('• Observações devem ser preenchidas ou conter "N/A"');
    }

    // OMs
    if (state.workOrders.isEmpty) {
      erros.add('• Nenhuma OM adicionada');
      return erros;
    }


    for (int i = 0; i < state.workOrders.length; i++) {
      final om = state.workOrders[i];
      final num = om.number.isNotEmpty ? om.number : 'OM ${i + 1}';

      if (om.maintenanceType.isEmpty) {
        erros.add('• $num: Tipo de manutenção não selecionado');
      }
      if (om.maintenanceType == 'Outro' && om.maintenanceTypeOutro.trim().isEmpty) {
        erros.add('• $num: Especifique o tipo de manutenção');
      }
      if (om.equipmentType.isEmpty) {
        erros.add('• $num: Tipo de equipamento não selecionado');
      }
      if (om.equipmentType == 'Outro' && om.equipmentOutro.trim().isEmpty) {
        erros.add('• $num: Especifique o tipo de equipamento');
      }
      if (om.status.isEmpty) {
        erros.add('• $num: Status não selecionado');
      }

      // Tag obrigatória se Equipamento != Outro
      if (om.equipmentType.isNotEmpty && om.equipmentType != 'Outro') {
        final tagFinal = om.tagVal == 'OUTRO' ? om.tagOutro : om.tagVal;
        if (tagFinal.trim().isEmpty) {
          erros.add('• $num: Tag do equipamento não informada');
        }
      }

      // Horários
      if (om.startTime.isEmpty) {
        erros.add('• $num: Horário de início não informado');
      }
      if (om.endTime.isEmpty) {
        erros.add('• $num: Horário de término não informado');
      }

      // Atividade
      if (om.activities.trim().isEmpty) {
        erros.add('• $num: Descrição da atividade não preenchida');
      }

      // Corretiva
      if (om.maintenanceType == 'Corretiva') {
        if (om.cause.trim().isEmpty) {
          erros.add('• $num: Causa (Corretiva) não preenchida');
        }
        if (om.symptom.trim().isEmpty) {
          erros.add('• $num: Sintoma (Corretiva) não preenchido');
        }
      }

      // Parada
      if (om.hasStoppage) {
        if (om.stoppageStartTime.isEmpty) {
          erros.add('• $num: Horário de início da parada não informado');
        }
        if (om.stoppageEndTime.isEmpty) {
          erros.add('• $num: Horário de retorno da parada não informado');
        }
      }

      // Inspeção Bomba
      if (om.maintenanceType == 'Inspeção' && om.equipmentType == 'Bomba') {
        if (om.pressure.trim().isEmpty) {
          erros.add('• $num: Pressão não preenchida (Inspeção)');
        }
        if (om.horometer.trim().isEmpty) {
          erros.add('• $num: Horímetro não preenchido (Inspeção)');
        }
      }

      // Preditiva Vibração
      if (om.maintenanceType == 'Preditiva' &&
          (om.equipmentType == 'Bomba' || om.equipmentType == 'Motor')) {
        final predList = (om.tasks['predTarefas'] ?? '').split(',');
        if (predList.contains('vibracao')) {
          if (om.vibrationSpeed.trim().isEmpty) {
            erros.add('• $num: Velocidade não preenchida (Análise de Vibração)');
          }
          if (om.vibrationGe.trim().isEmpty) {
            erros.add('• $num: GE não preenchido (Análise de Vibração)');
          }
          if (om.vibrationTemp.trim().isEmpty) {
            erros.add('• $num: Temperatura não preenchida (Análise de Vibração)');
          }
        }
      }
    }

    return erros;
  }

  // ─── Texto WhatsApp ────────────────────────────────────────────────────────

  String _generateWhatsAppText() {
    final state = ref.read(reportFormControllerProvider);
    final List<String> lines = [];

    lines.add('🔧 *RELATÓRIO DE TURNO — MANUTENÇÃO MECÂNICA*');
    lines.add('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    lines.add('');
    lines.add('📋 *IDENTIFICAÇÃO*');
    lines.add('─────────────────────');

    final d = state.date;
    final dateStr =
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    lines.add('📅 *Data:* $dateStr');

    for (int i = 0; i < state.operators.length; i++) {
      final op = state.operators[i];
      if (op.name.isNotEmpty || op.registration.isNotEmpty) {
        final details = [
          if (op.name.isNotEmpty) op.name,
          if (op.registration.isNotEmpty) '| Mat: ${op.registration}',
        ].join(' ');
        lines.add('👷 *Executante ${i + 1}:* $details');
      }
    }

    lines.add('⏱️ *Turno:* ${state.shift}  |  👥 *Turma:* ${state.team}');

    if (state.workOrders.isNotEmpty) {
      lines.add('');
      lines.add('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      lines.add(
          '🔧 *ORDENS DE MANUTENÇÃO (${state.workOrders.length} OM${state.workOrders.length > 1 ? 's' : ''})*');
      lines.add('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      for (int i = 0; i < state.workOrders.length; i++) {
        final om = state.workOrders[i];
        final manutLabel = om.maintenanceType == 'Outro' && om.maintenanceTypeOutro.isNotEmpty
            ? '${om.maintenanceType}: ${om.maintenanceTypeOutro}'
            : om.maintenanceType;
        final equipLabel = om.equipmentType == 'Outro' && om.equipmentOutro.isNotEmpty
            ? '${om.equipmentType}: ${om.equipmentOutro}'
            : om.equipmentType;

        lines.add('');
        lines.add('┌─────────────────────────');
        final locStr = om.location.isNotEmpty ? ' | 📍 ${om.location}' : '';
        lines.add('│ 📌 *OM ${i + 1}: ${om.number}*$locStr');
        lines.add('└─────────────────────────');

        if (manutLabel.isNotEmpty) lines.add('🔨 *Tipo Manutenção:* $manutLabel');
        if (om.datasulOm.isNotEmpty) lines.add('📄 *OM Datasul:* ${om.datasulOm}');
        if (equipLabel.isNotEmpty) lines.add('⚙️ *Tipo Equipamento:* $equipLabel');

        final tagFinal = om.equipmentType == 'Outro'
            ? null
            : (om.tagVal == 'OUTRO' ? om.tagOutro : om.tagVal);
        if (tagFinal != null && tagFinal.isNotEmpty) {
          final descStr = om.tagDesc.isNotEmpty ? ' — ${om.tagDesc}' : '';
          lines.add('🏷️ *Tag:* $tagFinal$descStr');
        }

        // Tarefas Preventiva
        if (om.maintenanceType == 'Preventiva' && om.equipmentType == 'Bomba') {
          final tg = om.tasks['troca-gaxeta'];
          if (tg != null) {
            lines.add('');
            lines.add('💧 *Tarefas — Bomba:*');
            lines.add('  🔄 Troca gaxeta: ${tg == 'sim' ? '✅ Sim' : '❌ Não'}');
          }
        }

        // Tarefas Preditiva
        if (om.maintenanceType == 'Preditiva' &&
            (om.equipmentType == 'Bomba' || om.equipmentType == 'Motor')) {
          final predArr = (om.tasks['predTarefas'] ?? '').split(',').where((e) => e.isNotEmpty).toList();
          if (predArr.isNotEmpty) {
            lines.add('');
            lines.add('🔍 *Tarefas — Preditiva:*');
            for (final k in predArr) {
              if (k == 'outro') {
                lines.add('  ✏️ Outro${om.predOtherDesc.isNotEmpty ? ': ${om.predOtherDesc}' : ''}');
              } else if (k == 'vibracao') {
                lines.add('  📊 Análise de vibração');
                if (om.vibrationSpeed.isNotEmpty) lines.add('    • Velocidade: ${om.vibrationSpeed}');
                if (om.vibrationGe.isNotEmpty) lines.add('    • GE: ${om.vibrationGe}');
                if (om.vibrationTemp.isNotEmpty) lines.add('    • Temperatura: ${om.vibrationTemp}');
              } else if (k == 'laser') {
                lines.add('  📐 Alinhamento a laser');
              }
            }
          }
        }

        // Tarefas Inspeção
        if (om.maintenanceType == 'Inspeção') {
          if (om.equipmentType == 'Bomba') {
            lines.add('');
            lines.add('💧 *Tarefas — Bomba:*');
            final oleo = om.tasks['oleo'];
            if (oleo != null) lines.add('  🛢️ Óleo contaminado: ${oleo == 'sim' ? '✅ Sim' : '❌ Não'}');
            final trocaOleo = om.tasks['troca-oleo'];
            if (oleo == 'sim' && trocaOleo != null) lines.add('    ↳ Troca: ${trocaOleo == 'sim' ? '✅ Sim' : '❌ Não'}');
            final gaxeta = om.tasks['gaxeta'];
            if (gaxeta != null) lines.add('  🔩 Gaxetas com folga: ${gaxeta == 'sim' ? '✅ Sim' : '❌ Não'}');
            final ajusteGaxeta = om.tasks['ajuste-gaxeta'];
            if (gaxeta == 'sim' && ajusteGaxeta != null) lines.add('    ↳ Ajuste: ${ajusteGaxeta == 'sim' ? '✅ Sim' : '❌ Não'}');
            final lubrBomba = om.tasks['lubr-bomba'];
            if (lubrBomba != null) lines.add('  🧴 Lubrificação: ${lubrBomba == 'sim' ? '✅ Sim' : '❌ Não'}');
            final agua = om.tasks['agua-refrig'];
            if (agua != null) {
              const mapAr = {'ok': '✅ OK', 'corrigido': '🔧 Corrigido', 'pendente': '⏳ Pendente'};
              lines.add('  💦 Água de Refrigeração: ${mapAr[agua] ?? agua}');
            }
            if (om.pressure.isNotEmpty) lines.add('  📈 Pressão: ${om.pressure}');
            if (om.horometer.isNotEmpty) lines.add('  ⏱️ Horímetro: ${om.horometer}');
          } else if (om.equipmentType == 'Motor') {
            final lm = om.tasks['lubr-motor'];
            if (lm != null) lines.add('⚡ Lubrificação motor: ${lm == 'sim' ? '✅ Sim' : '❌ Não'}');
          } else if (om.equipmentType == 'Ventilador') {
            final lv = om.tasks['lubr-vent'];
            if (lv != null) lines.add('🌀 Lubrificação ventilador: ${lv == 'sim' ? '✅ Sim' : '❌ Não'}');
          } else if (om.equipmentType == 'Exaustor') {
            final le = om.tasks['lubr-exaust'];
            if (le != null) lines.add('💨 Lubrificação exaustor: ${le == 'sim' ? '✅ Sim' : '❌ Não'}');
            final tp = om.tasks['torque-paraf'];
            if (tp != null) lines.add('🔧 Torque parafusos: ${tp == 'sim' ? '✅ Sim' : '❌ Não'}');
          }
        }

        // Corretiva
        if (om.maintenanceType == 'Corretiva') {
          if (om.cause.isNotEmpty || om.symptom.isNotEmpty || om.intervention.isNotEmpty) {
            lines.add('');
            lines.add('🚨 *Corretiva:*');
            if (om.cause.isNotEmpty) lines.add('  ⚠️ Causa: ${om.cause}');
            if (om.symptom.isNotEmpty) lines.add('  🔍 Sintoma: ${om.symptom}');
            if (om.intervention.isNotEmpty) lines.add('  🛠️ Intervenção: ${om.intervention}');
          }
        }

        if (om.activities.isNotEmpty) {
          lines.add('');
          lines.add('📝 *Atividades:* ${om.activities}');
        }

        if (om.startTime.isNotEmpty || om.endTime.isNotEmpty) {
          final horasTrab = _calcHoras(om.startTime, om.endTime);
          final inicioStr = om.startTime.isNotEmpty ? 'Início ${om.startTime}' : '';
          final setaS = (om.startTime.isNotEmpty && om.endTime.isNotEmpty) ? ' → ' : '';
          final fimStr = om.endTime.isNotEmpty ? 'Término ${om.endTime}' : '';
          final hTrabStr = horasTrab.isNotEmpty ? ' (⏳ $horasTrab trabalhadas)' : '';
          lines.add('⏱️ *Horário:* $inicioStr$setaS$fimStr$hTrabStr');
        }

        if (om.hasStoppage) {
          lines.add('⛔ *Parada:* ✅ Sim');
          final horasPar = _calcHoras(om.stoppageStartTime, om.stoppageEndTime);
          final pInicio = om.stoppageStartTime.isNotEmpty ? om.stoppageStartTime : '—';
          final pFim = om.stoppageEndTime.isNotEmpty ? om.stoppageEndTime : '—';
          final hParStr = horasPar.isNotEmpty ? ' (🔴 $horasPar parada)' : '';
          lines.add('  Início: $pInicio  Retorno: $pFim$hParStr');
        }

        if (om.status.isNotEmpty) {
          const mapStatus = {
            'Liberado': '🟢',
            'Em Andamento': '🟡',
            'Concluído': '✅',
            'Bombeamento Operando': '💧',
            'Bombeamento Parado': '🔴',
          };
          lines.add('🚦 *Status:* ${mapStatus[om.status] ?? ''} ${om.status}');
        }
      }
    }

    if (state.observations.trim().isNotEmpty) {
      lines.add('');
      lines.add('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      lines.add('💬 *OBSERVAÇÕES / PENDÊNCIAS*');
      lines.add('─────────────────────');
      lines.add(state.observations.trim());
    }

    lines.add('');
    lines.add('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    return lines.join('\n');
  }

  String _calcHoras(String inicio, String fim) {
    if (inicio.isEmpty || fim.isEmpty) return '';
    try {
      final p1 = inicio.split(':');
      final p2 = fim.split(':');
      var min = (int.parse(p2[0]) * 60 + int.parse(p2[1])) -
          (int.parse(p1[0]) * 60 + int.parse(p1[1]));
      if (min < 0) min += 24 * 60;
      final h = min ~/ 60;
      final m = min % 60;
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  Future<void> _sendWhatsApp() async {
    final errors = _validateMechanicalForm();
    final controller = ref.read(reportFormControllerProvider.notifier);

    if (errors.isNotEmpty) {
      controller.setShowValidationPanel(true);
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
      return;
    }

    controller.clearValidationErrors();

    // Salva o relatório mecânico na coleção `mechanical_reports` com
    // ID prefixado MC- e type: 'Mecânica'. A validação já foi feita acima.
    await controller.saveAndSyncMechanicalReport();

    final text = _generateWhatsAppText();
    final encoded = Uri.encodeComponent(text);
    final url = Uri.parse('https://wa.me/?text=$encoded');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o WhatsApp')),
        );
      }
    }
  }

  // ─── Handlers Modais ───────────────────────────────────────────────────────

  void _openNewOmModal() {
    final controller = ref.read(reportFormControllerProvider.notifier);
    final nextNum = controller.getNextOSNumber().replaceAll('OS-', 'OM-');

    setState(() {
      _selectedRota = '';
      _manualOmNum = nextNum;
      _manualLocSel = '';
      _manualLocOutro = '';
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 18,
                right: 18,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      children: const [
                        TextSpan(text: '➕ Nova '),
                        TextSpan(
                          text: 'Ordem de Manutenção',
                          style: TextStyle(color: Color(0xFF5C3FA3)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Seleção de Rota
                  const Text(
                    '🛣️ Rota de Inspeção (Opcional)',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedRota.isEmpty ? null : _selectedRota,
                    decoration: const InputDecoration(

                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: '',
                        child: Text('— Sem rota (OM manual) —'),
                      ),
                      DropdownMenuItem(
                        value: 'rota01',
                        child: Text('Rota de inspeção 01'),
                      ),
                      DropdownMenuItem(
                        value: 'rota02',
                        child: Text('Rota de inspeção 02'),
                      ),
                    ],
                    onChanged: (val) {
                      setModalState(() {
                        _selectedRota = val ?? '';
                      });
                    },
                  ),

                  if (_selectedRota.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5C3FA3).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.push_pin, size: 16, color: Color(0xFF5C3FA3)),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Esta rota gerará múltiplas OMs automaticamente',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5C3FA3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (_selectedRota.isEmpty) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '🔢 Nº OM',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                initialValue: _manualOmNum,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF23005B),
                                ),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                onChanged: (val) => _manualOmNum = val,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '📍 Local',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                initialValue: _manualLocSel.isEmpty ? null : _manualLocSel,
                                decoration: const InputDecoration(

                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                                items: MechanicalConstants.locaisOptions
                                    .map((l) => DropdownMenuItem(value: l, child: Text(l, style: const TextStyle(fontSize: 13))))
                                    .toList(),
                                onChanged: (val) {
                                  setModalState(() {
                                    _manualLocSel = val ?? '';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_manualLocSel == 'Outro') ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Digite o local...',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onChanged: (val) => _manualLocOutro = val,
                      ),
                    ],
                  ],

                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_selectedRota.isNotEmpty) {
                              _addInspectionRoute(_selectedRota);
                              Navigator.pop(context);
                            } else {
                              final loc = _manualLocSel == 'Outro'
                                  ? (_manualLocOutro.isNotEmpty ? _manualLocOutro : 'Outro')
                                  : _manualLocSel;

                              if (_manualLocSel.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('⚠️ Informe o Local')),
                                );
                                return;
                              }

                              controller.addWorkOrder(loc, _manualOmNum);
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF23005B),
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Adicionar OM'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _addInspectionRoute(String rotaKey) {
    final routeConfig = MechanicalConstants.rotasInspecao[rotaKey];
    if (routeConfig == null) return;

    final controller = ref.read(reportFormControllerProvider.notifier);
    final locaisList = routeConfig['locais'] as List;

    // Finaliza OMs abertas existentes
    final state = ref.read(reportFormControllerProvider);
    for (final os in state.workOrders) {
      if (!os.isFinalized) {
        controller.updateWorkOrder(os.id, (o) => o.copyWith(isFinalized: true));
      }
    }

    for (final item in locaisList) {
      final loc = item['local'].toString();
      final tag = item['tag'].toString();
      final tagDesc = MechanicalConstants.findTagDescription(tag);
      final nextNum = controller.getNextOSNumber().replaceAll('OS-', 'OM-');

      final count = ref.read(reportFormControllerProvider).osCounter + 1;
      final osId = 'os-$count';

      controller.addWorkOrder(loc, nextNum);
      controller.updateWorkOrder(
        osId,
        (o) => o.copyWith(
          equipmentType: 'Bomba',
          tagVal: tag,
          tagDesc: tagDesc,
        ),
      );
    }


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ ${locaisList.length} OMs adicionadas da ${routeConfig['nome']}')),
    );
  }

  void _confirmDeleteOm(String omId, String omNum) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Text('🗑️ ', style: TextStyle(fontSize: 22)),
              Text('Excluir OM?'),
            ],
          ),
          content: Text('Tem certeza que deseja excluir a $omNum? Esta ação não pode ser desfeita.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(reportFormControllerProvider.notifier).removeWorkOrder(omId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('OM removida')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _confirmNewReport() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Text('🔄 ', style: TextStyle(fontSize: 22)),
              Text('Iniciar novo relatório?'),
            ],
          ),
          content: const Text('Todos os dados preenchidos neste relatório serão apagados permanentemente.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(reportFormControllerProvider.notifier).clearForm();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Novo relatório iniciado')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF23005B),
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDiscardDraft() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Text('🗑️ ', style: TextStyle(fontSize: 22)),
              Text('Descartar rascunho?'),
            ],
          ),
          content: const Text('O rascunho salvo será apagado permanentemente.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(reportFormControllerProvider.notifier).discardDraft();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rascunho descartado')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Descartar'),
            ),
          ],
        );
      },
    );
  }

  void _openAddCustomCollaboratorDialog(int index) {
    String nome = '';
    String mat = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('➕ Cadastrar Novo Executante'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => nome = val,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Matrícula',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => mat = val,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nome.trim().isEmpty || mat.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('⚠️ Preencha o nome e a matrícula')),
                  );
                  return;
                }
                ref.read(reportFormControllerProvider.notifier)
                  ..registerCustomCollaborator(nome.trim(), mat.trim())
                  ..updateOperator(index, nome.trim(), mat.trim());
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF74BE45),
                foregroundColor: Colors.white,
              ),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(reportFormControllerProvider);
    final controller = ref.read(reportFormControllerProvider.notifier);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const accentPurple = Color(0xFF5C3FA3);
    const cmocGreen = Color(0xFF74BE45);


    final consolidatedCollaborators = controller.getConsolidatedCollaborators();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1120) : const Color(0xFFF0F0F4),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: cmocGreen,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                children: const [
                  TextSpan(text: 'CM'),
                  TextSpan(text: 'OC', style: TextStyle(color: accentPurple)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: accentPurple.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '⚙️ MECÂNICA',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: accentPurple,
              ),
            ),
          ),

          if (ref.watch(devModeProvider))
            IconButton(
              icon: const Icon(Icons.bolt, color: Colors.amber),
              tooltip: 'Preencher Automático (Modo Dev)',
              onPressed: () {
                controller.fillMechanicalMockData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('⚡ Formulário mecânico preenchido com dados de teste!'),
                    backgroundColor: Color(0xFF5C3FA3),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),

          const SyncStatusBadge(),
          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner de Rascunho Restaurado
              if (formState.draftBannerVisible)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    border: Border.all(color: Colors.amber.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Text('📝 ', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          'Rascunho encontrado',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _confirmDiscardDraft,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.amber.shade100,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Descartar',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Banner de Validação
              if (formState.showValidationPanel && formState.validationErrors.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '⚠️ Preencha os campos obrigatórios:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...formState.validationErrors.map(
                        (err) => Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            err,
                            style: const TextStyle(fontSize: 12, color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // SEÇÃO: IDENTIFICAÇÃO
              _buildSectionLabel('IDENTIFICAÇÃO'),
              _buildCard(
                isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Data
                    _buildFieldLabel('📅 Data'),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: formState.date,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          controller.setDate(picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: _boxDecoration(isDark),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${formState.date.day.toString().padLeft(2, '0')}/${formState.date.month.toString().padLeft(2, '0')}/${formState.date.year}',
                              style: const TextStyle(fontSize: 15),
                            ),
                            const Icon(Icons.calendar_today, size: 16),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Executantes
                    ...List.generate(formState.operators.length, (idx) {
                      final op = formState.operators[idx];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildFieldLabel('👷 Executante ${idx + 1}'),
                                if (idx > 0)
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => controller.removeOperator(idx),
                                  ),
                              ],
                            ),
                            DropdownButtonFormField<String>(
                              initialValue: consolidatedCollaborators.any((c) => c['mat'] == op.registration)
                                  ? op.registration
                                  : null,
                              decoration: const InputDecoration(

                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              hint: const Text('— Selecione —'),
                              items: [
                                ...consolidatedCollaborators.map(
                                  (c) => DropdownMenuItem(
                                    value: c['mat'],
                                    child: Text(
                                      c['nome'] ?? '',
                                      style: const TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const DropdownMenuItem(
                                  value: '__novo__',
                                  child: Text(
                                    '➕ Cadastrar novo executante...',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF5C3FA3)),
                                  ),
                                ),
                              ],
                              onChanged: (val) {
                                if (val == '__novo__') {
                                  _openAddCustomCollaboratorDialog(idx);
                                } else if (val != null) {
                                  final colab = consolidatedCollaborators.firstWhere(
                                    (c) => c['mat'] == val,
                                    orElse: () => {'nome': '', 'mat': ''},
                                  );
                                  controller.updateOperator(
                                    idx,
                                    colab['nome'] ?? '',
                                    colab['mat'] ?? '',
                                  );
                                }
                              },
                            ),
                            if (op.registration.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Text(
                                    '🪪 Matrícula: ',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: accentPurple.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      op.registration,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: accentPurple,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],

                          ],
                        ),
                      );
                    }),

                    OutlinedButton.icon(
                      onPressed: () => controller.addOperator(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 42),
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Adicionar executante'),
                    ),
                  ],
                ),
              ),

              // SEÇÃO: TURNO & TURMA
              _buildSectionLabel('TURNO & TURMA'),
              _buildCard(
                isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('⏱️ Turno'),
                    Wrap(
                      spacing: 6,
                      children: ['T1', 'T2', 'T3', 'ADM'].map((t) {
                        final isSel = formState.shift == t;
                        return ChoiceChip(
                          label: Text(t),
                          selected: isSel,
                          selectedColor: accentPurple.withValues(alpha: 0.2),
                          side: BorderSide(color: isSel ? accentPurple : Colors.grey.shade300),
                          labelStyle: TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            color: isSel ? accentPurple : Colors.grey.shade700,
                          ),
                          onSelected: (_) => controller.setShift(t),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 10),

                    _buildFieldLabel('👥 Turma'),
                    Wrap(
                      spacing: 6,
                      children: ['A', 'B', 'C', 'D', 'ADM'].map((turma) {
                        final isSel = formState.team == turma;
                        return ChoiceChip(
                          label: Text(turma),
                          selected: isSel,
                          selectedColor: cmocGreen.withValues(alpha: 0.2),
                          side: BorderSide(color: isSel ? cmocGreen : Colors.grey.shade300),
                          labelStyle: TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            color: isSel ? cmocGreen : Colors.grey.shade700,
                          ),
                          onSelected: (_) => controller.setTeam(turma),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // SEÇÃO: ORDENS DE MANUTENÇÃO
              _buildSectionLabel('ORDENS DE MANUTENÇÃO'),

              if (formState.workOrders.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF111827) : Colors.white,
                    border: Border.all(
                      color: isDark ? const Color(0xFF374151) : const Color(0xFFE0E0E8),
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text('📭', style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 8),
                      Text(
                        'Nenhuma OM adicionada.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Toque em "+ Nova OM" para começar.',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              else
                ...List.generate(formState.workOrders.length, (idx) {
                  final om = formState.workOrders[idx];
                  return MechanicalOmCard(
                    om: om,
                    index: idx,
                    onChanged: (updatedOm) {
                      controller.updateWorkOrder(om.id, (_) => updatedOm);
                    },
                    onToggleFinalize: () {
                      controller.updateWorkOrder(
                        om.id,
                        (o) => o.copyWith(isFinalized: !o.isFinalized),
                      );
                    },
                    onDelete: () => _confirmDeleteOm(om.id, om.number),
                  );
                }),

              // Botão Nova OM
              ElevatedButton.icon(
                onPressed: _openNewOmModal,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: accentPurple.withValues(alpha: 0.12),
                  foregroundColor: accentPurple,
                  elevation: 0,
                  side: const BorderSide(color: accentPurple),
                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text(
                  '➕ Nova OM / Atividade',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),

              // SEÇÃO: OBSERVAÇÕES
              _buildSectionLabel('OBSERVAÇÕES / PENDÊNCIAS'),
              _buildCard(
                isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFieldLabel('📝 Observações *'),
                        InkWell(
                          onTap: () => controller.setObservations('N/A'),
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: const Text(
                              'Preencher N/A',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      key: ValueKey('obs_${formState.observations}'),
                      initialValue: formState.observations,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Registre observações gerais ou clique em N/A se não houver pendências...',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => controller.setObservations(val),
                    ),
                  ],
                ),
              ),


              const SizedBox(height: 14),

              // BOTOES PRINCIPAIS
              ElevatedButton.icon(
                onPressed: _sendWhatsApp,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.send, size: 20),
                label: const Text(
                  'Enviar pelo WhatsApp',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 8),

              OutlinedButton.icon(
                onPressed: _confirmNewReport,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('🔄 Novo relatório'),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider(height: 1)),
        ],
      ),
    );
  }

  Widget _buildCard(bool isDark, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE0E0E8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF7F7FA),
      border: Border.all(color: isDark ? Colors.grey.shade700 : const Color(0xFFE0E0E8)),
      borderRadius: BorderRadius.circular(8),
    );
  }
}
