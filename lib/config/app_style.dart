import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyThemes{
  static const primaryLight = Color(0xFF2B7595);
  static const secondaryLight = Color(0xFFB5D4D2);

  static const primaryColor = Color(0xFF0A0A0A);//0d0d0d 0A0A0A 262626=> blue/orange
  static const secondaryColor = Color(0xFF343434);//Colors.grey.shade900;//1e1e1e//171717/333333 => white

  final Color googleColor = const Color(0xffDF4A32);

  static const black = Colors.black;
  static const white = Colors.white;



  //EXTRA FOR NOW
  static const lightOrange = Color(0xFFF8C387);
  static const darkRed = Color(0xFF8d211e);

  static final customTheme = ThemeData.light().copyWith(
      brightness: Brightness.light,
      iconTheme: const IconThemeData(color: white),
      indicatorColor: primaryLight, primaryColor: primaryLight, scaffoldBackgroundColor: secondaryColor,

      appBarTheme: AppBarTheme(
          backgroundColor: secondaryColor,
          iconTheme: const IconThemeData(color: white, size: 18),
          actionsIconTheme: const IconThemeData(size: 18),
          elevation: 0,
          toolbarHeight: 100,
          scrolledUnderElevation: 1,
          titleTextStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: white,
              textStyle: const TextStyle(overflow: TextOverflow.ellipsis)
      )
    ),

      checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateColor.resolveWith((states) => primaryLight),
    ),

      chipTheme: ChipThemeData(
        backgroundColor: primaryLight,
        deleteIconColor: white,
        elevation: 2,
        labelStyle: GoogleFonts.ptSans(textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,color: white))
    ),

      dialogTheme: DialogTheme(
      elevation: 2,
      titleTextStyle: GoogleFonts.ptSans(textStyle: const TextStyle(color: primaryLight, fontWeight: FontWeight.w600, fontSize: 16)),
    ),

      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(white), // Always white text
            textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.all(20),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
              ),
            ),
          )),

      inputDecorationTheme: InputDecorationTheme(
      hintStyle: GoogleFonts.poppins(color: Colors.grey),

      floatingLabelBehavior: FloatingLabelBehavior.always,
      floatingLabelStyle: GoogleFonts.poppins(color: primaryLight, fontWeight: FontWeight.bold, fontSize: 16),
      labelStyle: GoogleFonts.poppins(color: primaryLight, fontWeight: FontWeight.w500, fontSize: 16),

      errorStyle: GoogleFonts.poppins(color: darkRed, fontWeight: FontWeight.w500),

      prefixStyle: GoogleFonts.poppins(),
      suffixStyle: GoogleFonts.poppins(),

      iconColor: primaryLight,
      suffixIconColor: black,

      border: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryLight, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),

      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryLight, width: 1),
          borderRadius: BorderRadius.circular(10),
      ),

      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryLight, width: 1.5),
          borderRadius: BorderRadius.circular(10)
      ),

      errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: darkRed, width: 1.5),
          borderRadius: BorderRadius.circular(10)
      ),

      focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryLight, width: 1.5),
          borderRadius: BorderRadius.circular(10)
      ),
    ),
      
      navigationBarTheme: NavigationBarThemeData(
      elevation: 5,
      height: 70,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      indicatorColor: primaryColor, //the background behind selected one
      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
      labelTextStyle: MaterialStateProperty.all(
          GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,color: primaryColor))
      ),
      iconTheme: MaterialStateProperty.resolveWith<IconThemeData?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return const IconThemeData(color: Colors.grey, size: 25); // Disabled state
        }
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: white, size: 20); // Pressed state
        }
        return const IconThemeData(color: primaryColor, size: 25); // Default state
      }),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    ),

      outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.zero,
            ),
            // Enforce a white border across all states
            side: MaterialStateProperty.resolveWith<BorderSide>(
                  (states) {
                if (states.contains(MaterialState.pressed) ||
                    states.contains(MaterialState.hovered) ||
                    states.contains(MaterialState.focused)) {
                  return const BorderSide(color: Colors.white, width: 0.75);
                }
                return const BorderSide(color: Colors.white, width: 0.75);
              },
            ),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Always white icon/text
            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent), // Remove hover/press color effect
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                side: const BorderSide(color: white),
                borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
              ),
            ),
          )),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: white
    ),

      tabBarTheme: const TabBarTheme(
      unselectedLabelColor: black
    ),

      textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(),
      displayMedium: GoogleFonts.poppins(),
      displaySmall: GoogleFonts.poppins(
          color: MyThemes.primaryLight,
          fontSize: 14,
          decoration: TextDecoration.underline
      ),

      headlineLarge: GoogleFonts.poppins(
        fontSize: 60,
        fontWeight: FontWeight.w700,
        color: black,
        height: 1.2,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 35,
        fontWeight: FontWeight.bold,
        color: darkRed,
        height: 1.2,
      ),
      headlineSmall: GoogleFonts.poppins(),

      titleLarge: GoogleFonts.poppins(),
      titleMedium: GoogleFonts.poppins(),
      titleSmall: GoogleFonts.poppins(),

      labelLarge: GoogleFonts.poppins(),
      labelMedium: GoogleFonts.poppins(),
      labelSmall: GoogleFonts.poppins(),

      bodyLarge: GoogleFonts.poppins(),
      bodyMedium: GoogleFonts.poppins(),
      bodySmall: GoogleFonts.poppins(),
    )
  );
}