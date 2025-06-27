// ملاحظة: جميع المزاجات في هذا الملف تأتي من MoodModel.moodList فقط.
// إذا أردت إضافة أو تعديل أو حذف مزاج، عدل فقط في mood_model.dart.
// هذا الملف يمثل صفحة اختيار المزاج (MoodQuestionPage) وعرض النصيحة بناءً على المزاج
// يمكن للمستخدم اختيار مزاجه، رؤية نصيحة مناسبة، وإضافة النصيحة إلى المفضلة.
import 'package:flutter/material.dart';
import '../services/mood_db_service.dart';
import '../models/mood_model.dart';
import '../widgets/mood_links_circles.dart';
import '../services/sound_service.dart';
import 'controllers/mood_question_controller.dart';
//import 'package:audioplayers/audioplayers.dart';
//import 'package:url_launcher/url_launcher.dart';
//import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MoodQuestionPage extends StatelessWidget {
  final String? selectedMood;
  final void Function(String) onSelectMood;
  final void Function(BuildContext) onContinue;
  final void Function(String)? onAddFavorite;
  const MoodQuestionPage({
    this.selectedMood,
    required this.onSelectMood,
    required this.onContinue,
    this.onAddFavorite,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color mainColor = Colors.deepPurple;
    return Scaffold(
      appBar: AppBar(
        title: Text('How do you feel?'),
        backgroundColor: mainColor,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Select your current mood',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // شبكة المربعات
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children:
                    MoodModel.moodList.map((mood) {
                      bool isSelected = selectedMood == mood.label;
                      return GestureDetector(
                        onTap: () => onSelectMood(mood.label),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? mainColor.withOpacity(0.8)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? mainColor : Colors.grey,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  mood.emoji,
                                  style: TextStyle(fontSize: 30),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  mood.label,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            SizedBox(height: 20),
            // زر استمرار
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () => onContinue(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: mainColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class MoodAdvicePage extends StatefulWidget {
  final String mood;
  final String message;
  const MoodAdvicePage({required this.mood, required this.message, Key? key})
    : super(key: key);

  @override
  _MoodAdvicePageState createState() => _MoodAdvicePageState();
}

class _MoodAdvicePageState extends State<MoodAdvicePage> {
  Map<String, String>? moodLinks;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLinks();
  }

  Future<void> _loadLinks() async {
    // جلب روابط المزاج من قاعدة البيانات
    final links = await MoodDB().getMoodLinks(widget.mood);
    setState(() {
      moodLinks = links;
      isLoading = false;
    });
  }

  Future<void> _addFavorite() async {
    playFunnySound(); // تشغيل الصوت عند إضافة إلى المفضلة
    await MoodDB().addFavorite(widget.message);
    Navigator.pop(context, widget.message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: Text('Advice for ${widget.mood}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.message,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  await _addFavorite();
                },
                icon: Icon(Icons.favorite, color: Colors.red),
                label: Text(
                  'Add to favorite',
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 254, 252, 252),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              // هنا تظهر الدوائر أسفل زر المفضلة
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                )
              else if (moodLinks != null)
                MoodLinksCircles(links: moodLinks!)
              else
                SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
