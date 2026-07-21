import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AutocompleteOperator extends StatelessWidget {
  final List<Map<String, String>> candidates;
  final List<String> currentRegistrationsInUse;
  final String initialValue;
  final void Function(String name, String registration) onSelected;
  final VoidCallback? onCleared;

  const AutocompleteOperator({
    super.key,
    required this.candidates,
    required this.currentRegistrationsInUse,
    required this.initialValue,
    required this.onSelected,
    this.onCleared,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RawAutocomplete<Map<String, String>>(
          initialValue: TextEditingValue(text: initialValue),
          optionsBuilder: (TextEditingValue textEditingValue) {
            final query = textEditingValue.text.trim().toLowerCase();
            if (query.isEmpty) {
              return const Iterable<Map<String, String>>.empty();
            }
            return candidates.where((colab) {
              final nome = (colab['nome'] ?? '').toLowerCase();
              final mat = (colab['mat'] ?? '').toLowerCase();
              return nome.contains(query) || mat.contains(query);
            });
          },
          displayStringForOption: (option) => option['nome'] ?? '',
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            // Sincronizar controller se o valor inicial mudar externamente
            if (textEditingController.text != initialValue && initialValue.isEmpty) {
              textEditingController.text = '';
            }
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              onFieldSubmitted: (value) => onFieldSubmitted(),
              decoration: InputDecoration(
                hintText: 'Buscar colaborador...',
                suffixIcon: textEditingController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          textEditingController.clear();
                          if (onCleared != null) onCleared!();
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                if (val.trim().isEmpty && onCleared != null) {
                  onCleared!();
                }
              },
            );
          },
          optionsViewBuilder: (
            BuildContext context,
            AutocompleteOnSelected<Map<String, String>> onSelectedCall,
            Iterable<Map<String, String>> options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 8.0,
                color: AppTheme.cardColorLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: AppTheme.borderLight),
                ),
                child: Container(
                  width: constraints.maxWidth,
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (_, __) => const Divider(
                      color: AppTheme.borderLight,
                      height: 1,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final option = options.elementAt(index);
                      final nome = option['nome'] ?? '';
                      final mat = option['mat'] ?? '';
                      final isAlreadySelected = currentRegistrationsInUse.contains(mat);

                      return InkWell(
                        onTap: isAlreadySelected
                            ? null
                            : () {
                                onSelectedCall(option);
                                onSelected(nome, mat);
                              },
                        child: Opacity(
                          opacity: isAlreadySelected ? 0.45 : 1.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    nome,
                                    style: const TextStyle(
                                      fontSize: 13.0,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (isAlreadySelected)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.redAlert.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'já adicionado',
                                      style: TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 10.0,
                                        color: AppTheme.redAlert,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      mat,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 11.0,
                                        color: AppTheme.primaryPurple,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
