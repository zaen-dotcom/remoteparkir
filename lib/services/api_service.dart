import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import '../models/vehicle_model.dart';

// === FUNGSI API VEHICLE HISTORY ===
Future<List<VehicleModel>> getVehicleHistory() async {
  try {
    print("📡 Connecting to: ${ApiConfig.vehicleHistory}");
    
    final response = await http.get(Uri.parse(ApiConfig.vehicleHistory));

    if (response.statusCode == 200) {
      // 1. Decode JSON response
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      
      // 2. Ambil List dari key "data"
      final List<dynamic> dataList = jsonResponse['data'];
      
      // 3. Convert ke List<VehicleModel>
      return dataList.map((json) => VehicleModel.fromJson(json)).toList();
      
    } else {
      throw Exception('Gagal memuat data. Kode: ${response.statusCode}');
    }
  } catch (e) {
    print("❌ Error Fetching Data: $e");
    rethrow; 
  }
}

// === Nanti bisa tambah fungsi lain di bawah sini ===
// Future<void> openGate() async { ... }
// Future<void> getParkingStatus() async { ... }