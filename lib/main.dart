import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'providers/mountain_provider.dart';
import 'providers/plan_provider.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase Backend Database
  await Supabase.initialize(
    url: 'https://vpkmycnfgpxqqfvalajv.supabase.co',
    anonKey: 'sb_publishable_kzKap6eBMh0bhutnrT9_vQ_nqoN1eRU',
  );

  runApp(const MountainExplorerApp());
}

class MountainExplorerApp extends StatelessWidget {
  const MountainExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MountainProvider()),
        ChangeNotifierProvider(create: (_) => PlanProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}