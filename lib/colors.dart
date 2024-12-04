// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

const whitebackgroudColor = Color(0xFFF5F5F5); 
const whiteMainColor = Color(0xFFFFFFFF);
const blackMainColor = Colors.black;
const colorTransparan = Colors.transparent;
const coklatMain = Color(0xFFCC7700);
const coklaOpasiti = Color.fromARGB(255, 221, 155, 62);
const coklatBlackMain = Color(0xFF8C5100);
const redcolor = Colors.red; 
const greyColor = Colors.grey; 
const greenColor = Colors.green; 
            

TextStyle redTextStyle = const TextStyle(color: redcolor);
TextStyle coklatTextStyle = const TextStyle(color: coklatMain);
TextStyle blackTextStyle = const TextStyle(color: blackMainColor);
TextStyle whiteTextStyle = const TextStyle(color: whiteMainColor);
TextStyle greyTextStyle = const TextStyle(color: greyColor);
const greyOpacityColor = Color.fromARGB(255, 231, 231, 231);

FontWeight leastLight = FontWeight.w100;
FontWeight extraLight = FontWeight.w200;
FontWeight light = FontWeight.w300;
FontWeight reguler = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight blackBlod = FontWeight.w900;

class ColorApp {

  // static TextStyle orenTextStyle(BuildContext context) {
  //   return const TextStyle(
  //     color: orenOpacityColor,
  //   );
  // }

  // static TextStyle greenTextStyle(BuildContext context) {
  //   return const TextStyle(
  //     color: greenColor,
  //   );
  // }
   static TextStyle hintTextStyle(BuildContext context) {
    return const   TextStyle(fontStyle: FontStyle.italic, // Mengatur teks menjadi italic
            color: Colors.grey, );
  }


  static TextStyle blackTextStyle(BuildContext context) {
    return const TextStyle(
      color: blackMainColor,
    );
  }

  static TextStyle greyTextStyly(BuildContext context) {
    return const TextStyle(
      color: greyColor,
    );
  }

  static TextStyle whiteTextStyly(BuildContext context) {
    return const TextStyle(
      color: whiteMainColor,
    );
  }

  static TextStyle coklatTextStyly(BuildContext context) {
    return const TextStyle(
      color: coklatMain,
    );
  }

  static TextStyle redTextStyly(BuildContext context) {
    return const TextStyle(
      color: redcolor,
    );
  }
}
