// هذا الملف يحتوي على تعريف نموذج المزاج (MoodModel)
// ويحتوي على قائمة المزاجات المتاحة التي تظهر للمستخدم في التطبيق.
// يوفر تمثيلاً لكائن المزاج مع خصائص الاسم والرمز التعبيري.
// يستخدم البرمجة الكائنية (OOP) ويدعم التجريد (abstract class).

abstract class AbstractMood {
  String get label; // اسم المزاج (مثلاً: Happy)
  String get emoji; // الرمز التعبيري للمزاج
}

class MoodModel extends AbstractMood {
  final String _label; // خاصية الاسم (مغلقة - encapsulated)
  final String _emoji; // خاصية الرمز التعبيري (مغلقة)

  // مُنشئ الكلاس MoodModel
  MoodModel({required String label, required String emoji})
    : _label = label,
      _emoji = emoji;

  @override
  String get label => _label; // getter لاسم المزاج

  @override
  String get emoji => _emoji; // getter للرمز التعبيري

  // قائمة ثابتة بجميع المزاجات المدعومة في التطبيق
  static List<MoodModel> moodList = [
    MoodModel(label: 'Happy', emoji: '😊'),
    MoodModel(label: 'Sad', emoji: '😢'),
    MoodModel(label: 'Tired', emoji: '😴'),
    MoodModel(label: 'Motivated', emoji: '🔥'),
    MoodModel(label: 'Calm', emoji: '🧘‍♂️'),
    MoodModel(label: 'Broken', emoji: '💔'),
    MoodModel(label: 'Stressed', emoji: '😣'),
    MoodModel(label: 'Lonely', emoji: '😔'),
    MoodModel(label: 'Excited', emoji: '🥳'),
  ];
}
