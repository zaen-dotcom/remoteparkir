import 'package:flutter/material.dart';
import '../themes/color.dart';
import '../components/custom_alert.dart';
import '../services/api_service.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  // ==========================================
  // 1. LOGIKA BUKA GATE
  // ==========================================
  void _showGateConfirmation(BuildContext context) {
    ElegantAlertDialog.show(
      context,
      title: "Konfirmasi Buka Gate",
      content:
          "Anda yakin akan membuka gate jalan? Pastikan area sekitar aman.",
      confirmText: "YA, BUKA GATE",
      onConfirm: () {
        Navigator.of(context).pop();
        _sendOpenCommand();
      },
      cancelText: "BATAL",
      onCancel: () => Navigator.of(context).pop(),
      icon: Icons.meeting_room_outlined,
      iconColor: AppColors.amber,
    );
  }

  Future<void> _sendOpenCommand() async {
    _showLoading(); // Tampilkan loading

    bool success = await openGateManual(); // Panggil API

    if (!mounted) return;
    Navigator.of(context).pop(); // Tutup loading

    if (success) {
      _showResultAlert(
        "Berhasil",
        "Gerbang sedang dibuka.",
        Icons.check_circle_outline,
        AppColors.neonGreen,
      );
    } else {
      _showResultAlert(
        "Gagal",
        "Tidak dapat terhubung ke server.",
        Icons.wifi_off_rounded,
        AppColors.crimson,
      );
    }
  }

  // ==========================================
  // 2. LOGIKA MATIKAN BUZZER (BARU)
  // ==========================================
  void _showBuzzerConfirmation(BuildContext context) {
    ElegantAlertDialog.show(
      context,
      title: "Matikan Alarm?",
      content: "Apakah Anda ingin mematikan suara buzzer/alarm secara paksa?",
      confirmText: "YA, MATIKAN",
      onConfirm: () {
        Navigator.of(context).pop();
        _sendStopBuzzerCommand();
      },
      cancelText: "BATAL",
      onCancel: () => Navigator.of(context).pop(),
      icon: Icons.notifications_off_outlined,
      iconColor: AppColors.crimson,
    );
  }

  Future<void> _sendStopBuzzerCommand() async {
    _showLoading();

    bool success = await stopBuzzerManual(); // Panggil API Stop Buzzer

    if (!mounted) return;
    Navigator.of(context).pop();

    if (success) {
      _showResultAlert(
        "Berhasil",
        "Perintah mematikan alarm dikirim.",
        Icons.volume_off,
        AppColors.neonGreen,
      );
    } else {
      _showResultAlert(
        "Gagal",
        "Gagal menghubungi server.",
        Icons.error_outline,
        AppColors.crimson,
      );
    }
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================
  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: const CircularProgressIndicator(color: AppColors.neonGreen),
          ),
        );
      },
    );
  }

  void _showResultAlert(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    ElegantAlertDialog.show(
      context,
      title: title,
      content: content,
      confirmText: "OK",
      onConfirm: () => Navigator.of(context).pop(),
      icon: icon,
      iconColor: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? AppColors.charcoal : AppColors.softWhite;
    final titleColor = isDarkMode ? AppColors.softWhite : AppColors.deepBlue;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Remote Control',
          style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        toolbarHeight: 70,
      ),

      // ... (kode appbar sama seperti sebelumnya)
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Tambahkan padding extra di bawah agar tidak mepet layar
        padding: const EdgeInsets.only(bottom: 50),
        child: Center(
          child: SingleChildScrollView(
            // Physics bouncing agar terasa lebih natural saat discroll
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // --- INDIKATOR STATUS ---
                Text(
                  "Sistem Kontrol",
                  style: TextStyle(
                    color: titleColor.withOpacity(0.7),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neonGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.link, color: AppColors.neonGreen, size: 16),
                      SizedBox(width: 6),
                      Text(
                        "Status: Terhubung",
                        style: TextStyle(
                          color: AppColors.neonGreen,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Jarak ke tombol pertama dikurangi sedikit (tadi 40)
                const SizedBox(height: 30),

                // --- TOMBOL-TOMBOL ---
                Column(
                  children: [
                    // 1. TOMBOL BUKA GATE (BIRU)
                    AnimatedBigButton(
                      label: "Buka Gate",
                      icon: Icons.lock_open_rounded,
                      gradient: AppColors.blueGradient,
                      shadowColor: AppColors.deepBlueAccent,
                      onTap: () => _showGateConfirmation(context),
                    ),

                    // Jarak antar tombol dikurangi sedikit (tadi 30)
                    const SizedBox(height: 20),

                    // 2. TOMBOL MATIKAN BUZZER (MERAH)
                    AnimatedBigButton(
                      label: "Stop Alarm",
                      icon: Icons.notifications_off_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shadowColor: Colors.redAccent,
                      onTap: () => _showBuzzerConfirmation(context),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Text(
                  "Ketuk tombol untuk eksekusi.",
                  style: TextStyle(
                    color: titleColor.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),

                // 🔥 INI KUNCINYA:
                // Tambahkan ruang kosong besar di bawah agar tombol merah
                // naik ke atas dan tidak tertutup Bottom Nav Bar
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// === WIDGET TOMBOL ANIMASI (MODIFIED) ===
// Sekarang menerima parameter warna, icon, dan gradient agar reusable
class AnimatedBigButton extends StatefulWidget {
  final VoidCallback onTap;
  final String label;
  final IconData icon;
  final Gradient gradient;
  final Color shadowColor;

  const AnimatedBigButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.icon,
    required this.gradient,
    required this.shadowColor,
  });

  @override
  State<AnimatedBigButton> createState() => _AnimatedBigButtonState();
}

class _AnimatedBigButtonState extends State<AnimatedBigButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _scaleAnimation = Tween(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) _controller.forward();
    });
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // Ukuran tombol dikecilkan sedikit (180) agar muat dua tombol vertikal
    // Jika ingin lebih besar, ubah width/height di sini
    const double size = 180;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: widget.gradient, // Menggunakan parameter gradient
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor.withOpacity(
                  0.5,
                ), // Menggunakan parameter shadow
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon, // Menggunakan parameter icon
                color: Colors.white,
                size: 60,
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
