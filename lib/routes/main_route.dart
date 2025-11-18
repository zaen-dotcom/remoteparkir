import 'dart:ui';
import 'package:flutter/material.dart';
import '../themes/color.dart';
import '../screens/home_screen.dart';
import '../screens/controll_screen.dart';

class MainRoute extends StatefulWidget {
  const MainRoute({super.key});

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;

  final List<Widget> _pages = const [HomePage(), ControlPage()];

  final List<_NavItemData> _navItems = const [
    _NavItemData(
      label: 'Beranda',
      icon: Icons.grid_view_rounded,
      activeIcon: Icons.grid_view_rounded,
    ),
    _NavItemData(
      label: 'Kontrol',
      icon: Icons.settings_remote,
      activeIcon: Icons.settings_remote,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuart,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.charcoal,
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
          height: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              // 1. Glow Halus (Tetap dipertahankan)
              BoxShadow(
                color: AppColors.neonGreen.withOpacity(0.15),
                blurRadius: 12,
                spreadRadius: -4,
                offset: const Offset(0, -2),
              ),
              // 2. Shadow Hitam Bawah
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: -2,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  // 🔥 PERBAIKAN DISINI:
                  // Ubah opacity jadi 0.96 (Hampir solid).
                  // Ini akan menutup warna biru dari tombol di belakangnya,
                  // tapi tetap terlihat modern.
                  color: AppColors.charcoal.withOpacity(0.96),

                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    color: AppColors.neonGreen.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    _navItems.length,
                    (i) => _buildNavItem(i),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final bool isActive = index == _selectedIndex;
    final _NavItemData item = _navItems[index];

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutQuart,
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: isActive ? 24 : 12,
        ),
        decoration: BoxDecoration(
          // Tombol Aktif juga diberi Glow lembut
          color:
              isActive
                  ? AppColors.neonGreen.withOpacity(0.15) // Hijau Pudar
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          // Border tipis pada tombol aktif
          border:
              isActive
                  ? Border.all(
                    color: AppColors.neonGreen.withOpacity(0.3),
                    width: 1,
                  )
                  : null,
          boxShadow:
              isActive
                  ? [
                    BoxShadow(
                      color: AppColors.neonGreen.withOpacity(0.2),
                      blurRadius: 15,
                    ),
                  ]
                  : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? item.activeIcon : item.icon,
              color:
                  isActive
                      ? AppColors
                          .neonGreen // Ikon Menyala Hijau
                      : AppColors.softWhite.withOpacity(0.5),
              size: 26,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                width: isActive ? null : 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      color: AppColors.neonGreen, // Teks Menyala Hijau
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: 0.5,
                      shadows: [
                        // Text Shadow (Glow pada huruf)
                        Shadow(color: AppColors.neonGreen, blurRadius: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemData {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  const _NavItemData({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
