import 'package:flutter/material.dart';
import '../mood_question_screen.dart';
import '../../services/mood_db_service.dart';
import 'package:flutter/foundation.dart';
import '../../services/sound_service.dart';

// -----------------------------------------------------------------------------
// هذا الملف مسؤول عن إدارة منطق صفحة اختيار المزاج (MoodQuestionController)
// يتحكم في اختيار المزاج، التنقل لصفحة النصيحة، وإضافة للمفضلة.
// -----------------------------------------------------------------------------
class MoodQuestionController extends StatefulWidget {
  final void Function(String)? onAddFavorite;
  const MoodQuestionController({Key? key, this.onAddFavorite})
    : super(key: key);
  @override
  State<MoodQuestionController> createState() => _MoodQuestionControllerState();
}

class _MoodQuestionControllerState extends State<MoodQuestionController> {
  String? selectedMood;

  void handleSelectMood(String mood) {
    setState(() {
      selectedMood = mood;
    });
  }

  void handleContinue(BuildContext context) async {
    playFunnySound();
    if (kDebugMode) print('Selected mood: $selectedMood');
    if (selectedMood != null) {
      final message = await MoodDB().getRandomMessage(selectedMood!);
      if (kDebugMode) print('Advice message: $message');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => MoodAdvicePage(
                mood: selectedMood!,
                message: message ?? 'No advice found for this mood.',
              ),
        ),
      );
    } else {
      if (kDebugMode) print('No mood selected');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => MoodAdvicePage(
                mood: 'No mood selected',
                message: 'Please select your mood.',
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MoodQuestionPage(
      selectedMood: selectedMood,
      onSelectMood: handleSelectMood,
      onContinue: handleContinue,
      onAddFavorite: widget.onAddFavorite,
    );
  }
}
