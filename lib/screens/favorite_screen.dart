import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/mood_db_service.dart';
import 'package:flutter/services.dart';
import '../services/sound_service.dart';
import 'controllers/favorite_controller.dart';

// هذا الملف يمثل صفحة المفضلة (FavoritePage)
// يعرض جميع الرسائل أو النصائح التي أضافها المستخدم إلى المفضلة مع إمكانية حذفها.

class FavoritePage extends StatelessWidget {
  final List<String> favorites;
  final bool isLoading;
  final Future<void> Function() onReload;
  final Future<void> Function(String) onRemove;
  const FavoritePage({
    Key? key,
    required this.favorites,
    required this.isLoading,
    required this.onReload,
    required this.onRemove,
  }) : super(key: key);

  // دالة تشغيل الصوت المضحك
  void _playFunnySound() {
    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.click);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Favorites'),
        backgroundColor: Colors.deepPurple,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : favorites.isEmpty
              ? Center(
                child: Text(
                  'You have not added anything to favorites yet.',
                  style: GoogleFonts.poppins(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )
              : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final item = favorites[index];
                  return ListTile(
                    leading: Icon(
                      Icons.favorite,
                      color: const Color.fromARGB(255, 206, 6, 224),
                    ),
                    title: Text(item, style: GoogleFonts.poppins()),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await onRemove(item);
                      },
                    ),
                  );
                },
              ),
    );
  }
}
