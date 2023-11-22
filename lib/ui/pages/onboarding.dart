import 'package:airplane_mode_checker/airplane_mode_checker.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:ucc_quiz_portal/core/utils/extensions.dart';
import 'package:ucc_quiz_portal/generated/assets.dart';
import 'package:ucc_quiz_portal/ui/pages/webview.dart';
import 'package:ucc_quiz_portal/ui/widgets/button.dart';
import 'package:ucc_quiz_portal/ui/widgets/page_indicator.dart';

/// user onboarding page
///
/// This page walks the user through the onboarding process
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController(), _connectionChecker = Connectivity();
  var _currentPage = 0;

  String get _buttonLabel {
    switch (_currentPage) {
      case 0:
        return 'I have turned on airplane mode';
      case 1:
        return 'I have turned on WiFi';
      case 2:
        return 'Proceed to the portal';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(systemOverlayStyle: SystemUiOverlayStyle.dark),
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: EdgeInsets.only(bottom: context.padding.bottom + 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: PageView(
                  physics: kReleaseMode
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  controller: _pageController,
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  children: [
                    _buildPage(
                        image: Assets.animFlightMode,
                        title: 'Turn on airplane mode',
                        description:
                            'To use this platform for your quizzes and exams, you need to turn on airplane mode.'),
                    _buildPage(
                        image: Assets.animWifi,
                        title: 'Turn on WiFi',
                        description:
                            'Turn on your WiFi and connect to the network.'),
                    _buildPage(
                        image: Assets.animAllSet,
                        title: 'You\'re all set!',
                        description:
                            'You can now use this platform for your quizzes and exams.'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              PageIndicator(count: 3, currentIndex: _currentPage),
              const SizedBox(height: 32),
              AppButton(
                label: _buttonLabel,
                onPressed: () async {
                  switch (_currentPage) {
                    case 0:
                      var status =
                          await AirplaneModeChecker.checkAirplaneMode();
                      if (status == AirplaneModeStatus.off) {
                        context.showSnackBar(
                            'Airplane mode is off. Please turn it on to proceed.',
                            isError: true);
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                      break;
                    case 1:
                      // turn on wifi
                      var status = await _connectionChecker.checkConnectivity();
                      if (status == ConnectivityResult.none ||
                          status != ConnectivityResult.wifi) {
                        context.showSnackBar('Please turn on WiFi to proceed.',
                            isError: true);
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }

                      break;
                    default:
                      context.navigator.pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                      break;
                  }
                },
              ),
            ],
          ),
        ),
      );

  Widget _buildPage(
          {required String image,
          required String title,
          required String description}) =>
      Padding(
        padding: EdgeInsets.only(top: context.padding.top + 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(image, repeat: false),
            const SizedBox(height: 32),
            Text(
              title,
              style: context.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(description,
                  style: context.textTheme.bodyLarge,
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      );
}
