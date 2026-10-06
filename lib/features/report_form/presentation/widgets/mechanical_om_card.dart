import 'package:flutter/material.dart';
import '../../../../core/services/firestore_cadastros_service.dart';
import '../../data/constants/mechanical_constants.dart';
import '../controllers/report_form_state.dart';

class MechanicalOmCard extends StatelessWidget {
  final WorkOrderState om;
  final int index;
  final ValueChanged<WorkOrderState> onChanged;
  final VoidCallback onToggleFinalize;
  final VoidCallback onDelete;

  const MechanicalOmCard({
    super.key,
    required this.om,
    required this.index,
    required this.onChanged,
    required this.onToggleFinalize,
    required this.onDelete,
  });

  void _openAddTagDialog(BuildContext context, String equipmentType) {
    String newTag = '';
    String newDesc = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '➕ Nova TAG — $equipmentType',
            style: const TextStyle(color: Color(0xFF23005B), fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Código da TAG (ex: BAEI3099)',
                  hintText: 'Ex: BAEI3099',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => newTag = val,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Descrição do Equipamento',
                  hintText: 'Ex: BOMBA CENTRIFUGA WARMAN',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => newDesc = val,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final cleanTag = newTag.trim().toUpperCase();
                if (cleanTag.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('⚠️ Digite o código da TAG')),
                  );
                  return;
                }
                await FirestoreCadastrosService().salvarTagMecanica(
                  tag: cleanTag,
                  desc: newDesc.trim(),
                  equipmentType: equipmentType,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('✅ TAG $cleanTag enviada para o Cloud Firestore!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF23005B),
                foregroundColor: Colors.white,
              ),
              child: const Text('Salvar no Firestore'),
            ),
          ],
        );
      },
    );
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

  void _updateTask(String key, String value) {
    final updatedTasks = Map<String, String>.from(om.tasks);
    if (value.isEmpty) {
      updatedTasks.remove(key);
    } else {
      updatedTasks[key] = value;
    }
    onChanged(om.copyWith(tasks: updatedTasks));
  }

  void _togglePredTask(String taskKey) {
    final currentPred = om.tasks['predTarefas'] ?? '';
    final predList = currentPred.isNotEmpty ? currentPred.split(',') : <String>[];

    if (predList.contains(taskKey)) {
      predList.remove(taskKey);
    } else {
      // Única seleção por OM conforme HTML
      predList.clear();
      predList.add(taskKey);
    }

    _updateTask('predTarefas', predList.join(','));
  }

  Future<void> _selectTime(
    BuildContext context,
    String currentValue,
    Function(String) onSelected,
  ) async {
    TimeOfDay initial = TimeOfDay.now();
    if (currentValue.isNotEmpty) {
      try {
        final parts = currentValue.split(':');
        initial = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      } catch (_) {}
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      final h = picked.hour.toString().padLeft(2, '0');
      final m = picked.minute.toString().padLeft(2, '0');
      onSelected('$h:$m');
    }
  }

  void _openTagSearchDialog(BuildContext context) {
    final catalog = MechanicalConstants.getTagCatalog(om.equipmentType);
    final allowedMap = MechanicalConstants.getLocalMap(om.equipmentType);
    final allowedTags = allowedMap?[om.location];

    // Exibe todas as TAGs do equipamento selecionado.
    // Se houver TAGs vinculadas ao local selecionado, prioriza-as no topo.
    final List<Map<String, String>> filteredCatalog = [];
    if (allowedTags != null && allowedTags.isNotEmpty) {
      final priorityTags = catalog.where((item) => allowedTags.contains(item['tag'])).toList();
      final otherTags = catalog.where((item) => !allowedTags.contains(item['tag'])).toList();
      filteredCatalog.addAll(priorityTags);
      filteredCatalog.addAll(otherTags);
    } else {
      filteredCatalog.addAll(catalog);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final items = filteredCatalog.where((item) {
              if (searchQuery.isEmpty) return true;
              final q = searchQuery.toUpperCase();
              final tag = (item['tag'] ?? '').toUpperCase();
              final desc = (item['desc'] ?? '').toUpperCase();
              return tag.contains(q) || desc.contains(q);
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Selecionar Tag — ${om.equipmentType}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.add_circle_outline, size: 18),
                        label: const Text('Nova TAG'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF5C3FA3),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _openAddTagDialog(context, om.equipmentType);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: '🔍 Pesquisar tag ou descrição...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onChanged: (val) => setModalState(() => searchQuery = val),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, idx) {
                        final item = items[idx];
                        final tag = item['tag'] ?? '';
                        final desc = item['desc'] ?? '';
                        final isSelected = om.tagVal == tag;

                        return ListTile(
                          selected: isSelected,
                          selectedTileColor: const Color(0xFF5C3FA3).withValues(alpha: 0.1),
                          title: Text(
                            tag,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF23005B),
                            ),
                          ),
                          subtitle: desc.isNotEmpty ? Text(desc) : null,
                          onTap: () {
                            final descTxt = MechanicalConstants.findTagDescription(tag);
                            onChanged(om.copyWith(
                              tagVal: tag,
                              tagDesc: descTxt,
                              tagOutro: tag == 'OUTRO' ? om.tagOutro : '',
                            ));
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isFinalized = om.isFinalized;

    const primaryBlue = Color(0xFF23005B);
    const accentPurple = Color(0xFF5C3FA3);
    const cmocGreen = Color(0xFF74BE45);

    final bgHeader = isFinalized
        ? cmocGreen.withValues(alpha: 0.15)
        : accentPurple.withValues(alpha: 0.12);

    final horasTrabalhadas = _calcHoras(om.startTime, om.endTime);
    final horasParada = _calcHoras(om.stoppageStartTime, om.stoppageEndTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFinalized
              ? cmocGreen.withValues(alpha: 0.6)
              : (isDark ? const Color(0xFF374151) : const Color(0xFFE0E0E8)),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: bgHeader,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF374151) : const Color(0xFFE0E0E8),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🔧 ${om.number}',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isFinalized ? cmocGreen : primaryBlue,
                        ),
                      ),
                      if (om.location.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          '📍 ${om.location}',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: onToggleFinalize,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isFinalized ? primaryBlue : cmocGreen,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  icon: Icon(
                    isFinalized ? Icons.edit : Icons.check_circle,
                    size: 14,
                    color: isFinalized ? primaryBlue : cmocGreen,
                  ),
                  label: Text(
                    isFinalized ? 'Editar' : 'Finalizar',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isFinalized ? primaryBlue : cmocGreen,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.close, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  color: Colors.grey.shade600,
                  tooltip: 'Excluir OM',
                ),
              ],
            ),
          ),

          // Se a OM está finalizada, exibe resumo colapsado
          if (isFinalized)
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  if (om.maintenanceType.isNotEmpty)
                    _buildSummaryRow('🔨 Manutenção', om.maintenanceTypeOutro.isNotEmpty ? '${om.maintenanceType}: ${om.maintenanceTypeOutro}' : om.maintenanceType, isDark),
                  if (om.equipmentType.isNotEmpty)
                    _buildSummaryRow('⚙️ Equipamento', om.equipmentOutro.isNotEmpty ? '${om.equipmentType}: ${om.equipmentOutro}' : om.equipmentType, isDark),
                  if (om.tagVal.isNotEmpty)
                    _buildSummaryRow('🏷️ Tag', om.tagVal == 'OUTRO' ? om.tagOutro : om.tagVal, isDark),
                  if (om.status.isNotEmpty)
                    _buildSummaryRow('🚦 Status', om.status, isDark),
                ],
              ),
            )
          else ...[
            // Corpo Editável
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tipo de Manutenção
                  _buildLabel('🔨 Tipo de Manutenção'),
                  DropdownButtonFormField<String>(
                    initialValue: MechanicalConstants.manutencaoOptions.contains(om.maintenanceType)
                        ? om.maintenanceType
                        : null,
                    decoration: _inputDecoration('— Selecione —'),

                    items: MechanicalConstants.manutencaoOptions
                        .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        onChanged(om.copyWith(maintenanceType: val));
                      }
                    },
                  ),

                  // Se Preditiva -> OM Datasul
                  if (om.maintenanceType == 'Preditiva') ...[
                    const SizedBox(height: 10),
                    _buildLabel('📄 OM Datasul'),
                    TextFormField(
                      initialValue: om.datasulOm,
                      decoration: _inputDecoration('Nº da OM no Datasul...'),
                      onChanged: (val) => onChanged(om.copyWith(datasulOm: val)),
                    ),
                  ],

                  // Se Outro -> Especifique o tipo
                  if (om.maintenanceType == 'Outro') ...[
                    const SizedBox(height: 10),
                    _buildLabel('✏️ Especifique o tipo'),
                    TextFormField(
                      initialValue: om.maintenanceTypeOutro,
                      decoration: _inputDecoration('Digite o tipo de manutenção...'),
                      onChanged: (val) => onChanged(om.copyWith(maintenanceTypeOutro: val)),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Tipo de Equipamento
                  _buildLabel('⚙️ Tipo de Equipamento'),
                  DropdownButtonFormField<String>(
                    initialValue: MechanicalConstants.equipamentoOptions.contains(om.equipmentType)
                        ? om.equipmentType
                        : null,
                    decoration: _inputDecoration('— Selecione —'),

                    items: MechanicalConstants.equipamentoOptions
                        .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        onChanged(om.copyWith(
                          equipmentType: val,
                          tagVal: '',
                          tagDesc: '',
                          tagOutro: '',
                        ));
                      }
                    },
                  ),

                  // Se Equipamento Outro -> Especifique
                  if (om.equipmentType == 'Outro') ...[
                    const SizedBox(height: 10),
                    _buildLabel('✏️ Especifique o equipamento'),
                    TextFormField(
                      initialValue: om.equipmentOutro,
                      decoration: _inputDecoration('Digite o tipo de equipamento...'),
                      onChanged: (val) => onChanged(om.copyWith(equipmentOutro: val)),
                    ),
                  ],

                  // Campo Tag (Searchable se equipamento selecionado e não for 'Outro')
                  if (om.equipmentType.isNotEmpty && om.equipmentType != 'Outro') ...[
                    const SizedBox(height: 12),
                    _buildLabel('🏷️ Tag do Equipamento'),
                    InkWell(
                      onTap: () => _openTagSearchDialog(context),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF7F7FA),
                          border: Border.all(color: isDark ? Colors.grey.shade700 : const Color(0xFFE0E0E8)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, size: 18, color: accentPurple),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                om.tagVal.isNotEmpty ? om.tagVal : '🔍 Pesquisar tag...',
                                style: TextStyle(
                                  fontFamily: om.tagVal.isNotEmpty ? 'monospace' : null,
                                  fontWeight: om.tagVal.isNotEmpty ? FontWeight.bold : FontWeight.normal,
                                  color: om.tagVal.isNotEmpty
                                      ? primaryBlue
                                      : Colors.grey.shade500,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    if (om.tagDesc.isNotEmpty && om.tagVal != 'OUTRO') ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: accentPurple.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '📌 ${om.tagDesc}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: accentPurple,
                          ),
                        ),
                      ),
                    ],

                    if (om.tagVal == 'OUTRO') ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: om.tagOutro,
                        decoration: _inputDecoration('✏️ Digite a tag do equipamento...'),
                        onChanged: (val) => onChanged(om.copyWith(tagOutro: val)),
                      ),
                    ],
                  ],

                  // Tarefas Específicas
                  const SizedBox(height: 14),
                  _buildSpecificTasks(context, isDark),

                  const SizedBox(height: 12),

                  // Descrição da Atividade
                  _buildLabel('📝 Descrição da Atividade *'),
                  TextFormField(
                    initialValue: om.activities,
                    maxLines: 3,
                    decoration: _inputDecoration('Descreva a atividade desta OM...'),
                    onChanged: (val) => onChanged(om.copyWith(activities: val)),
                  ),

                  const SizedBox(height: 12),

                  // Horário de Execução
                  _buildLabel('⏱️ Horário de Execução *'),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectTime(context, om.startTime, (val) {
                            onChanged(om.copyWith(startTime: val));
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: _boxDecoration(isDark),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Início: ${om.startTime.isEmpty ? '--:--' : om.startTime}'),
                                const Icon(Icons.access_time, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectTime(context, om.endTime, (val) {
                            onChanged(om.copyWith(endTime: val));
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: _boxDecoration(isDark),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Término: ${om.endTime.isEmpty ? '--:--' : om.endTime}'),
                                const Icon(Icons.access_time, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (horasTrabalhadas.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: accentPurple.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: accentPurple.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '⏳ Horas Trabalhadas:',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            horasTrabalhadas,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: primaryBlue,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 14),

                  // Houve Parada?
                  _buildLabel('⛔ Houve parada do equipamento?'),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            onChanged(om.copyWith(hasStoppage: true));
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: om.hasStoppage
                                ? Colors.red.shade100
                                : (isDark ? Colors.grey.shade900 : Colors.white),
                            side: BorderSide(
                              color: om.hasStoppage ? Colors.red : Colors.grey.shade400,
                              width: om.hasStoppage ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            'Sim',
                            style: TextStyle(
                              color: om.hasStoppage ? Colors.red.shade800 : null,
                              fontWeight: om.hasStoppage ? FontWeight.bold : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            onChanged(om.copyWith(
                              hasStoppage: false,
                              stoppageStartTime: '',
                              stoppageEndTime: '',
                            ));
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: !om.hasStoppage
                                ? cmocGreen.withValues(alpha: 0.15)
                                : (isDark ? Colors.grey.shade900 : Colors.white),
                            side: BorderSide(
                              color: !om.hasStoppage ? cmocGreen : Colors.grey.shade400,
                              width: !om.hasStoppage ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            'Não',
                            style: TextStyle(
                              color: !om.hasStoppage ? cmocGreen : null,
                              fontWeight: !om.hasStoppage ? FontWeight.bold : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (om.hasStoppage) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectTime(context, om.stoppageStartTime, (val) {
                              onChanged(om.copyWith(stoppageStartTime: val));
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: _boxDecoration(isDark),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Início: ${om.stoppageStartTime.isEmpty ? '--:--' : om.stoppageStartTime}'),
                                  const Icon(Icons.access_time, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectTime(context, om.stoppageEndTime, (val) {
                              onChanged(om.copyWith(stoppageEndTime: val));
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: _boxDecoration(isDark),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Retorno: ${om.stoppageEndTime.isEmpty ? '--:--' : om.stoppageEndTime}'),
                                  const Icon(Icons.access_time, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (horasParada.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '🔴 Horas de Parada:',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                            Text(
                              horasParada,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],

                  const SizedBox(height: 12),

                  // Status
                  _buildLabel('🚦 Status *'),
                  DropdownButtonFormField<String>(
                    initialValue: MechanicalConstants.statusOptions.contains(om.status)
                        ? om.status
                        : null,
                    decoration: _inputDecoration('— Selecione —'),

                    items: MechanicalConstants.statusOptions
                        .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        onChanged(om.copyWith(status: val));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpecificTasks(BuildContext context, bool isDark) {
    final manut = om.maintenanceType;
    final equip = om.equipmentType;

    // Preventiva + Bomba
    if (manut == 'Preventiva' && equip == 'Bomba') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💧 Tarefas — Bomba', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _buildToggleRow('Feito a troca (gaxeta)?', 'troca-gaxeta'),
        ],
      );
    }

    // Preditiva + Bomba/Motor
    if (manut == 'Preditiva' && (equip == 'Bomba' || equip == 'Motor')) {
      final predList = (om.tasks['predTarefas'] ?? '').split(',').where((e) => e.isNotEmpty).toList();
      final hasVibracao = predList.contains('vibracao');
      final hasLaser = predList.contains('laser');
      final hasOutro = predList.contains('outro');

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🔍 Tarefas — Preditiva', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _buildChoiceButton('📊 Análise de vibração', hasVibracao, () => _togglePredTask('vibracao')),
          const SizedBox(height: 4),
          _buildChoiceButton('📐 Alinhamento a laser', hasLaser, () => _togglePredTask('laser')),
          const SizedBox(height: 4),
          _buildChoiceButton('✏️ Outro', hasOutro, () => _togglePredTask('outro')),
          if (hasVibracao) ...[
            const SizedBox(height: 10),
            _buildLabel('⚡ Velocidade *'),
            TextFormField(
              initialValue: om.vibrationSpeed,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _inputDecoration('Digite a velocidade...'),
              onChanged: (val) => onChanged(om.copyWith(vibrationSpeed: val)),
            ),
            const SizedBox(height: 8),
            _buildLabel('🔧 GE *'),
            TextFormField(
              initialValue: om.vibrationGe,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _inputDecoration('Digite o GE...'),
              onChanged: (val) => onChanged(om.copyWith(vibrationGe: val)),
            ),
            const SizedBox(height: 8),
            _buildLabel('🌡️ Temperatura *'),
            TextFormField(
              initialValue: om.vibrationTemp,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _inputDecoration('Digite a temperatura...'),
              onChanged: (val) => onChanged(om.copyWith(vibrationTemp: val)),
            ),
          ],
          if (hasOutro) ...[
            const SizedBox(height: 8),
            TextFormField(
              initialValue: om.predOtherDesc,
              decoration: _inputDecoration('Descreva a tarefa preditiva...'),
              onChanged: (val) => onChanged(om.copyWith(predOtherDesc: val)),
            ),
          ],
        ],
      );
    }

    // Inspeção + Bomba
    if (manut == 'Inspeção' && equip == 'Bomba') {
      final isOleoSim = om.tasks['oleo'] == 'sim';
      final isGaxetaSim = om.tasks['gaxeta'] == 'sim';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💧 Tarefas — Bomba', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _buildToggleRow('Óleo contaminado?', 'oleo'),
          if (isOleoSim)
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 4, bottom: 4),
              child: _buildToggleRow('↳ Feito a troca?', 'troca-oleo'),
            ),
          _buildToggleRow('Gaxetas com folga?', 'gaxeta'),
          if (isGaxetaSim)
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 4, bottom: 4),
              child: _buildToggleRow('↳ Feito ajuste?', 'ajuste-gaxeta'),
            ),
          _buildToggleRow('Feito lubrificação da bomba?', 'lubr-bomba'),
          const SizedBox(height: 6),
          _build3StateRow('Água de Refrigeração', 'agua-refrig'),
          const SizedBox(height: 10),
          _buildLabel('📈 Pressão *'),
          TextFormField(
            initialValue: om.pressure,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: _inputDecoration('Digite a pressão...'),
            onChanged: (val) => onChanged(om.copyWith(pressure: val)),
          ),
          const SizedBox(height: 8),
          _buildLabel('⏱️ Horímetro *'),
          TextFormField(
            initialValue: om.horometer,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: _inputDecoration('Digite o horímetro...'),
            onChanged: (val) => onChanged(om.copyWith(horometer: val)),
          ),
        ],
      );
    }

    // Inspeção + Motor
    if (manut == 'Inspeção' && equip == 'Motor') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⚡ Tarefas — Motor', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _buildToggleRow('Feito lubrificação do motor?', 'lubr-motor'),
        ],
      );
    }

    // Inspeção + Ventilador
    if (manut == 'Inspeção' && equip == 'Ventilador') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🌀 Tarefas — Ventilador', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _buildToggleRow('Feito lubrificação do ventilador?', 'lubr-vent'),
        ],
      );
    }

    // Inspeção + Exaustor
    if (manut == 'Inspeção' && equip == 'Exaustor') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💨 Tarefas — Exaustor', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _buildToggleRow('Feito lubrificação do exaustor?', 'lubr-exaust'),
          _buildToggleRow('Feito torque de parafusos?', 'torque-paraf'),
        ],
      );
    }

    // Corretiva
    if (manut == 'Corretiva') {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red.shade50.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: Colors.red.shade700, width: 3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🚨 Corretiva — Detalhamento', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 8),
            _buildLabel('⚠️ Causa *', onFillNa: () => onChanged(om.copyWith(cause: 'N/A'))),
            TextFormField(
              key: ValueKey('cause_${om.cause}'),
              initialValue: om.cause,
              maxLines: 2,
              decoration: _inputDecoration('Descreva a causa ou clique em N/A...'),
              onChanged: (val) => onChanged(om.copyWith(cause: val)),
            ),
            const SizedBox(height: 8),
            _buildLabel('🔍 Sintoma *', onFillNa: () => onChanged(om.copyWith(symptom: 'N/A'))),
            TextFormField(
              key: ValueKey('symptom_${om.symptom}'),
              initialValue: om.symptom,
              maxLines: 2,
              decoration: _inputDecoration('Descreva o sintoma ou clique em N/A...'),
              onChanged: (val) => onChanged(om.copyWith(symptom: val)),
            ),
            const SizedBox(height: 8),
            _buildLabel('🛠️ Intervenção', onFillNa: () => onChanged(om.copyWith(intervention: 'N/A'))),
            TextFormField(
              key: ValueKey('interv_${om.intervention}'),
              initialValue: om.intervention,
              maxLines: 2,
              decoration: _inputDecoration('Descreva a intervenção ou clique em N/A...'),
              onChanged: (val) => onChanged(om.copyWith(intervention: val)),
            ),

          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildToggleRow(String label, String taskKey) {
    final currentVal = om.tasks[taskKey] ?? '';
    final isSim = currentVal == 'sim';
    final isNao = currentVal == 'nao';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Row(
            children: [
              _buildSmallButton('Sim', isSim, Colors.green, () {
                _updateTask(taskKey, isSim ? '' : 'sim');
              }),
              const SizedBox(width: 4),
              _buildSmallButton('Não', isNao, Colors.red, () {
                _updateTask(taskKey, isNao ? '' : 'nao');
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _build3StateRow(String label, String taskKey) {
    final currentVal = om.tasks[taskKey] ?? '';
    final isOk = currentVal == 'ok';
    final isCorrigido = currentVal == 'corrigido';
    final isPendente = currentVal == 'pendente';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: _buildSmallButton('OK', isOk, Colors.green, () {
                _updateTask(taskKey, isOk ? '' : 'ok');
              }),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildSmallButton('Corrigido', isCorrigido, Colors.blue, () {
                _updateTask(taskKey, isCorrigido ? '' : 'corrigido');
              }),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildSmallButton('Pendente', isPendente, Colors.orange, () {
                _updateTask(taskKey, isPendente ? '' : 'pendente');
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChoiceButton(String title, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF74BE45).withValues(alpha: 0.2) : Colors.grey.shade100,
          border: Border.all(
            color: isSelected ? const Color(0xFF74BE45) : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              size: 18,
              color: isSelected ? const Color(0xFF74BE45) : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFF23005B) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallButton(String title, bool active, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: 0.15) : Colors.white,
          border: Border.all(
            color: active ? color : Colors.grey.shade300,
            width: active ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active ? color : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, {VoidCallback? onFillNa}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          if (onFillNa != null)
            InkWell(
              onTap: onFillNa,
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: const Text(
                  'N/A',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }


  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: const OutlineInputBorder(),
    );
  }

  BoxDecoration _boxDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF7F7FA),
      border: Border.all(color: isDark ? Colors.grey.shade700 : const Color(0xFFE0E0E8)),
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade700)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
