import 'package:flutter/material.dart';
import 'package:chatapp/utils/app_colors.dart';
//import 'package:placement_edge/utils/app_colors.dart';
//import 'package:placement_edge/utils/font_styles.dart';

class AppButton {
  static Widget button(
      {double? height,
      double? width,
      Color? color,
      String? text,
      Function()? onTap}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: color),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          text ?? 'Default Text',
          style: TextStyle(
            color: AppColors.white, // Use your custom color here
          ),
          // style: FontStyles.montserratBold17().copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
