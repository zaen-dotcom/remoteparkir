import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyIsFirstTime = 'is_first_time';

  /// Cek apakah ini pertama kali aplikasi dibuka
  /// Return: true jika pertama kali, false jika sudah pernah dibuka
  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    // Jika null (belum ada data), anggap true (pertama kali)
    return prefs.getBool(_keyIsFirstTime) ?? true;
  }

  /// Panggil fungsi ini setelah user menyelesaikan Onboarding
  static Future<void> setOnboardingFinished() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsFirstTime, false);
  }

  /// Opsional: Untuk logout atau reset data (testing)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
