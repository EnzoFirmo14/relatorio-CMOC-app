import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/report_form_state.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/image_service.dart';
import '../pages/photo_preview_page.dart';

class WorkOrderCard extends StatelessWidget {
  final WorkOrderState os;
  final void Function(WorkOrderState) onUpdate;
  final VoidCallback onDelete;

  const WorkOrderCard({
    super.key,
    required this.os,
    required this.onUpdate,
    required this.onDelete,
  });

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final initialTime = isStart ? os.startTime : os.endTime;
    TimeOfDay initial = const TimeOfDay(hour: 8, minute: 0);
    
    if (initialTime.isNotEmpty) {
      try {
        final parts = initialTime.split(':');
        initial = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      } catch (_) {}
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final hourStr = picked.hour.toString().padLeft(2, '0');
      final minStr = picked.minute.toString().padLeft(2, '0');
      final timeStr = '$hourStr:$minStr';
      
      onUpdate(
        isStart ? os.copyWith(startTime: timeStr) : os.copyWith(endTime: timeStr),
      );
    }
  }

  void _showMaterialsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: AppTheme.cardColorLight,
              title: const Text(
                'Materiais Utilizados',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: AppConstants.matOptions.length,
                  itemBuilder: (context, index) {
                    final mat = AppConstants.matOptions[index];
                    final isChecked = os.materialsUsed.contains(mat);
                    return CheckboxListTile(
                      title: Text(
                        mat,
                        style: const TextStyle(fontSize: 14.0, fontFamily: 'monospace'),
                      ),
                      value: isChecked,
                      activeColor: AppTheme.primaryPurple,
                      onChanged: (bool? val) {
                        final List<String> updatedList = List<String>.from(os.materialsUsed);
                        if (val == true) {
                          updatedList.add(mat);
                        } else {
                          updatedList.remove(mat);
                        }
                        setStateDialog(() {});
                        onUpdate(os.copyWith(materialsUsed: updatedList));
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Causas dependem da manutencao selecionada
    final causas = AppConstants.causaMap[os.maintenanceType] ?? [];
    final invalidTime = os.startTime.isNotEmpty && os.endTime.isNotEmpty && os.durationInMinutes <= 0;

    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // CABECALHO DA OS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withValues(alpha: 0.07),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14.0),
                topRight: Radius.circular(14.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📋 ${os.number}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 13.0,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                      if (os.location.isNotEmpty)
                        Text(
                          '📍 ${os.location}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11.0,
                            color: AppTheme.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20, color: AppTheme.textMuted),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: AppTheme.cardColorLight,
                        title: const Text('Excluir Ordem de Serviço?'),
                        content: Text('Tem certeza de que deseja excluir a OS "${os.number} — ${os.location}"? Esta ação não pode ser desfeita.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onDelete();
                            },
                            style: TextButton.styleFrom(foregroundColor: AppTheme.redAlert),
                            child: const Text('Excluir'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // CORPO DO FORMULARIO DA OS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Tipo de Manutencao
                const Text(
                  'TIPO DE MANUTENÇÃO *',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10.0,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentPurple,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  initialValue: os.maintenanceType.isEmpty ? null : os.maintenanceType,
                  decoration: const InputDecoration(hintText: '— Selecione —'),
                  items: AppConstants.manutOptions.map((opt) {
                    return DropdownMenuItem(value: opt, child: Text(opt));
                  }).toList(),
                  onChanged: (val) {
                    onUpdate(os.copyWith(
                      maintenanceType: val ?? '',
                      cause: '', // Reseta causa ao trocar tipo
                    ));
                  },
                ),
                const SizedBox(height: 12),

                // 2. Causa
                const Text(
                  'CAUSA',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10.0,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentPurple,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  key: ValueKey(os.maintenanceType), // Forca recriacao quando tipo muda
                  initialValue: (os.cause.isEmpty || !causas.contains(os.cause)) ? null : os.cause,
                  decoration: InputDecoration(
                    hintText: os.maintenanceType.isEmpty 
                        ? '— Selecione o Tipo primeiro —' 
                        : '— Selecione a Causa —',
                  ),
                  items: causas.map((opt) {
                    return DropdownMenuItem(value: opt, child: Text(opt));
                  }).toList(),
                  onChanged: os.maintenanceType.isEmpty 
                      ? null 
                      : (val) {
                          onUpdate(os.copyWith(cause: val ?? ''));
                        },
                ),
                const SizedBox(height: 12),

                // 3. Atividades Realizadas
                const Text(
                  'ATIVIDADES REALIZADAS *',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10.0,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentPurple,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  initialValue: os.activities,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Descreva as atividades desta OS...',
                  ),
                  onChanged: (val) {
                    onUpdate(os.copyWith(activities: val));
                  },
                ),
                const SizedBox(height: 12),

                // 4. Materiais Utilizados (Multi-Select)
                const Text(
                  'MATERIAIS UTILIZADOS',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10.0,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentPurple,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => _showMaterialsDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: os.materialsUsed.isEmpty
                        ? const Text(
                            '— Selecione um ou mais —',
                            style: TextStyle(color: AppTheme.textFaint, fontSize: 14.0),
                          )
                        : Wrap(
                            spacing: 6.0,
                            runSpacing: 4.0,
                            children: os.materialsUsed.map((mat) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryPurple.withValues(alpha: 0.15),
                                  border: Border.all(color: AppTheme.primaryPurple.withValues(alpha: 0.3)),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      mat,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.primaryPurple,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () {
                                        final list = List<String>.from(os.materialsUsed)..remove(mat);
                                        onUpdate(os.copyWith(materialsUsed: list));
                                      },
                                      child: const Icon(Icons.close, size: 10, color: AppTheme.textMuted),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                ),
                const SizedBox(height: 8),

                // Qtd metros / peças
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Qtd. por Metros',
                            style: TextStyle(fontSize: 10.0, fontFamily: 'monospace', color: AppTheme.textFaint),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            initialValue: os.quantityMeters,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(hintText: '0'),
                            onChanged: (val) => onUpdate(os.copyWith(quantityMeters: val)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Qtd. por Peça',
                            style: TextStyle(fontSize: 10.0, fontFamily: 'monospace', color: AppTheme.textFaint),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            initialValue: os.quantityPieces,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(hintText: '0'),
                            onChanged: (val) => onUpdate(os.copyWith(quantityPieces: val)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 5. Horario (Inicio / Término)
                const Text(
                  'HORÁRIO *',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10.0,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentPurple,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectTime(context, true),
                        child: AbsorbPointer(
                          child: TextFormField(
                            key: ValueKey('start-${os.startTime}'),
                            initialValue: os.startTime.isEmpty ? '—' : os.startTime,
                            decoration: const InputDecoration(
                              labelText: 'Início',
                              prefixIcon: Icon(Icons.access_time, size: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectTime(context, false),
                        child: AbsorbPointer(
                          child: TextFormField(
                            key: ValueKey('end-${os.endTime}'),
                            initialValue: os.endTime.isEmpty ? '—' : os.endTime,
                            decoration: const InputDecoration(
                              labelText: 'Término',
                              prefixIcon: Icon(Icons.access_time_filled, size: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (os.durationFormatted.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withValues(alpha: 0.12),
                          border: Border.all(color: AppTheme.primaryPurple.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(
                          os.durationFormatted,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (invalidTime) ...[
                  const SizedBox(height: 4),
                  const Text(
                    '⚠️ Término deve ser depois do Início',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10.0,
                      color: AppTheme.redAlert,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 12),

                // 6. Status da OS
                const Text(
                  'STATUS *',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10.0,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentPurple,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  initialValue: os.status.isEmpty ? null : os.status,
                  decoration: const InputDecoration(hintText: '— Selecione —'),
                  items: AppConstants.statusOptions.map((opt) {
                    return DropdownMenuItem(value: opt, child: Text(opt));
                  }).toList(),
                  onChanged: (val) {
                    onUpdate(os.copyWith(status: val ?? ''));
                  },
                ),
                const SizedBox(height: 14),

                // 6.5. Fotos / Anexos
                const Text(
                  'FOTOS / ANEXOS',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10.0,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentPurple,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                _buildPhotosSection(context),
                const SizedBox(height: 14),

                // 7. Status Chips da OS
                const Divider(color: AppTheme.borderLight, height: 1),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'STATUS OS:',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textFaint,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['Rascunho', 'Em Andamento', 'Finalizada'].map((st) {
                          final isSel = os.osStatus == st;
                          Color bg = Colors.black.withValues(alpha: 0.03);
                          Color txt = AppTheme.textMuted;
                          Color bdr = AppTheme.borderLight;

                          if (isSel) {
                            if (st == 'Rascunho') {
                              bg = AppTheme.textMuted.withValues(alpha: 0.12);
                              txt = AppTheme.textMuted;
                              bdr = AppTheme.textMuted;
                            } else if (st == 'Em Andamento') {
                              bg = AppTheme.primaryPurple.withValues(alpha: 0.15);
                              txt = AppTheme.primaryPurple;
                              bdr = AppTheme.primaryPurple;
                            } else {
                              bg = AppTheme.greenSuccess.withValues(alpha: 0.14);
                              txt = AppTheme.greenSuccess;
                              bdr = AppTheme.greenSuccess;
                            }
                          }

                          return GestureDetector(
                            onTap: () => onUpdate(os.copyWith(osStatus: st)),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: bg,
                                border: Border.all(color: bdr, width: 1.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                st,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w700,
                                  color: txt,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosSection(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Galeria de miniaturas de fotos existentes
          ...os.photoPaths.map((relativePath) {
            return FutureBuilder<String>(
              future: ImageService.getAbsolutePath(relativePath),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    width: 90,
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }

                final absolutePath = snapshot.data!;
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PhotoPreviewPage(imagePath: absolutePath),
                          ),
                        );
                      },
                      child: Container(
                        width: 90,
                        height: 90,
                        margin: const EdgeInsets.only(right: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: AppTheme.borderLight),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7.0),
                          child: Hero(
                            tag: absolutePath,
                            child: Image.file(
                              File(absolutePath),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.broken_image, color: AppTheme.textFaint),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 12,
                      child: GestureDetector(
                        onTap: () async {
                          // Remove do estado (que chama autosave)
                          final updatedPhotos = List<String>.from(os.photoPaths)..remove(relativePath);
                          onUpdate(os.copyWith(photoPaths: updatedPhotos));
                          
                          // Apaga arquivo físico em background
                          await ImageService.deleteImageFile(relativePath);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }),

          // Botão de adicionar foto
          GestureDetector(
            onTap: () => _showAddPhotoBottomSheet(context),
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: AppTheme.primaryPurple.withValues(alpha: 0.4),
                  style: BorderStyle.solid, // Dotted style isn't native, solid purple looks very clean here
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, color: AppTheme.primaryPurple, size: 24),
                  SizedBox(height: 4),
                  Text(
                    'Add Foto',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPhotoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded, color: AppTheme.primaryPurple),
                title: const Text('Câmera (Tirar Foto)'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final path = await ImageService.pickAndCompressImage(ImageSource.camera);
                  if (path != null) {
                    onUpdate(os.copyWith(photoPaths: [...os.photoPaths, path]));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: AppTheme.primaryPurple),
                title: const Text('Galeria (Escolher Foto)'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final path = await ImageService.pickAndCompressImage(ImageSource.gallery);
                  if (path != null) {
                    onUpdate(os.copyWith(photoPaths: [...os.photoPaths, path]));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
