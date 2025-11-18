// lib/models/vehicle_model.dart

class VehicleModel {
  final String plate;
  final String time;
  final String status;

  VehicleModel({required this.plate, required this.time, required this.status});

  // Factory untuk mengubah JSON (Map) menjadi Object Dart
  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      // Sesuaikan string di dalam ['...'] dengan key JSON dari Python
      plate: json['plate_text'] ?? 'Unknown',
      time: json['entry_time'] ?? '-',
      status: json['status'] ?? 'active',
    );
  }
}
