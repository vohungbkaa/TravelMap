import 'package:flutter/material.dart';

class TravelMapLoader extends StatelessWidget {
  const TravelMapLoader({super.key});

  @override
  Widget build(BuildContext context) {
    // Thay vì dùng showDialog() gây phức tạp lifecycle,
    // trong Declarative UI ta dùng Overlay bọc toàn màn hình
    return Positioned.fill(
      child: Container(
        color: Colors.black54, // Nền xám mờ
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
