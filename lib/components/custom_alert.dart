import 'package:flutter/material.dart';
import '../themes/color.dart';

class ElegantAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String? cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final IconData icon;
  final Color iconColor;
  final bool isDestructive;

  const ElegantAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.onConfirm,
    this.cancelText,
    this.onCancel,
    this.icon = Icons.info_outline,
    this.iconColor = AppColors.deepBlueAccent,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color dialogBackgroundColor =
        isDark ? AppColors.gunmetal : AppColors.softWhite;
    final Color contentColor =
        isDark
            ? AppColors.softWhite.withOpacity(0.85)
            : AppColors.charcoal.withOpacity(0.85);
    final Color titleColor = isDark ? AppColors.softWhite : AppColors.deepBlue;

    // 🔒 PERUBAHAN 1: Gunakan PopScope agar tombol Back HP tidak berfungsi
    return PopScope(
      canPop: false, // Mengunci tombol back
      child: AlertDialog(
        backgroundColor: dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side:
              isDark
                  ? const BorderSide(
                    color: AppColors.deepBlueAccent,
                    width: 0.5,
                  )
                  : BorderSide.none,
        ),
        elevation: 10,
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withOpacity(0.1),
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(color: contentColor, fontSize: 14),
        ),
        // Mengatur padding agar tombol tidak mepet
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [_buildButtons(context, isDark)],
      ),
    );
  }

  Widget _buildButtons(BuildContext context, bool isDark) {
    Color buttonColor =
        isDestructive ? AppColors.crimson : AppColors.deepBlueAccent;

    Widget confirmButton = ElevatedButton(
      onPressed: onConfirm,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: AppColors.softWhite,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(
        confirmText,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    Widget? cancelButton;
    if (cancelText != null && onCancel != null) {
      cancelButton = OutlinedButton(
        onPressed: onCancel,
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? AppColors.softWhite : AppColors.gunmetal,
          side: BorderSide(
            color:
                isDark
                    ? AppColors.softWhite.withOpacity(0.3)
                    : AppColors.gunmetal,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(cancelText!),
      );
    }

    // Menggunakan Row + Expanded agar layout tombol rapi dan tidak error ParentDataWidget
    return Row(
      children: [
        if (cancelButton != null) ...[
          Expanded(child: cancelButton),
          const SizedBox(width: 10),
        ],
        Expanded(child: confirmButton),
      ],
    );
  }

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String content,
    required String confirmText,
    required VoidCallback onConfirm,
    String? cancelText,
    VoidCallback? onCancel,
    IconData icon = Icons.info_outline,
    Color iconColor = AppColors.deepBlueAccent,
    bool isDestructive = false,
  }) {
    return showGeneralDialog(
      context: context,
      // 🔒 PERUBAHAN 2: barrierDismissible false agar tidak bisa tutup klik luar
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: a1, curve: Curves.easeInOutBack),
          child: FadeTransition(opacity: a1, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return ElegantAlertDialog(
          title: title,
          content: content,
          confirmText: confirmText,
          onConfirm: onConfirm,
          cancelText: cancelText,
          onCancel: onCancel,
          icon: icon,
          iconColor: iconColor,
          isDestructive: isDestructive,
        );
      },
    );
  }
}
