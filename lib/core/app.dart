import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ucc_quiz_portal/services/active.dart';
import 'package:ucc_quiz_portal/ui/pages/onboarding.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class UccQuizPortal extends StatefulWidget {
  const UccQuizPortal({super.key});

  @override
  State<UccQuizPortal> createState() => _UccQuizPortalState();
}

class _UccQuizPortalState extends State<UccQuizPortal> {
  final _activeState = ActiveState();

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'UCC Quiz Portal',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: GoogleFonts.dmSansTextTheme(),
        ),
        navigatorKey: navigatorKey,
        home: ChangeNotifierProvider(
          create: (context) => _activeState,
          builder: (context, child) => const OnboardingPage(),
        ),
      );
}
