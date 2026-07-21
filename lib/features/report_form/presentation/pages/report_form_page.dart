import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/report_form_controller.dart';
import '../widgets/add_colab_dialog.dart';
import '../widgets/autocomplete_operator.dart';
import '../widgets/chips_selector.dart';
import '../widgets/section_label.dart';
import '../widgets/whatsapp_preview_dialog.dart';
import '../widgets/work_order_card.dart';
import '../../../sync/presentation/widgets/sync_status_badge.dart';
import '../../../sync/presentation/controllers/sync_controller.dart';
import '../../../../core/widgets/cmoc_logo.dart';

class ReportFormPage extends ConsumerWidget {
  const ReportFormPage({super.key});

  void _showNewOSDialog(BuildContext context, ReportFormController controller) {
    final numController = TextEditingController(text: controller.getNextOSNumber());
    final locController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardColorLight,
          title: const Text(
            '＋ Nova Ordem de Serviço',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nº DA OS *',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: numController,
                  decoration: const InputDecoration(hintText: 'Ex: OS-042'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Número é obrigatório';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  'LOCAL / EQUIPAMENTO *',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: locController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(hintText: 'Ex: Bomba B-04'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Local é obrigatório';
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  controller.addWorkOrder(
                    locController.text.trim(),
                    numController.text.trim(),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _showAddColabDialog(BuildContext context, ReportFormController controller) {
    showDialog(
      context: context,
      builder: (context) => AddColabDialog(
        onSave: (name, registration) {
          controller.registerCustomCollaborator(name, registration);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Colaborador $name cadastrado com sucesso!')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportFormControllerProvider);
    final syncState = ref.watch(syncControllerProvider);
    final controller = ref.read(reportFormControllerProvider.notifier);
    final candidates = controller.getConsolidatedCollaborators();
    
    // Obter matriculas em uso para nao duplicar
    final currentRegistrations = state.operators
        .map((op) => op.registration)
        .where((reg) => reg.isNotEmpty)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const CmocLogo(showSubtitle: true),
        actions: [
          const SyncStatusBadge(),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // BANNER OFFLINE DITADO PELA CONEXÃO REAL
              if (!syncState.isOnline)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  color: AppTheme.redAlert,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, size: 14, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'SEM CONEXÃO — dados salvos localmente',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              
              // CONTEUDO DO FORMULARIO
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // SECAO IDENTIFICACAO
                      const SectionLabel(text: 'Identificação'),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Campo Data
                              ListTile(
                                title: const Text(
                                  'DATA',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.accentPurple,
                                  ),
                                ),
                                subtitle: Text(
                                  '${state.date.day.toString().padLeft(2, '0')}/${state.date.month.toString().padLeft(2, '0')}/${state.date.year}',
                                  style: const TextStyle(fontSize: 16, color: AppTheme.textDark),
                                ),
                                trailing: const Icon(Icons.calendar_month),
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: state.date,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) {
                                    controller.setDate(picked);
                                  }
                                },
                              ),
                              const Divider(color: AppTheme.borderLight, height: 1),
                              
                              // Lista de Executantes
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.operators.length,
                                itemBuilder: (context, index) {
                                  final op = state.operators[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'EXECUTANTE ${index + 1} ${index == 0 ? '*' : ''}',
                                              style: const TextStyle(
                                                fontFamily: 'monospace',
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.accentPurple,
                                              ),
                                            ),
                                            if (index > 0)
                                              GestureDetector(
                                                onTap: () => controller.removeOperator(index),
                                                child: const Icon(Icons.close, size: 16, color: AppTheme.textMuted),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: AutocompleteOperator(
                                                key: ValueKey('op-$index-${op.name}'),
                                                candidates: candidates,
                                                currentRegistrationsInUse: currentRegistrations,
                                                initialValue: op.name,
                                                onSelected: (name, registration) {
                                                  controller.updateOperator(index, name, registration);
                                                },
                                                onCleared: () {
                                                  controller.updateOperator(index, '', '');
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              width: 100,
                                              height: 48,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: AppTheme.primaryPurple.withValues(alpha: 0.08),
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: AppTheme.borderLight),
                                              ),
                                              child: Text(
                                                op.registration.isEmpty ? 'Matrícula' : op.registration,
                                                style: const TextStyle(
                                                  fontFamily: 'monospace',
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.primaryPurple,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              
                              // Botao adicionar executante
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: OutlinedButton(
                                  onPressed: () => controller.addOperator(),
                                  child: const Text('＋ Adicionar executante'),
                                ),
                              ),
                              // Botao cadastrar novo colaborador
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: OutlinedButton(
                                    onPressed: () => _showAddColabDialog(context, controller),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: AppTheme.borderLight),
                                    ),
                                    child: const Text('➕ Cadastrar Colaborador'),
                                  ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // SECAO TURNO E TURMA
                      const SectionLabel(text: 'Turno & Turma'),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'TURNO',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentPurple,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ChipsSelector<String>(
                                options: AppConstants.shiftOptions,
                                selected: state.shift,
                                onSelected: controller.setShift,
                                labelBuilder: (s) => s,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'TURMA',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentPurple,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ChipsSelector<String>(
                                options: AppConstants.teamOptions,
                                selected: state.team,
                                onSelected: controller.setTeam,
                                labelBuilder: (t) => 'Turma $t',
                              ),
                            ],
                          ),
                        ),
                      ),

                      // SECAO RELATORIO DE ATIVIDADES
                      const SectionLabel(text: 'Relatório de Atividades'),
                      if (state.workOrders.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.borderLight, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.assignment_late_outlined, color: AppTheme.textFaint),
                              SizedBox(height: 8),
                              Text(
                                'Nenhuma OS adicionada.\nToque em "+ Nova OS" para começar.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'monospace', color: AppTheme.textFaint, fontSize: 12),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.workOrders.length,
                          itemBuilder: (context, index) {
                            final os = state.workOrders[index];
                            return WorkOrderCard(
                              os: os,
                              onUpdate: (updated) {
                                controller.updateWorkOrder(os.id, (_) => updated);
                              },
                              onDelete: () {
                                controller.removeWorkOrder(os.id);
                              },
                            );
                          },
                        ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () => _showNewOSDialog(context, controller),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Nova OS / Atividade'),
                      ),

                      // SECAO EQUIPAMENTO
                      const SectionLabel(text: 'Equipamento'),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'EQUIPAMENTO',
                                style: TextStyle(fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.accentPurple),
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                initialValue: state.globalEquipment.isEmpty ? null : state.globalEquipment,
                                decoration: const InputDecoration(hintText: '— Selecione —'),
                                items: AppConstants.equipOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                onChanged: (val) => controller.setGlobalEquipment(val ?? ''),
                              ),
                              const SizedBox(height: 12),
                              
                              const Text(
                                'LOCAL',
                                style: TextStyle(fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.accentPurple),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                initialValue: state.globalLocation,
                                decoration: const InputDecoration(hintText: 'Ex: Galeria Norte, Poço 3...'),
                                onChanged: controller.setGlobalLocation,
                              ),
                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'NÍVEL DO COMBUSTÍVEL (%)',
                                    style: TextStyle(fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.accentPurple),
                                  ),
                                  Text(
                                    '${state.fuelLevel.toInt()}%',
                                    style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, color: AppTheme.primaryPurple, fontSize: 14),
                                  ),
                                ],
                              ),
                              Slider(
                                value: state.fuelLevel,
                                min: 0,
                                max: 100,
                                divisions: 20, // passos de 5% em 5%
                                activeColor: AppTheme.primaryPurple,
                                inactiveColor: Colors.black.withValues(alpha: 0.1),
                                onChanged: controller.setFuelLevel,
                              ),
                              const SizedBox(height: 12),

