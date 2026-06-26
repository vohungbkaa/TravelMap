import 'package:flutter/material.dart';
import 'package:travel_map/routing/router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Travel Map',
      debugShowCheckedModeBanner: false,
      routerConfig: router(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF146C94)),
        useMaterial3: true,
      ),
    );
  }
}
