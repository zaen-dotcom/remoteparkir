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
              // Shadow lembut agar tidak terlihat kaku
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  // 🔥 WARNA BARU: Cool Silver / White-Grey 🔥
                  // Bukan putih murni (0xFFFFFF), tapi agak abu-biru (0xFFDEE4EA)
                  // Ini mengurangi silau tapi tetap terlihat cerah/clean.
                  color: const Color(0xFFDEE4EA).withOpacity(0.70),

                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4), // Highlight pinggir
                    width: 1,
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
          // Background Tombol Aktif: Putih Murni (Agar kontras dengan bar Silver)
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow:
              isActive
                  ? [
                    BoxShadow(
                      color: AppColors.deepBlue.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? item.activeIcon : item.icon,
              // Warna Ikon:
              // Aktif: DeepBlue (Biru Gelap) -> Sangat tajam di atas putih
              // Mati: Abu-abu medium (Bukan hitam pekat, biar soft)
              color: isActive ? AppColors.deepBlue : const Color(0xFF475569),
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
                      color: AppColors.deepBlue, // Teks Deep Blue
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 0.5,
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
