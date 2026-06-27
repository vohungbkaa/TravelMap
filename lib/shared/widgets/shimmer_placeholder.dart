import 'package:flutter/material.dart';

/// Component chung hiển thị khối placeholder với hiệu ứng góc bo mềm mại kiểu Facebook
class ShimmerPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final Color? color;
  final ShapeBorder? shapeBorder;

  const ShimmerPlaceholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 6.0,
    this.color,
    this.shapeBorder,
  });

  const ShimmerPlaceholder.circular({
    super.key,
    required double radius,
    this.color,
  })  : width = radius * 2,
        height = radius * 2,
        borderRadius = radius,
        shapeBorder = const CircleBorder();

  @override
  Widget build(BuildContext context) {
    // Màu xám nhẹ nhạt kiểu Facebook/Social Apps (Colors.grey.shade200 / 0xFFE4E6EB)
    final defaultColor = color ?? Colors.grey.shade200;

    if (shapeBorder != null) {
      return Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: defaultColor,
          shape: shapeBorder!,
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: defaultColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
