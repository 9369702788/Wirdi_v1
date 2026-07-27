import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'shared/widgets/root_shell.dart';

void main() {
  runApp(const WirdiApp());
}

class WirdiApp extends StatelessWidget {
  const WirdiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'وردي | Wirdi',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      locale: const Locale('ar'),

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],

      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },

      home: const AppStartup(),
    );
  }
}

class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  bool _splashDone = false;
  bool _onboardingDone = false;

  @override
  Widget build(BuildContext context) {
    if (!_splashDone) {
      return SplashScreen(
        onFinished: () {
          setState(() {
            _splashDone = true;
          });
        },
      );
    }

    if (!_onboardingDone) {
      return OnboardingScreen(
        onFinished: () {
          setState(() {
            _onboardingDone = true;
          });
        },
      );
    }

    return const RootShell();
  }
}
