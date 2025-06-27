import 'package:flutter/material.dart';
import '../random_advice_screen.dart';
import '../../services/mood_db_service.dart';
import '../../services/sound_service.dart';

// -----------------------------------------------------------------------------
// هذا الملف مسؤول عن إدارة منطق صفحة الرسالة/النصيحة العشوائية (RandomAdviceController)
// يتحكم في إضافة الرسالة المعروضة إلى المفضلة.
// -----------------------------------------------------------------------------
class RandomAdviceController extends StatelessWidget {
  final String message;
  const RandomAdviceController({required this.message, Key? key})
    : super(key: key);

  Future<void> handleAddFavorite(BuildContext context) async {
    await MoodDB().addFavorite(message);
    Navigator.pop(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return RandomAdvicePageWithFavorite(
      message: message,
      onAddFavorite: handleAddFavorite,
    );
  }
}
