// -----------------------------------------------------------------------------
// ملف home_screen.dart
// هذا الملف يمثل الصفحة الرئيسية (HomeScreen) بعد شاشة البداية
// يعرض خيارات المستخدم (اختيار المزاج أو الرسالة)، ويدير التنقل للقوائم الأخرى والمفضلة.
// يحتوي على منطق عرض الخيارات الرئيسية (المزاج أو الرسالة)،
// إدارة المفضلة، التنقل بين الصفحات، وبناء الواجهة الرئيسية للتطبيق.
// -----------------------------------------------------------------------------
import 'package:flutter/material.dart'; // واجهات Flutter
import 'package:google_fonts/google_fonts.dart'; // خطوط Google Fonts
import '../widgets/choice_card.dart';
import '../services/sound_service.dart';
import 'controllers/favorite_controller.dart';

class HomeScreen extends StatelessWidget {
  // الصفحة الرئيسية بعد البداية
  final String? selectedChoice;
  final void Function(String) onSelectChoice;
  final void Function(BuildContext) onNext;
  const HomeScreen({
    Key? key,
    required this.selectedChoice,
    required this.onSelectChoice,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color purpleColor = Colors.deepPurple; // اللون الرئيسي
    // بناء واجهة الصفحة
    return Scaffold(
      drawer: Drawer(
        // القائمة الجانبية
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: purpleColor),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: purpleColor),
              title: Text('Favorite'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            FavoriteController(), // فتح صفحة المفضلة فقط
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('images/pur.jpeg', fit: BoxFit.cover), // الخلفية
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Builder(
                        builder:
                            (context) => IconButton(
                              icon: Icon(Icons.menu, color: purpleColor),
                              onPressed:
                                  () => Scaffold.of(context).openDrawer(),
                            ),
                      ),
                      Spacer(),
                      Text(
                        'Elevate You',
                        style: GoogleFonts.greatVibes(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: purpleColor,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios, color: purpleColor),
                        onPressed: () {
                          playFunnySound();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'What would you like\nto choose?',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      ChoiceCard(
                        label: 'Your Mood ?',
                        imagePath: 'images/mood.gif',
                        id: 'advice',
                        isSelected: selectedChoice == 'advice',
                        isFavorited: false, // لم يعد هناك مفضلة هنا
                        onTap: () => onSelectChoice('advice'),
                        onLongPress: null, // لم يعد هناك مفضلة هنا
                      ),
                      SizedBox(width: 20),
                      ChoiceCard(
                        label: 'Your sign',
                        imagePath: 'images/surr.gif',
                        id: 'message',
                        isSelected: selectedChoice == 'message',
                        isFavorited: false, // لم يعد هناك مفضلة هنا
                        onTap: () => onSelectChoice('message'),
                        onLongPress: null, // لم يعد هناك مفضلة هنا
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: EdgeInsets.only(bottom: 30),
                  child: OutlinedButton(
                    onPressed: () => onNext(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: purpleColor, width: 2),
                      backgroundColor: Colors.white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Next',
                      style: GoogleFonts.poppins(
                        color: purpleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
