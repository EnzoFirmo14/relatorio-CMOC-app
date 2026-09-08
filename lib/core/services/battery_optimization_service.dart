import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BatteryOptimizationService {
  static const MethodChannel _channel =
      MethodChannel('com.cmoc.relatorio/battery_optimization');

  /// Verifica se o aplicativo já possui permissão de execução irrestrita em segundo plano no Android.
  static Future<bool> isIgnoringBatteryOptimizations() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return true;
    }
    try {
      final bool? isIgnoring =
          await _channel.invokeMethod<bool>('isIgnoringBatteryOptimizations');
      return isIgnoring ?? false;
    } catch (e) {
      debugPrint('[BatteryOptimizationService] Erro ao verificar isenção: $e');
      return true;
    }
  }

  /// Solicita nativamente ao usuário a isenção de otimização de bateria.
  static Future<bool> requestIgnoreBatteryOptimizations() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return true;
    }
    try {
      final bool? result =
          await _channel.invokeMethod<bool>('requestIgnoreBatteryOptimizations');
      return result ?? false;
    } catch (e) {
      debugPrint('[BatteryOptimizationService] Erro ao solicitar isenção: $e');
      return false;
    }
  }

  /// Exibe um diálogo moderno com a identidade visual CMOC caso a sincronização em segundo plano ainda não esteja liberada.
  static Future<void> showOptimizationPromptIfNeeded(BuildContext context) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

    try {
      final isIgnoring = await isIgnoringBatteryOptimizations();
      if (isIgnoring) return;

      final prefs = await SharedPreferences.getInstance();
      final lastPrompt = prefs.getInt('battery_prompt_last_ts') ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;

      // Não incomodar repetidamente caso tenha recusado recentemente (espera 3 dias)
      if (now - lastPrompt < 3 * 24 * 60 * 60 * 1000) {
        return;
      }

      if (!context.mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5C3FA3).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.cloud_sync_rounded,
                    color: Color(0xFF5C3FA3),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'Sincronização Automática',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF23005B),
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Para que seus relatórios salvos offline (Elétrica, Mecânica, Bombeamento) sejam enviados sozinhos assim que você conectar à internet — sem precisar abrir o app manualmente —, autorize a execução em segundo plano.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF74BE45).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF74BE45).withOpacity(0.3),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Color(0xFF74BE45), size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Envio 100% automático e seguro para a nuvem CMOC.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF23005B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await prefs.setInt('battery_prompt_last_ts', DateTime.now().millisecondsSinceEpoch);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
                child: Text(
                  'Agora não',
                  style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF23005B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  elevation: 0,
                ),
                onPressed: () async {
                  await prefs.setInt('battery_prompt_last_ts', DateTime.now().millisecondsSinceEpoch);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                  await requestIgnoreBatteryOptimizations();
                },
                child: const Text(
                  'Ativar Sincronização',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      debugPrint('[BatteryOptimizationService] Erro ao abrir prompt: $e');
    }
  }
}
