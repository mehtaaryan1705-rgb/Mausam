import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'data/repositories/weather_repository.dart';
import 'viewmodels/persona_viewmodel.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'ui/core/theme.dart';
import 'ui/features/language/language_screen.dart';
import 'ui/features/onboarding/onboarding_screen.dart';
import 'ui/features/home/home_screen.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final weatherRepository = WeatherRepository();
  final personaViewModel = PersonaViewModel(repository: weatherRepository);
  await personaViewModel.initialize();

  final weatherViewModel = WeatherViewModel(repository: weatherRepository);
  await weatherViewModel.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PersonaViewModel>.value(value: personaViewModel),
        ChangeNotifierProvider<WeatherViewModel>.value(value: weatherViewModel),
      ],
      child: const MausamApp(),
    ),
  );
}

class MausamApp extends StatelessWidget {
  const MausamApp({super.key});

  @override
  Widget build(BuildContext context) {
    final personaVm = context.watch<PersonaViewModel>();
    final activeLocale = personaVm.languageCode != null
        ? Locale(personaVm.languageCode!)
        : const Locale('en');

    return MaterialApp(
      title: 'Mausam - मौसम (Ministry of Earth Sciences)',
      debugShowCheckedModeBanner: false,
      theme: MausamTheme.lightTheme,
      darkTheme: MausamTheme.darkTheme,
      themeMode: ThemeMode.light,
      locale: activeLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('hi', ''),
      ],
      home: personaVm.languageCode == null
          ? const LanguageScreen()
          : (personaVm.hasCompletedOnboarding
              ? const HomeScreen()
              : const OnboardingScreen()),
    );
  }
}
