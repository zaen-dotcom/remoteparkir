import 'package:flutter/material.dart';
import '../themes/color.dart';
import '../components/card.dart';
import '../services/api_service.dart';
import '../models/vehicle_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  late Future<List<VehicleModel>> _vehicleFuture;

  @override
  void initState() {
    super.initState();
    _vehicleFuture = getVehicleHistory();
  }

  @override
  bool get wantKeepAlive => true;

  void _loadData() {
    setState(() {
      _vehicleFuture = getVehicleHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
        actions: [const SizedBox(width: 8)],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
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
                      "${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _loadData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepBlue,
                      ),
                      child: const Text(
                        "Coba Lagi",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // Spacer bawah agar posisi agak naik
                    const SizedBox(height: 100),
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
                    const SizedBox(height: 20),
                    // Tombol refresh manual
                    ElevatedButton(
                      onPressed: _loadData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepBlue,
                      ),
                      child: const Text(
                        "Refresh",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // 🔥 UPDATE DISINI: Menambahkan Spacer Bawah
                    // Ini akan mendorong konten ikon & teks ke atas
                    const SizedBox(height: 150),
                  ],
                ),
              );
            }

            // 4. KONDISI SUKSES (ADA DATA)
            final vehicles = snapshot.data!;

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(20, 10, 20, bottomPadding),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final data = vehicles[index];
                return VehicleCard(
                  plate: data.plate,
                  time: data.time,
                  status: data.status,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
