import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyThemes{
  static const lightBlue = Color(0xFFB5D4D2);
  static const darkBlue = Color(0xFF2B7595);
  static const brown = Color(0xFF975338);
  static const lightOrange = Color(0xFFF8C387);
  static const black = Color(0xFF000000);
  static const white = Color(0xFFffffff);
  static const lighterRed = Color(0xFFbf3122);
  static const darkerRed = Color(0xFF8d211e);
  //static const  = Color(0xFF);
  final Color googleColor = const Color(0xffDF4A32);



  static final lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    indicatorColor: darkBlue,
    primaryColor: darkBlue,

    appBarTheme: AppBarTheme(
      backgroundColor: darkBlue,
      elevation: 5.0,
      centerTitle: true,
      scrolledUnderElevation: 1.0,
      titleTextStyle: GoogleFonts.ptSans(textStyle: const TextStyle(overflow: TextOverflow.ellipsis,fontSize: 18, fontWeight: FontWeight.w700))),

    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateColor.resolveWith((states) => darkBlue),
    ),

    chipTheme: ChipThemeData(
        backgroundColor: darkBlue,
        deleteIconColor: white,
        elevation: 2.0,
        labelStyle: GoogleFonts.ptSans(textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,color: white))
    ),

    dialogTheme: DialogTheme(
      elevation: 2.0,
      titleTextStyle: GoogleFonts.ptSans(textStyle: const TextStyle(color: darkBlue, fontWeight: FontWeight.w600, fontSize: 16)),
    ),

    inputDecorationTheme: InputDecorationTheme(
        hintStyle: GoogleFonts.ptSans(),
        labelStyle: GoogleFonts.ptSans(color: darkBlue),
        errorStyle: GoogleFonts.ptSans(),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: darkBlue),),
        errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: darkerRed),),
        iconColor: darkBlue,
        prefixStyle: const TextStyle(fontSize: 15)
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: darkBlue,
      indicatorColor: darkBlue,
      elevation: 1.0,
      labelTextStyle: MaterialStateProperty.all(
          GoogleFonts.ptSans(textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,color: white))
      ),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    ),

    tabBarTheme: const TabBarTheme(
      unselectedLabelColor: Colors.black
    ),
  );

  static final darkTheme = ThemeData.dark().copyWith(
    primaryColorDark: Colors.black26,
    primaryColorLight: Colors.grey.shade900,

    appBarTheme: AppBarTheme(
        elevation: 5.0,
        centerTitle: true,
        scrolledUnderElevation: 1.0,
        titleTextStyle: GoogleFonts.ptSans(textStyle: const TextStyle(overflow: TextOverflow.ellipsis,fontSize: 18, fontWeight: FontWeight.w700))),


    tabBarTheme: const TabBarTheme(
        unselectedLabelColor: Colors.white
    ),
  );


}