import 'dart:ui';
import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/dot_indicator.dart';
import '../themes/color.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "image": "assets/secure.png",
      "title": "Selamat Datang di TeamPoco",
      "description":
          "Aplikasi ini dirancang untuk memantau dan mengontrol sistem IoT parkir Anda secara real-time, memastikan keamanan setiap kendaraan yang keluar dan masuk.",
    },
    {
      "image": "assets/security1.png",
      "title": "Kendalikan Sistem dengan Mudah",
      "description":
          "Pantau status gerbang, kontrol perangkat, dan dapatkan notifikasi keamanan langsung dari ponsel Anda — semua dalam satu aplikasi pintar dan aman.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage("assets/security1.png"), context);
    });

    _pageController.addListener(() {
      if (_pageController.hasClients && mounted) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlue,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Image.asset(
                            data["image"]!,
                            height: MediaQuery.of(context).size.height * 0.4,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          data["title"]!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.softWhite,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          data["description"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.softWhite.withOpacity(0.7),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
            DotIndicator(
              currentIndex: _currentPage,
              dotCount: _onboardingData.length,
            ),

            const SizedBox(height: 20),
            AnimatedSlide(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              offset: _currentPage == 1 ? Offset.zero : const Offset(0, 1.5),
              child: AnimatedOpacity(
                opacity: _currentPage == 1 ? 1 : 0,
                duration: const Duration(milliseconds: 400),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: CustomButton(
                    text: "MULAI SEKARANG",
                    onPressed: _nextPage,
                    color: AppColors.neonGreen,
                    textColor: AppColors.deepBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
