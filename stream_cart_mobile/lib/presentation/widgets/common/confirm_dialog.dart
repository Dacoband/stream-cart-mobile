import 'package:flutter/material.dart';

/// Shows a polished confirmation dialog with subtle scale+fade animation.
/// Returns true when confirmed, false when cancelled, and null when dismissed.
Future<bool?> showConfirmDialog(
  BuildContext context, {
  String title = 'Xác nhận',
  String message = 'Bạn có chắc chắn?',
  String confirmText = 'Xác nhận',
  String cancelText = 'Hủy',
  IconData icon = Icons.help_outline,
  Color? highlightColor,
  bool barrierDismissible = true,
}) {
  final ColorScheme scheme = Theme.of(context).colorScheme;
  final Color accent = highlightColor ?? scheme.primary;

  return showGeneralDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'dismiss',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (context, anim1, anim2) {
      return const SizedBox.shrink(); // transitionBuilder builds the dialog
    },
    transitionBuilder: (context, animation, _, __) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return Opacity(
        opacity: curved.value,
        child: Transform.scale(
          scale: 0.96 + 0.04 * curved.value,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Dialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                  elevation: 0,
                  backgroundColor: scheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: accent, size: 28),
                        ),
                        const SizedBox(height: 16),
                        Text(title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Text(
                          message,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurface.withOpacity(0.85)),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text(cancelText),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accent,
                                  foregroundColor: scheme.onPrimary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                child: Text(confirmText),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
