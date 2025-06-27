

// هذا الملف هو نقطة البداية لتشغيل تطبيق Flutter ويحتوي على تعريف التطبيق الرئيسي (MyApp)
// ويحدد شاشة البداية (SplashScreen) ويهيئ الخدمات الأساسية مثل الصوت.

import 'package:flutter/material.dart'; // استيراد مكتبة الواجهات الأساسية في Flutter
import 'screens/splash_screen.dart'; // استيراد الصفحة الرئيسية للتطبيق بعد شاشة البداية
import 'package:google_fonts/google_fonts.dart'; // استيراد خطوط Google Fonts
import 'services/sound_service.dart';

// ----------------------------- 
// نقطة البداية للتطبيق    
// -----------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFunnySound();
  runApp(const MyApp()); // تشغيل التطبيق وبدء واجهة المستخدم
}

// -----------------------------------------------------------------------------
// كلاس MyApp
// يمثل الجذر (root) لتطبيق Flutter ويحدد الصفحة الأولى التي تظهر للمستخدم.
// -----------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(), // تعيين الصفحة الافتتاحية
      debugShowCheckedModeBanner: false, // إخفاء شعار debug
    );
  }
}
