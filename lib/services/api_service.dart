import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import '../models/vehicle_model.dart';

// === FUNGSI API VEHICLE HISTORY ===
Future<List<VehicleModel>> getVehicleHistory() async {
  try {
    print("📡 Connecting to: ${ApiConfig.vehicleHistory}");

    final response = await http
        .get(Uri.parse(ApiConfig.vehicleHistory))
        .timeout(const Duration(seconds: 5));

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
    final String url = ApiConfig.openGate; // Mengarah ke /api/open-gate

    print("📡 Sending OPEN Command to: $url");

    final response = await http
        .post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          // Body ini hanya pelengkap log, backend trigger via URL
          body: jsonEncode({"action": "OPEN", "request_from": "mobile_app"}),
        )
        .timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      print("✅ Gate Open Triggered: ${response.body}");
      return true;
    } else {
      print("⚠️ Server Refused: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("❌ Error Connection: $e");
    return false;
  }
}

// === FUNGSI MATIKAN BUZZER MANUAL (BARU) ===
Future<bool> stopBuzzerManual() async {
  try {
    final String url = ApiConfig.stopBuzzer; // Mengarah ke /api/stop-buzzer

    print("📡 Sending MUTE Command to: $url");

    final response = await http
        .post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"action": "MUTE", "request_from": "mobile_app"}),
        )
        .timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      print("✅ Stop Buzzer Triggered: ${response.body}");
      return true;
    } else {
      print("⚠️ Server Refused: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("❌ Error Connection: $e");
    return false;
  }
}
