import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/app_router.dart';
import 'core/shell_page.dart';
import 'firebase_options.dart';
import 'models/diary_entry.dart';
import 'pages/awakening/awakening_page.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();
  Hive.registerAdapter(DiaryEntryAdapter());
  Hive.registerAdapter(DrawnCardRecordAdapter());
  Hive.registerAdapter(TodayReadingRecordAdapter());

  runApp(const FatumApp());
}

class _NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) => child;
}

class FatumApp extends StatelessWidget {
  const FatumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FATUM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      onGenerateRoute: onGenerateRoute,
      scrollBehavior: _NoScrollbarBehavior(),
      home: const _AuthGate(),
    );
  }
}

/// Routes to ShellPage if logged in, AwakeningPage if not.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.idTokenChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const ShellPage();
        }
        return const AwakeningPage();
      },
    );
  }
}
