import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_provider.dart';
import '../features/onboarding/onboarding_page.dart';
import 'app_shell.dart';
import 'theme/app_theme.dart';

class DexTrackApp extends ConsumerStatefulWidget {
  const DexTrackApp({super.key});

  @override
  ConsumerState<DexTrackApp> createState() => _DexTrackAppState();
}

class _DexTrackAppState extends ConsumerState<DexTrackApp> {
  bool? _setupComplete;

  @override
  void initState() {
    super.initState();
    _loadSetupState();
  }

  Future<void> _loadSetupState() async {
    // Beim Testen in Chrome überspringen wir vorerst den Drift-Zugriff.
    // Auf Android und iOS wird der Status dauerhaft gespeichert.
    if (kIsWeb) {
      setState(() {
        _setupComplete = false;
      });
      return;
    }

    try {
      final database = ref.read(databaseProvider);
      final isComplete = await database.isOnboardingComplete();

      if (!mounted) {
        return;
      }

      setState(() {
        _setupComplete = isComplete;
      });
    } catch (error, stackTrace) {
      debugPrint('Fehler beim Laden des Onboarding-Status: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) {
        return;
      }

      setState(() {
        _setupComplete = false;
      });
    }
  }

  Future<void> _completeSetup() async {
    if (!kIsWeb) {
      try {
        final database = ref.read(databaseProvider);
        await database.setOnboardingComplete();
      } catch (error, stackTrace) {
        debugPrint('Fehler beim Speichern des Onboarding-Status: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _setupComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DexTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: switch (_setupComplete) {
        null => const _StartupPage(),
        true => const AppShell(),
        false => OnboardingPage(
            onStart: _completeSetup,
          ),
      },
    );
  }
}

class _StartupPage extends StatelessWidget {
  const _StartupPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}