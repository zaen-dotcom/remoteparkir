import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  // Default IP (IP Laptop Anda saat ini, sebagai cadangan)
  static String _serverIp = "192.168.1.10";
  static String _port = "5000";

  // Getter dinamis (akan berubah sesuai _serverIp)
  static String get baseUrl => "http://$_serverIp:$_port";

  // Endpoint list (ubah jadi getter juga agar mengikuti baseUrl terbaru)
  static String get vehicleHistory => "$baseUrl/api/vehicle";
  static String get openGate => "$baseUrl/api/open-gate";

  // --- LOGIKA PENYIMPANAN ---

  // 1. Panggil ini di main.dart agar IP tersimpan termuat
  static Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedIp = prefs.getString('custom_server_ip');
    if (savedIp != null && savedIp.isNotEmpty) {
      _serverIp = savedIp;
    }
  }

  // 2. Panggil ini saat user ganti IP lewat UI
  static Future<void> setIp(String newIp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('custom_server_ip', newIp);
    _serverIp = newIp;
  }

  // Getter untuk menampilkan IP saat ini di TextField dialog
  static String get currentIp => _serverIp;
}
