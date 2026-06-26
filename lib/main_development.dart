import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:travel_map/app.dart';
import 'package:travel_map/config/dependencies.dart';

void main() {
  Logger.root.level = Level.ALL;

  runApp(
    MultiProvider(
      providers: providersDevelopment,
      child: const MainApp(),
    ),
  );
}
