import 'package:flutter/material.dart';
import 'package:travel_map/routing/router.dart';
import 'package:travel_map/shared/theme/app_theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tiến Thắng Travel',
      debugShowCheckedModeBanner: false,
      routerConfig: router(),
      theme: AppTheme.lightTheme,
    );
  }
}
