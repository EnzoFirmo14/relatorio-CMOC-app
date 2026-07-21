import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/cmoc_logo.dart';
import '../../../report_form/domain/entities/report_entity.dart';
import '../../../report_form/presentation/controllers/report_form_controller.dart';
import '../../../export/presentation/widgets/export_options_dialog.dart';
import '../controllers/history_controller.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyControllerProvider);
    final controller = ref.read(historyControllerProvider.notifier);
    final formController = ref.read(reportFormControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const CmocLogo(showSubtitle: true),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
      ),
      body: Column(
        children: [
          // ─── BARRA DE PESQUISA ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: controller.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Pesquisar executante, matrícula, OS, local...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
                filled: true,
                fillColor: AppTheme.cardColorLight,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.borderLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.primaryPurple),
                ),
              ),
            ),
          ),

          // ─── FILTRO DE STATUS ──────────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                _buildStatusChip(context, controller, state, 'Todos'),
                const SizedBox(width: 8),
                _buildStatusChip(context, controller, state, 'Rascunho'),
                const SizedBox(width: 8),
                _buildStatusChip(context, controller, state, 'Em Andamento'),
                const SizedBox(width: 8),
                _buildStatusChip(context, controller, state, 'Finalizada'),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ─── LISTA DE REGISTROS ─────────────────────────────────────────────
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.filteredReports.isEmpty
                    ? Center(
                        child: Text(
                          state.searchQuery.isNotEmpty || state.statusFilter != null
                              ? '🔍 Nenhum resultado encontrado.'
                              : 'Nenhum relatório salvo ainda.',
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12.0),
                        itemCount: state.filteredReports.length,
                        itemBuilder: (context, index) {
                          final report = state.filteredReports[index];
                          return _buildReportCard(
                            context,
                            report,
                            formController,
                            controller,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
    BuildContext context,
    HistoryController controller,
    HistoryState state,
    String label,
  ) {
    final isSelected =
        (label == 'Todos' && state.statusFilter == null) ||
        (state.statusFilter == label);

    Color activeColor = AppTheme.primaryPurple;
    if (label == 'Rascunho') activeColor = Colors.grey;
    if (label == 'Finalizada') activeColor = AppTheme.greenSuccess;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: activeColor.withValues(alpha: 0.15),
      disabledColor: Colors.transparent,
      side: BorderSide(
        color: isSelected ? activeColor : AppTheme.borderLight,
        width: 1,
      ),
      labelStyle: TextStyle(
        color: isSelected ? activeColor : AppTheme.textMuted,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      backgroundColor: Colors.transparent,
      onSelected: (_) => controller.setStatusFilter(label),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    ReportEntity report,
    ReportFormController formController,
    HistoryController historyController,
  ) {
    final dateStr = _formatDate(report.date);
    final hasOperators = report.operators.isNotEmpty;
    final osCount = report.workOrders.length;

    // Definição de cores e ícones baseados no status
    String statusLabel = 'Rascunho';
    IconData statusIcon = Icons.edit_note;
    Color statusColor = Colors.grey;

    if (report.syncStatus == ReportSyncStatus.pending) {
      statusLabel = 'Em Andamento';
      statusIcon = Icons.sync;
      statusColor = AppTheme.primaryPurple;
    } else if (report.syncStatus == ReportSyncStatus.synced) {
      statusLabel = 'Finalizada';
      statusIcon = Icons.check_circle;
      statusColor = AppTheme.greenSuccess;
    }

    IconData syncCloudIcon = Icons.cloud_done_rounded;
    Color syncCloudColor = AppTheme.greenSuccess;
    if (report.syncStatus == ReportSyncStatus.pending) {
      syncCloudIcon = Icons.cloud_upload_rounded;
      syncCloudColor = Colors.amber.shade900;
    } else if (report.syncStatus == ReportSyncStatus.error) {
      syncCloudIcon = Icons.cloud_off_rounded;
      syncCloudColor = AppTheme.redAlert;
    } else if (report.syncStatus == ReportSyncStatus.draft) {
      syncCloudIcon = Icons.cloud_queue_rounded;
      syncCloudColor = AppTheme.textFaint;
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppTheme.borderLight),
      ),
      color: AppTheme.cardColorLight,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showActionsDialog(context, report, formController, historyController),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER: Data, Turno, Turma e Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: AppTheme.textMuted),
                        const SizedBox(width: 6),
                        Text(
                          dateStr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppTheme.textDark,
                          ),
                        ),
                        if (report.shift.isNotEmpty || report.team.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text(
                            '•  Turno ${report.shift} • Turma ${report.team}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 12, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          statusLabel,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(syncCloudIcon, size: 12, color: syncCloudColor),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: AppTheme.borderLight, height: 20),

              // OPERADORES / EXECUTANTES
              if (hasOperators) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: report.operators.map((op) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppTheme.borderLight.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person, size: 12, color: AppTheme.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            op.name,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          if (op.registration.isNotEmpty) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0.5),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                op.registration,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: AppTheme.primaryPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],

              // RESUMO DE OSs e EQUIPAMENTO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.assignment_outlined, size: 14, color: AppTheme.textMuted),
                      const SizedBox(width: 6),
                      Text(
                        '$osCount OS${osCount != 1 ? 's' : ''} registrada${osCount != 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (report.globalEquipment.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        const Icon(Icons.build_circle_outlined, size: 14, color: AppTheme.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          report.globalEquipment,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  // Botão de deletar na lateral direita
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20, color: AppTheme.textFaint),
                    onPressed: () => _confirmDelete(context, report, historyController),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    splashRadius: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActionsDialog(
    BuildContext context,
    ReportEntity report,
    ReportFormController formController,
    HistoryController historyController,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: AppTheme.primaryBlue),
                  title: const Text('Exportar PDF & WhatsApp'),
                  subtitle: const Text('Gerar documento em PDF, enviar ou imprimir'),
                  onTap: () {
                    Navigator.pop(context); // fecha bottom sheet
                    ExportOptionsDialog.show(context, report);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit, color: AppTheme.primaryBlue),
                  title: const Text('Editar Relatório'),
                  subtitle: const Text('Carregar e modificar dados no formulário'),
                  onTap: () {
                    formController.loadReport(report);
                    Navigator.pop(context); // fecha bottom sheet
                    Navigator.pop(context); // volta ao formulário
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.copy, color: AppTheme.greenSuccess),
                  title: const Text('Duplicar como Modelo'),
                  subtitle: const Text('Copia executantes, OSs e campos com data de hoje'),
                  onTap: () async {
                    await formController.duplicateReport(report);
                    if (!context.mounted) return;
                    Navigator.pop(context); // fecha bottom sheet
                    Navigator.pop(context); // volta ao formulário
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Excluir Relatório'),
                  subtitle: const Text('Remover definitivamente do banco local'),
                  onTap: () {
                    Navigator.pop(context); // fecha bottom sheet
                    _confirmDelete(context, report, historyController);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    ReportEntity report,
    HistoryController historyController,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Relatório?'),
        content: const Text(
          'Esta ação removerá este relatório do banco de dados permanentemente e não poderá ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              await historyController.deleteReport(report.uuid);
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🗑 Relatório removido com sucesso')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d/$m/$y';
  }
}
