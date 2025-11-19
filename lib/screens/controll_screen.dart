import 'package:flutter/material.dart';
import '../themes/color.dart';
import '../components/custom_alert.dart';
import '../services/api_service.dart';

// ----------------------------------------------------------------

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  // 1. Alert Konfirmasi Awal
  void _showConfirmationAlert(BuildContext context) {
    ElegantAlertDialog.show(
      context,
      title: "Konfirmasi Buka Gate",
      content:
          "Anda yakin akan membuka gate jalan? Pastikan area sekitar aman.",
      confirmText: "YA, BUKA GATE",
      onConfirm: () {
        Navigator.of(context).pop(); // Tutup alert konfirmasi
        _sendOpenCommand(); // Jalankan perintah ke server
      },
      cancelText: "BATAL",
      onCancel: () {
        Navigator.of(context).pop();
      },
      icon: Icons.meeting_room_outlined,
      iconColor: AppColors.amber,
    );
  }

  // 2. Fungsi Kirim Perintah (Dengan Loading Dialog)
  Future<void> _sendOpenCommand() async {
    // A. TAMPILKAN LOADING DIALOG (Bukan SnackBar)
    // Loading ini akan terus muncul sampai kita tutup secara manual (pop)
    showDialog(
      context: context,
      barrierDismissible: false, // User tidak bisa tutup sembarangan
      builder: (context) {
        return Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: CircularProgressIndicator(color: AppColors.neonGreen),
          ),
        );
      },
    );

    // B. Panggil API (Proses menunggu terjadi di sini)
    bool success = await openGateManual();

    // C. Cek mounted sebelum lanjut (Safety Check)
    if (!mounted) return;

    // D. TUTUP LOADING DIALOG
    Navigator.of(context).pop();

    // E. Tampilkan Alert Hasil
    if (success) {
      // === KONDISI SUKSES ===
      ElegantAlertDialog.show(
        context,
        title: "Berhasil",
        content: "Perintah diterima! Gerbang sedang dibuka.",
        confirmText: "KONFIRMASI",
        onConfirm: () {
          Navigator.of(context).pop();
        },
        icon: Icons.check_circle_outline,
        iconColor: AppColors.neonGreen,
      );
    } else {
      // === KONDISI GAGAL ===
      ElegantAlertDialog.show(
        context,
        title: "Gagal Terkirim",
        content: "Tidak dapat terhubung ke server.\nError: Connection Timeout",
        confirmText: "MENGERTI",
        onConfirm: () {
          Navigator.of(context).pop();
        },
        icon: Icons.wifi_off_rounded,
        iconColor: AppColors.crimson,
      );
    }
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
          'Remote Gate Control',
          style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        toolbarHeight: 70,
      ),
      body: Center(
        child: Transform.translate(
          offset: const Offset(0.0, -70),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Indikator Status
              Text(
                "Gerbang Utama Kompleks A",
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.link,
                      color: AppColors.neonGreen,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
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
              const SizedBox(height: 50),

              // Tombol Besar
              AnimatedBigButton(
                onTap: () => _showConfirmationAlert(context),
                label: "Buka Gate Jalan",
              ),

              const SizedBox(height: 100),

              // Instruksi
              Text(
                "Ketuk untuk mengontrol gerbang.",
                style: TextStyle(
                  color: titleColor.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === WIDGET TOMBOL ANIMASI (TETAP SAMA) ===
class AnimatedBigButton extends StatefulWidget {
  final VoidCallback onTap;
  final String label;

  const AnimatedBigButton({
    super.key,
    required this.onTap,
    required this.label,
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
      _controller.forward();
    });
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.blueGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.deepBlueAccent.withOpacity(0.5),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_open_rounded,
                color: AppColors.softWhite,
                size: 80,
              ),
              const SizedBox(height: 10),
              Text(
                widget.label,
                style: const TextStyle(
                  color: AppColors.softWhite,
                  fontSize: 20,
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
