import 'package:flutter/material.dart';
import '../home_screen.dart';
import '../../services/mood_db_service.dart';
import '../../services/sound_service.dart';
import 'favorite_controller.dart';
import 'random_advice_controller.dart';
import 'mood_question_controller.dart';

// -----------------------------------------------------------------------------
// هذا الملف مسؤول عن إدارة منطق الصفحة الرئيسية (HomeScreenController)
// يتحكم في اختيار المستخدم (مزاج/رسالة) وينقل المستخدم للصفحات المناسبة.
// -----------------------------------------------------------------------------
class HomeScreenController extends StatefulWidget {
  const HomeScreenController({Key? key}) : super(key: key);
  @override
  State<HomeScreenController> createState() => _HomeScreenControllerState();
}

class _HomeScreenControllerState extends State<HomeScreenController> {
  String? selectedChoice;

  void handleSelectChoice(String choice) {
    setState(() {
      selectedChoice = choice;
    });
  }

  void handleNext(BuildContext context) async {
    playFunnySound();
    if (!mounted) return;
    if (selectedChoice == 'advice') {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MoodQuestionController(),
        ),
      );
    } else if (selectedChoice == 'message') {
      final message = await MoodDB().getRandomAnyMessage();
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RandomAdviceController(message: message ?? 'No advice found.'),
        ),
      );
    } else if (selectedChoice != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You selected: $selectedChoice'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select one option')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      selectedChoice: selectedChoice,
      onSelectChoice: handleSelectChoice,
      onNext: handleNext,
    );
  }
} 