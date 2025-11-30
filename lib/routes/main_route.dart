import 'dart:async'; // 1. Butuh ini untuk Timer
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/home_screen.dart';
import '../screens/controll_screen.dart';
// 👇 Import Config & Component Dialog
import '../services/config.dart';
import '../components/input_dialog.dart';
import '../themes/color.dart';
import '../components/custom_alert.dart';

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

  // 👇 VARIABLE LOGIKA TRIPLE TAP
  int _tapCount = 0;
  Timer? _tapTimer;

  @override
  void dispose() {
    _tapTimer?.cancel(); // Bersihkan timer saat widget hancur
    super.dispose();
  }

  // 👇 FUNGSI DETEKSI 3x TAP
  void _handleSecretTap() {
    _tapCount++;
    if (_tapCount == 1) {
      // Reset counter jika tidak ada tap lagi dalam 500ms
      _tapTimer = Timer(const Duration(milliseconds: 500), () {
        _tapCount = 0;
      });
    } else if (_tapCount == 3) {
      // JIKA SUDAH 3x TAP
      _tapCount = 0;
      _tapTimer?.cancel();
      HapticFeedback.mediumImpact(); // Getaran tanda berhasil
      _showIpDialog(); // Buka Dialog
    }
  }

  // 👇 FUNGSI BUKA DIALOG IP
  void _showIpDialog() {
    InputDialog.show(
      context,
      title: "Konfigurasi Server IoT",
      icon: Icons.router,
      initialValue: ApiConfig.currentIp,
      labelText: "IP Address Server",
      hintText: "Cth: 192.168.1.10",
      keyboardType: TextInputType.number,
      confirmText: "Simpan",

      onConfirm: (newIp) async {
        // Logika Validasi Sederhana
        if (newIp.isNotEmpty) {
          // 1. Simpan IP
          await ApiConfig.setIp(newIp);

          if (mounted) {
            // 2. Tampilkan Alert BERHASIL (Hijau)
            ElegantAlertDialog.show(
              context,
              title: "Konfigurasi Berhasil",
              content: "Target IP server telah diubah menjadi:\n$newIp",
              confirmText: "Oke",
              icon: Icons.check_circle_rounded,
              iconColor: AppColors.neonGreen, // Warna Hijau Sukses
              onConfirm: () => Navigator.pop(context), // Tutup Alert
            );
          }
        } else {
          // 3. Tampilkan Alert GAGAL (Merah) - Jika input kosong
          if (mounted) {
            ElegantAlertDialog.show(
              context,
              title: "Gagal Menyimpan",
              content: "IP Address tidak boleh kosong.",
              confirmText: "Coba Lagi",
              icon: Icons.error_outline_rounded,
              isDestructive: true, // Warna Merah Error
              onConfirm: () => Navigator.pop(context),
            );
          }
        }
      },
    );
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    HapticFeedback.lightImpact();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 👇 BUNGKUS SCAFFOLD DENGAN GESTURE DETECTOR
    return GestureDetector(
      onTap: _handleSecretTap, // Panggil logika tap disini
      // 'translucent' agar tap tembus ke area kosong, tapi tidak memblokir tombol lain
      behavior: HitTestBehavior.translucent,

      child: Scaffold(
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
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
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
