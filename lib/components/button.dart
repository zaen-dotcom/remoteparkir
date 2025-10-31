import 'package:flutter/material.dart';
import '../themes/color.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;
  final Color? textColor;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppColors.neonGreen;
    final labelColor = textColor ?? AppColors.deepBlue;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          disabledBackgroundColor: buttonColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 3,
          shadowColor: AppColors.neonGreen.withOpacity(0.4),
          overlayColor: AppColors.neonGreen.withOpacity(0.2),
        ),
        onPressed: isLoading ? null : onPressed,
        child:
            isLoading
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.deepBlue,
                  ),
                )
                : Text(
                  text.toUpperCase(),
                  style: TextStyle(
                    color: labelColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
      ),
    );
  }
}
