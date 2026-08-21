import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CmocLogo extends StatelessWidget {
  final double height;
  final bool showSubtitle;
  final Color? color;

  const CmocLogo({
    super.key,
    this.height = 36.0,
    this.showSubtitle = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/CMOC_bilingual_logo.svg',
      height: height,
      fit: BoxFit.contain,
      colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      placeholderBuilder: (context) => SizedBox(
        width: 100,
        height: 30,
        child: Center(
          child: Text(
            'CMOC',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color ?? const Color(0xFF0F4C81),
            ),
          ),
        ),
      ),
    );
  }
}
