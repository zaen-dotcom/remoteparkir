import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/home_screen.dart';
import '../screens/controll_screen.dart';

class MainRoute extends StatefulWidget {
  const MainRoute({super.key});

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    HapticFeedback.lightImpact();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F131F),
      extendBody: true,

      // Tetap gunakan AnimatedSwitcher agar tidak macet/freeze
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeOutExpo,
        switchOutCurve: Curves.easeInExpo,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_selectedIndex),
          child: _pages[_selectedIndex],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              // 🔥 PERBAIKAN SHADOW DISINI 🔥
              BoxShadow(
                color: Colors.black.withOpacity(
                  0.3,
                ), // Opacity dikurangi biar soft
                blurRadius: 10, // Dikecilkan drastis (dari 30 jadi 10)
                offset: const Offset(0, 4), // Didekatkan (dari 10 jadi 4)
                spreadRadius: 0, // Agar tidak melebar kemana-mana
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1A1F35).withOpacity(0.85),
                      const Color(0xFF121520).withOpacity(0.95),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
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
          horizontal: isActive ? 20 : 12,
        ),
        decoration: BoxDecoration(
          gradient:
              isActive
                  ? const LinearGradient(
                    colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color: isActive ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          // Shadow tombol biru kecil (sudah pas sebelumnya)
          boxShadow:
              isActive
                  ? [
                    BoxShadow(
                      color: const Color(0xFF00C6FF).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? item.activeIcon : item.icon,
              color: isActive ? Colors.white : const Color(0xFF8F9BB3),
              size: 24,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                width: isActive ? null : 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ClipRect(
                    child: Text(
                      item.label,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
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
