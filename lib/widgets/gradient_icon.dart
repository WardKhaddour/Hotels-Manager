import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  const GradientIcon({Key? key, required this.child, required this.colors})
      : super(key: key);
  final Widget child;
  final List<Color> colors;
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (rect) => LinearGradient(
        //TODO aplly half icon
        stops: [0, 0.5, 0.5],
        colors: colors,
        tileMode: TileMode.repeated,
      ).createShader(rect),
      child: child,
    );
  }
}
