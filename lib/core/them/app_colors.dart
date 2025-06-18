import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors

  static const Color primary =   Color(0xFF2E3A59);
  static const Color primaryLight = Color.fromARGB(255, 114, 126, 194);

  static const Color primaryDark = Color(0xFFE61E50);
  static const Color secondary = Color(0xFF2D3250);

  // Accent Colors
  static const Color accent1 = Color(0xFF00D9F5); // أزرق فاتح للتفاعلات
  static const Color accent2 = Color(0xFFFFA41B); // برتقالي للتنبيهات
  static const Color accent3 = Color(0xFF7A4EFE); // بنفسجي للمميزات الخاصة
  static const Color accent4 = Color(0xFFE0F7FA);

  // Neutral Colors
  static const Color black = Color(0xFF1A1A1A);
  static const Color darkGrey = Color(0xFF4A4A4A);
static const Color grey = Color(0xFFF5F5F5); // نفسها Colors.grey[100]
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color white = Colors.white;

  // Background Colors
  static const Color background = Colors.black;
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Color(0xFFF8F9FA);
  static const Color modalBackground = Color(0xFFFAFAFA);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFAAAAAA);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFFB74D);
  static const Color info = Color(0xFF2196F3);

  // Social & Engagement Colors
  static const Color like = Color(0xFFFF4B4B);
  static const Color share = Color(0xFF4B9DFF);
  static const Color comment = Color(0xFF4CAF50);
  static const Color points = Color(0xFFFFD700); // لون النقاط والجواهر

  // Gradient Colors
  static List<Color> primaryGradient = [
    primary,
    primaryLight,
  ];

  static List<Color> storyGradient = [
    const Color(0xFFFF6B93),
    const Color(0xFFFF3366),
  ];

  // Overlay & Shadow Colors
  static Color shadowColor = Colors.black.withOpacity(0.1);
  static Color overlayColor = Colors.black.withOpacity(0.5);
  static Color shimmerBase = Colors.grey[200]!;
  static Color shimmerHighlight = Colors.grey[100]!;
}



class AppColor {
  // الألوان الرئيسية
  static const Color primary = Color(0xFF4B6587); // أزرق هادئ للعناصر التفاعلية
  static const Color primaryDark = Color(0xFF345B83); // أزرق أغمق للتدرج
  static const Color background = Color(0xFFF0F4F8); // رمادي فاتح للخلفية
  static const Color surface = Color(0xFFFFFFFF); // أبيض للبطاقات والأسطح

  // الألوان الثانوية
  static const Color secondaryGreen = Color(0xFFA8D5BA); // أخضر ناعم للنجاح
  static const Color secondaryGreenDark = Color(0xFF8BC4A5); // تدرج أخضر
  static const Color secondaryPink = Color(0xFFF4A7B9); // وردي هادئ
  static const Color secondaryPinkDark = Color(0xFFE890A3); // تدرج وردي
  static const Color secondaryYellow = Color(0xFFFFCC80); // أصفر هادئ
  static const Color secondaryYellowDark = Color(0xFFFFB300); // تدرج أصفر

  // ألوان الإشعارات
  static const Color error = Color(0xFFFF8A80); // أحمر ناعم للأخطاء
  static const Color warning = Color(0xFFFFAB91); // برتقالي هادئ للتحذيرات
  static const Color success = Color(0xFFA8D5BA); // أخضر ناعم للنجاح

  // الألوان المحايدة
  static const Color textPrimary = Color(0xFF455A64); // رمادي داكن للنصوص الرئيسية
  static const Color textSecondary = Color(0xFF78909C); // رمادي متوسط للنصوص الثانوية
  static const Color divider = Color(0xFFECEFF1); // رمادي فاتح للحدود والفواصل

  // تدرجات الألوان للبطاقات
  static const LinearGradient doctorGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient departmentGradient = LinearGradient(
    colors: [secondaryGreen, secondaryGreenDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient subjectGradient = LinearGradient(
    colors: [secondaryPink, secondaryPinkDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient studentGradient = LinearGradient(
    colors: [secondaryYellow, secondaryYellowDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient reportGradient = LinearGradient(
    colors: [Color(0xFF90CAF9), Color(0xFF64B5F6)], // أزرق فاتح للتقارير
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}