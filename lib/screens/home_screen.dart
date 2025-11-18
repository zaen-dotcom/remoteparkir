import 'package:flutter/material.dart';
import '../themes/color.dart';
import '../components/card.dart'; // Pastikan ini mengarah ke VehicleCard yang baru
import '../services/api_service.dart'; // File service API yang tadi dibuat
import '../models/vehicle_model.dart'; // File model yang tadi dibuat

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variabel untuk menampung Future data
  late Future<List<VehicleModel>> _vehicleFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Fungsi untuk memuat/refresh data
  void _loadData() {
    setState(() {
      _vehicleFuture = getVehicleHistory();
    });
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
          // Tombol Refresh Manual (Opsional)
          const SizedBox(width: 8),
        ],
      ),

      // RefreshIndicator: Tarik layar ke bawah untuk update data
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
          // Tunggu sebentar agar loading indicator terasa (UX)
          await Future.delayed(const Duration(seconds: 1));
        },
        color: AppColors.neonGreen,
        backgroundColor: AppColors.deepBlue,

        child: FutureBuilder<List<VehicleModel>>(
          future: _vehicleFuture,
          builder: (context, snapshot) {
            // 1. KONDISI LOADING
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.neonGreen),
              );
            }

            // 2. KONDISI ERROR
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.crimson,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Gagal memuat data",
                      style: TextStyle(
                        color: AppColors.softWhite.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      "${snapshot.error}", // Tampilkan pesan error teknis (opsional)
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _loadData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepBlue,
                      ),
                      child: const Text("Coba Lagi"),
                    ),
                  ],
                ),
              );
            }

            // 3. KONDISI DATA KOSONG
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.garage_outlined,
                      color: AppColors.softWhite.withOpacity(0.3),
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Belum ada kendaraan lewat",
                      style: TextStyle(
                        color: AppColors.softWhite.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              );
            }

            // 4. KONDISI SUKSES (ADA DATA)
            final vehicles = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.fromLTRB(20, 10, 20, bottomPadding),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final data = vehicles[index];

                // 🔥 MENGGUNAKAN CARD YANG BARU
                return VehicleCard(
                  plate: data.plate, // Dari API: plate_text
                  time: data.time, // Dari API: entry_time
                  status: data.status, // Dari API: status
                );
              },
            );
          },
        ),
      ),
    );
  }
}
