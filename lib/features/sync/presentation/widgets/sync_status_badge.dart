import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../controllers/sync_controller.dart';

class SyncStatusBadge extends ConsumerWidget {
  const SyncStatusBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncControllerProvider);
    final controller = ref.read(syncControllerProvider.notifier);

    Color bg;
    Color fg;
    IconData icon;
    String label;

    if (syncState.isSyncing) {
      bg = AppTheme.primaryPurple.withValues(alpha: 0.15);
      fg = AppTheme.primaryPurple;
      icon = Icons.sync;
      label = 'Enviando...';
    } else if (!syncState.isOnline) {
      bg = Colors.grey.withValues(alpha: 0.15);
      fg = AppTheme.textMuted;
      icon = Icons.cloud_off_rounded;
      label = syncState.pendingCount > 0
          ? 'Offline (${syncState.pendingCount})'
          : 'Offline';
    } else if (syncState.hasError) {
      bg = AppTheme.redAlert.withValues(alpha: 0.15);
      fg = AppTheme.redAlert;
      icon = Icons.cloud_sync_rounded;
      label = 'Reenviar (${syncState.pendingCount})';
    } else if (syncState.pendingCount > 0) {
      bg = Colors.amber.withValues(alpha: 0.2);
      fg = Colors.amber.shade900;
      icon = Icons.cloud_upload_rounded;
      label = 'Pendente (${syncState.pendingCount})';
    } else {
      bg = AppTheme.greenSuccess.withValues(alpha: 0.15);
      fg = AppTheme.greenSuccess;
      icon = Icons.cloud_done_rounded;
      label = 'Sincronizado';
    }

    return GestureDetector(
      onTap: () {
        if (!syncState.isSyncing) {
          controller.triggerSync();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: fg.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (syncState.isSyncing)
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(fg),
                ),
              )
            else
              Icon(icon, size: 14, color: fg),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10.0,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
