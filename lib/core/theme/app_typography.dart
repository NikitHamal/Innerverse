/// Typography definitions for Innerverse using Poppins font
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography scale for Innerverse
abstract class AppTypography {
  /// Get the base text theme with Poppins font
  static TextTheme getTextTheme({required bool isDark}) {
    final baseColor = isDark ? const Color(0xFFF5F5F5) : const Color(0xFF1F1F1F);

    return TextTheme(
      // Display styles - for large, impactful text
      displayLarge: GoogleFonts.poppins(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
        color: baseColor,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.16,
        color: baseColor,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
        color: baseColor,
      ),

      // Headline styles - for section headers
      headlineLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.25,
        color: baseColor,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.29,
        color: baseColor,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.33,
        color: baseColor,
      ),

      // Title styles - for card titles, dialog titles
      titleLarge: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.27,
        color: baseColor,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.5,
        color: baseColor,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
        color: baseColor,
      ),

      // Body styles - for main content
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
        color: baseColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
        color: baseColor,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
        color: baseColor,
      ),

      // Label styles - for buttons, chips, etc.
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
        color: baseColor,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
        color: baseColor,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
        color: baseColor,
      ),
    );
  }

  /// Get monospace text style for debug/code display
  static TextStyle getMonoStyle({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: 0,
      height: 1.5,
      color: color,
    );
  }

  /// Cosmic/spiritual text style for special moments
  static TextStyle getCosmicStyle({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w300,
    Color? color,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: 2.0,
      height: 1.6,
      color: color,
    );
  }

  /// Handwritten style for personal notes (simulated)
  static TextStyle getHandwrittenStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
  }) {
    return GoogleFonts.caveat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: 0.5,
      height: 1.4,
      color: color,
    );
  }
}

/// Text style extensions for common modifications
extension TextStyleExtensions on TextStyle {
  /// Make text bold
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);

  /// Make text semi-bold
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  /// Make text medium weight
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  /// Make text light
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  /// Make text italic
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  /// Add underline
  TextStyle get underlined => copyWith(decoration: TextDecoration.underline);

  /// Add line through
  TextStyle get strikethrough => copyWith(decoration: TextDecoration.lineThrough);

  /// Change color
  TextStyle withColor(Color color) => copyWith(color: color);

  /// Change size
  TextStyle withSize(double size) => copyWith(fontSize: size);

  /// Change letter spacing
  TextStyle withLetterSpacing(double spacing) => copyWith(letterSpacing: spacing);

  /// Change line height
  TextStyle withHeight(double height) => copyWith(height: height);
}
