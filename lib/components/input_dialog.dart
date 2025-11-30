import 'package:flutter/material.dart';
import '../themes/color.dart';

class InputDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final String? labelText;
  final String initialValue;
  final String confirmText;
  final String cancelText;
  final Function(String) onConfirm;
  final TextInputType keyboardType;
  final IconData icon;

  const InputDialog({
    super.key,
    required this.title,
    required this.onConfirm,
    this.hintText = "",
    this.labelText,
    this.initialValue = "",
    this.confirmText = "Simpan",
    this.cancelText = "Batal",
    this.keyboardType = TextInputType.text,
    this.icon = Icons.edit,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required Function(String) onConfirm,
    String hintText = "",
    String? labelText,
    String initialValue = "",
    String confirmText = "Simpan",
    TextInputType keyboardType = TextInputType.text,
    IconData icon = Icons.settings_input_antenna,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false, // Terkunci
      builder:
          (context) => InputDialog(
            title: title,
            onConfirm: onConfirm,
            hintText: hintText,
            labelText: labelText,
            initialValue: initialValue,
            confirmText: confirmText,
            keyboardType: keyboardType,
            icon: icon,
          ),
    );
  }

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🔒 KUNCI TOMBOL BACK
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: AppColors.gunmetal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.glassBorder, width: 1),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // HEADER ICON
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.midnight,
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Icon(
                    widget.icon,
                    color: AppColors.neonGreen,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),

                // JUDUL
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.softWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 24),

                // INPUT FIELD
                TextField(
                  controller: _controller,
                  keyboardType: widget.keyboardType,
                  style: const TextStyle(color: AppColors.softWhite),
                  cursorColor: AppColors.neonGreen,
                  decoration: InputDecoration(
                    labelText: widget.labelText,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: AppColors.softWhite.withOpacity(0.3),
                    ),
                    labelStyle: TextStyle(
                      color: AppColors.softWhite.withOpacity(0.7),
                    ),
                    filled: true,
                    fillColor: AppColors.midnight,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.glassBorder,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.neonGreen),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // TOMBOL AKSI
                Row(
                  children: [
                    // BATAL
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context), // Tutup Dialog
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.softWhite,
                          side: const BorderSide(color: AppColors.glassBorder),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          widget.cancelText,
                          style: TextStyle(
                            color: AppColors.softWhite.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // SIMPAN
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // 1. Kirim data
                          widget.onConfirm(_controller.text.trim());
                          // 2. 👇 TUTUP DIALOG OTOMATIS
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.deepBlueAccent,
                          foregroundColor: AppColors.softWhite,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          widget.confirmText,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
