import 'package:flutter/material.dart';
import '../themes/color.dart';
import '../components/custom_alert.dart';
import '../components/card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, dynamic>> _alertLogs = const [
    {
      "time": "Baru Saja",
      "plate": "B 1234 XYZ",
      "status": "Ditolak",
      "reason": "Wajah Tidak Cocok",
      "location": "Gate Utama",
      "isUrgent": true,
    },
    {
      "time": "10:42 WIB",
      "plate": "DK 5678 AB",
      "status": "Ditolak",
      "reason": "Plat Tidak Terdaftar",
      "location": "Gate Utama",
      "isUrgent": true,
    },
    {
      "time": "09:15 WIB",
      "plate": "L 9988 OP",
      "status": "Ditolak",
      "reason": "Wajah Tidak Terdeteksi",
      "location": "Gate Samping",
      "isUrgent": false,
    },
    {
      "time": "Kemarin, 18:00",
      "plate": "B 4455 JK",
      "status": "Ditolak",
      "reason": "Wajah Tidak Cocok",
      "location": "Gate Utama",
      "isUrgent": false,
    },
  ];

  void _showQuickActionAlert(BuildContext context, String plate) {
    ElegantAlertDialog.show(
      context,
      title: "Buka Gate Manual?",
      content: "Anda akan membuka gate untuk kendaraan $plate secara manual.",
      confirmText: "YA, BUKA",
      onConfirm: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Gate dibuka manual untuk $plate",
              style: const TextStyle(color: AppColors.softWhite),
            ),
            backgroundColor: AppColors.neonGreen,
          ),
        );
      },
      cancelText: "ABAIKAN",
      onCancel: () {
        Navigator.of(context).pop();
      },
      icon: Icons.warning_amber_rounded,
      iconColor: AppColors.crimson,
      isDestructive: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = 120.0;

    return Scaffold(
      backgroundColor: AppColors.charcoal,
      appBar: AppBar(
        title: const Text(
          'Monitor Akses',
          style: TextStyle(
            color: AppColors.softWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColors.charcoal,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.softWhite,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(20, 10, 20, bottomPadding),
        itemCount: _alertLogs.length,
        itemBuilder: (context, index) {
          final log = _alertLogs[index];

          // 🔥 PANGGIL KOMPONEN ALERT CARD DI SINI
          return AlertCard(
            plate: log['plate'],
            time: log['time'],
            location: log['location'],
            reason: log['reason'],
            isUrgent: log['isUrgent'],
            // Hanya kirim fungsi jika Urgent
            onOpenGate:
                log['isUrgent']
                    ? () => _showQuickActionAlert(context, log['plate'])
                    : null,
          );
        },
      ),
    );
  }
}
