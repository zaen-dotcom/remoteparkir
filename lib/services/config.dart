// lib/config/api_config.dart

class ApiConfig {
  // ⚠️ PENTING: Ganti IP ini dengan IP Laptop Anda
  // Cara cek IP di laptop: Buka CMD -> ketik ipconfig -> Cari IPv4 Address
  static const String baseUrl = "http://10.10.7.71:5000";

  // Endpoint list
  static const String vehicleHistory = "$baseUrl/api/vehicle";
  static const String openGate = "$baseUrl/api/open-gate";
}
