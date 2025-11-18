import 'package:flutter/material.dart';
import '../themes/color.dart';

class VehicleCard extends StatelessWidget {
  final String plate;
  final String time;
  final String status;

  const VehicleCard({
    super.key,
    required this.plate,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan warna berdasarkan status
    final bool isActive = status.toLowerCase() == 'active';
    final Color statusColor =
        isActive ? AppColors.neonGreen : AppColors.crimson;
    final String statusLabel = isActive ? "PARKING (ACTIVE)" : "SUDAH KELUAR";
    final IconData statusIcon =
        isActive ? Icons.local_parking_rounded : Icons.outbound_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepBlue.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: statusColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(-4, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // 1. BACKGROUND GRADIENT
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.deepBlueAccent.withOpacity(0.9),
                      AppColors.deepBlue,
                    ],
                  ),
                ),
              ),
            ),

            // 2. WATERMARK ICON
            Positioned(
              right: -20,
              bottom: -30,
              child: Transform.rotate(
                angle: -0.2,
                child: Icon(
                  Icons.two_wheeler_rounded,
                  size: 150,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),

            // 3. BORDER GLASS EFFECT
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
            ),

            // 4. ISI KONTEN UTAMA
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- BARIS 1: WAKTU MASUK (DIPINDAH KE KANAN) ---
                  Row(
                    // 👇 INI PERUBAHANNYA: Dorong konten ke kanan (End)
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: AppColors.softWhite.withOpacity(0.7),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Masuk: $time",
                        style: TextStyle(
                          color: AppColors.softWhite.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // --- BARIS 2: PLAT NOMOR (BESAR) ---
                  Text(
                    plate,
                    style: const TextStyle(
                      color: AppColors.softWhite,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- BARIS 3: STATUS BADGE ---
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: statusColor.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 16, color: statusColor),
                        const SizedBox(width: 8),
                        Text(
                          statusLabel,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
