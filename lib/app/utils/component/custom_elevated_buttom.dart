import 'package:flutter/material.dart';

import '../colors.dart';



// Icon = jika menggunakan Icon pada child
// text = text pada child buttom
// onPressed = fungsi pada onPressed buttom
// shadow = bayangan pada belangkang buttom
// fontSize = ukuran huruf jika menggunkan text
// borderRadius = ukuran border Radius
// colorBackgroud = warna belakang pada buttom
// colorBorder = warna border pada border
// colorText = warna huruf buttom
// fontWeight = tebal text nya

// ignore: must_be_immutable
class CustomElevatedButtom extends StatelessWidget {
  Icon? icon;
  FontWeight? fontWeight;
  String? text;
  final VoidCallback onPressed;
  bool? shadow;
  Color? colorText;
  double? fontSize;
  final double borderRadius;
  final Color colorBackgroud;
  final Color colorBorder;
  CustomElevatedButtom({
    required this.onPressed,
    required this.colorBackgroud,
    this.icon,
    this.fontWeight,
    this.colorText,
    this.text,
    this.shadow,
    required this.borderRadius,
    this.fontSize,
    required this.colorBorder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [whiteMainColor, colorBackgroud],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadow == true
            ? [
                const BoxShadow(
                  color: greyOpacityColor,
                  offset: Offset(6, 6),
                  blurRadius: 9.0,
                ),
              ]
            : [],
        border: Border.all(
          color: colorBorder,
          width: 0.2,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: icon ??
            Text(
              "$text",
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: colorText,
              ),
            ),
      ),
    );
  }
}
