import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final colors = _getColorsForType(type);
    final icon = _getIconForType(type);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: colors.backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        elevation: 8,
        action: actionLabel != null && onActionPressed != null
            ? SnackBarAction(label: actionLabel, textColor: Colors.white, backgroundColor: colors.actionColor, onPressed: onActionPressed)
            : null,
      ),
    );
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(context, message: message, type: SnackBarType.success, duration: duration, actionLabel: actionLabel, onActionPressed: onActionPressed);
  }

  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(context, message: message, type: SnackBarType.error, duration: duration, actionLabel: actionLabel, onActionPressed: onActionPressed);
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(context, message: message, type: SnackBarType.warning, duration: duration, actionLabel: actionLabel, onActionPressed: onActionPressed);
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(context, message: message, type: SnackBarType.info, duration: duration, actionLabel: actionLabel, onActionPressed: onActionPressed);
  }

  static _SnackBarColors _getColorsForType(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return _SnackBarColors(backgroundColor: const Color(0xFF4CAF50), actionColor: const Color(0xFF2E7D32));
      case SnackBarType.error:
        return _SnackBarColors(backgroundColor: const Color(0xFFE53935), actionColor: const Color(0xFFC62828));
      case SnackBarType.warning:
        return _SnackBarColors(backgroundColor: const Color(0xFFFF9800), actionColor: const Color(0xFFE65100));
      case SnackBarType.info:
        return _SnackBarColors(backgroundColor: const Color(0xFF2196F3), actionColor: const Color(0xFF1565C0));
    }
  }

  static IconData _getIconForType(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle_outline;
      case SnackBarType.error:
        return Icons.error_outline;
      case SnackBarType.warning:
        return Icons.warning_amber_outlined;
      case SnackBarType.info:
        return Icons.info_outline;
    }
  }
}

enum SnackBarType { success, error, warning, info }

class _SnackBarColors {
  final Color backgroundColor;
  final Color actionColor;

  _SnackBarColors({required this.backgroundColor, required this.actionColor});
}
