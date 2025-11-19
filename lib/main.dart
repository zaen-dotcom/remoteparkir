import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'routes/main_route.dart';
// 👇 Pastikan import file session manager kamu benar (sesuaikan path folder)
import 'utils/session_manager.dart';

void main() async {
  // 1. Wajib ada karena kita akan akses SharedPreferences sebelum aplikasi jalan
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Cek apakah ini pertama kali buka?
  bool isFirstTime = await SessionManager.isFirstTime();

  // 3. Tentukan mau ke mana:
  // Jika isFirstTime == true  -> ke '/onboarding'
  // Jika isFirstTime == false -> langsung ke '/main'
  String routeAwal = isFirstTime ? '/onboarding' : '/main';

  runApp(MyApp(initialRoute: routeAwal));
}

class MyApp extends StatelessWidget {
  // 4. Buat variabel untuk menampung rute awal
  final String initialRoute;

  // 5. Wajib terima data initialRoute di constructor
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IoT Secure Monitor',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueAccent,
          secondary: Colors.greenAccent,
        ),
      ),
      // 6. Gunakan variabel tadi di sini, JANGAN hardcode string lagi
      initialRoute: initialRoute,
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/main': (context) => const MainRoute(),
      },
    );
  }
}
