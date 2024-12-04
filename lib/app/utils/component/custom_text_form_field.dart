import 'package:flutter/material.dart';
import 'package:rabbitmq_client/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ValueChanged<String>? onChanged;
  final VoidCallback? search;
  final bool readOnly;
  final TextInputType? keyboard;
  final bool obscure;
  final FormFieldValidator<String>? validasi;
  final Icon? iconPrefix;
  final IconButton? iconsuffix;
  final TextEditingController? textEditingController;
  const CustomTextFormField({
    super.key,
    required this.obscure,
    this.onPressed,
    this.onChanged,
    this.readOnly = false,
    this.search,
    this.textEditingController,
    this.keyboard = TextInputType.text,
    this.validasi,
    this.iconPrefix,
    this.iconsuffix,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [whiteMainColor, greyOpacityColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextFormField(
        key: key,
        onChanged: onChanged,
        readOnly: readOnly,
        controller: textEditingController,
        onTap: search,
        obscureText: obscure,
        validator: validasi,
        cursorColor: greyColor,
        keyboardType: keyboard,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 15),
          suffixIcon: iconsuffix,
          hintText: text,
          hintStyle: ColorApp.hintTextStyle(context)
              .copyWith(fontSize: 16.0, fontWeight: reguler),
          prefixIcon: iconPrefix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: greyColor,
              width: 0.2,
            ),
          ),
          filled: true,
          fillColor: Colors
              .transparent, // Make the TextFormField transparent to show the gradient
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: greyColor,
              width: 0.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: greyColor,
              width: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}
