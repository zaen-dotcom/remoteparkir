import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart'; // Import file config di folder yang sama
import '../models/vehicle_model.dart';

// === FUNGSI API VEHICLE HISTORY ===
Future<List<VehicleModel>> getVehicleHistory() async {
  try {
    print("📡 Connecting to: ${ApiConfig.vehicleHistory}");

    final response = await http
        .get(Uri.parse(ApiConfig.vehicleHistory))
        .timeout(
          const Duration(seconds: 5),
        ); // 👈 TAMBAHAN: Batas waktu 5 detik

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> dataList = jsonResponse['data'];
      return dataList.map((json) => VehicleModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data. Kode: ${response.statusCode}');
    }
  } catch (e) {
    print("❌ Error Fetching Data: $e");
    rethrow;
  }
}

// === FUNGSI BUKA GATE MANUAL ===
Future<bool> openGateManual() async {
  try {
    const String url = ApiConfig.openGate;

    print("📡 Sending Command to: $url");

    final response = await http
        .post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"action": "OPEN", "request_from": "mobile_app"}),
        )
        .timeout(
          const Duration(seconds: 5),
        ); // 👈 TAMBAHAN: Batas waktu 5 detik

    if (response.statusCode == 200) {
      print("✅ Command Sent Successfully: ${response.body}");
      return true;
    } else {
      print("⚠️ Server Refused: ${response.statusCode} - ${response.body}");
      return false;
    }
  } catch (e) {
    print("❌ Error Connection: $e");
    return false;
  }
}
