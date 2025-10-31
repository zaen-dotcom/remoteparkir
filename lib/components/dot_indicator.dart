import 'package:flutter/material.dart';
import '../themes/color.dart';

class DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int dotCount;

  const DotIndicator({Key? key, required this.currentIndex, this.dotCount = 2})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(dotCount, (index) {
        final bool isActive = currentIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 10 : 6,
          height: 6,
          decoration: BoxDecoration(
            color:
                isActive
                    ? AppColors.neonGreen
                    : AppColors.neonGreen.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