                              const Text(
                                'MATERIAIS DISPONÍVEIS',
                                style: TextStyle(fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.accentPurple),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                initialValue: state.availableMaterials,
                                maxLines: 2,
                                decoration: const InputDecoration(hintText: 'Liste os materiais disponíveis...'),
                                onChanged: controller.setAvailableMaterials,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // SECAO OBSERVACOES
                      const SectionLabel(text: 'Observações / Pendências'),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'OBSERVAÇÕES / PENDÊNCIAS',
                                style: TextStyle(fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.accentPurple),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                initialValue: state.observations,
                                maxLines: 4,
                                decoration: const InputDecoration(hintText: 'Registre observações gerais, pendências...'),
                                onChanged: controller.setObservations,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // BOTOES DE ACAO DO RELATORIO
                      ElevatedButton.icon(
                        onPressed: () async {
                          final success = await controller.submitReport();
                          if (success) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('✅ Relatório finalizado e enviado para sincronização!'),
                                  backgroundColor: AppTheme.cmocGreen,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              showDialog(
                                context: context,
                                builder: (context) => WhatsappPreviewDialog(
                                  formattedText: controller.generateWhatsAppText(),
                                ),
                              );
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('⚠️ Preencha os campos obrigatórios pendentes.'),
                                  backgroundColor: AppTheme.redAlert,
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        icon: const Icon(Icons.send),
                        label: const Text('Enviar pelo WhatsApp'),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: AppTheme.cardColorLight,
                              title: const Text('Novo relatório?'),
                              content: const Text('Isso limpará todos os campos atuais. Tem certeza?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.clearForm();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Novo relatório'),
                      ),
                      const SizedBox(height: 100), // margem inferior para o painel de validacao
                    ],
                  ),
                ),
              ),
            ],
          ),

          // PAINEL FLUTUANTE DE ERROS DE VALIDACAO
          if (state.showValidationPanel && state.validationErrors.isNotEmpty)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Material(
                elevation: 10,
                color: AppTheme.cardColorLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: AppTheme.redAlert, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: AppTheme.redAlert, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'CAMPOS OBRIGATÓRIOS PENDENTES',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.redAlert,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => controller.setShowValidationPanel(false),
                            child: const Icon(Icons.close, size: 18, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 120),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: state.validationErrors.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('▪ ', style: TextStyle(color: AppTheme.redAlert, fontSize: 14)),
                                  Expanded(
                                    child: Text(
                                      state.validationErrors[index],
                                      style: const TextStyle(fontSize: 13, color: AppTheme.textDark),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
