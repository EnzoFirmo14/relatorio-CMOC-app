import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AddColabDialog extends StatefulWidget {
  final Function(String name, String registration) onSave;

  const AddColabDialog({
    super.key,
    required this.onSave,
  });

  @override
  State<AddColabDialog> createState() => _AddColabDialogState();
}

class _AddColabDialogState extends State<AddColabDialog> {
  final _matController = TextEditingController();
  final _nomeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _matController.dispose();
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.cardColorLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(color: AppTheme.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '➕ Cadastrar Colaborador',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'MATRÍCULA',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10.0,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMuted,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _matController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Ex: 99300001',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Matrícula é obrigatória';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'NOME COMPLETO',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10.0,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMuted,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _nomeController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Ex: João Silva Santos',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nome completo é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onSave(
                            _nomeController.text.trim(),
                            _matController.text.trim(),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Cadastrar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
