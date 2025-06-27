// هذا الملف مسؤول عن إدارة قاعدة بيانات التطبيق (MoodDB)
// يحتوي على دوال لإضافة، حذف، وتحديث الرسائل، المزاجات، والمفضلة.
// يقوم بإنشاء الجداول (نصائح المزاج، الرسائل، المفضلة) وتعبئتها بالبيانات الافتراضية.
// يوفر دوال لإضافة واسترجاع النصائح والرسائل والمفضلة.
// يستخدم SQLite عبر مكتبة sqflite.

import 'package:sqflite/sqflite.dart'; // استيراد مكتبة التعامل مع SQLite
import 'package:path/path.dart'; // استيراد مكتبة مسارات الملفات
import '../models/mood_model.dart'; // استيراد كلاس المزاجات

// قائمة روابط المزاجات الافتراضية (يمكنك تعديلها من هنا)
final List<Map<String, String>> moodLinksData = [
  {
    'mood_name': 'Happy',
    'song_url': 'https://youtu.be/ZbZSe6N_BXs?si=zB4oL7XORlsng4Dp',
    'podcast_url': 'https://youtu.be/r4ZdyS6v3qA?si=9j6omGLHDWQiqzDw',
    'audiobook_url': 'https://youtu.be/j4zIFLbRpNU?si=4ahSc9SLrWzZpAPz',
  },
  {
    'mood_name': 'Sad',
    'song_url': 'https://youtu.be/V9PVRfjEBTI?si=jzRW6_41W1pgE1Wj',
    'podcast_url': 'https://youtu.be/AJ1-WE1B2Ss?si=prTrSSwAsB1y4Qol',
    'audiobook_url': 'https://youtu.be/6gL0EOwfrVc?si=ByN730gvOGTmtx-K',
  },
  {
    'mood_name': 'Tired',
    'song_url': 'https://youtu.be/a7GITgqwDVg?si=wmPRaxQRVK-2q7Z3',
    'podcast_url': 'https://youtu.be/9EqrUK7ghho?si=y3RmYu7Hi8vZE6Qw',
    'audiobook_url': 'https://youtu.be/tHsx8i4zOMU?si=8mT4wuaj6HTduNJd',
  },
  {
    'mood_name': 'Motivated',
    'song_url': 'https://youtu.be/CuklIb9d3fI?si=3jJinxztDrw4-wZu',
    'podcast_url': 'https://youtu.be/-gYpCIbZjUQ?si=E4GgHfX_Qc8ofR0S',
    'audiobook_url': 'https://youtu.be/ZpGhK-udx-E?si=H1vcNvFqXod4y2co',
  },
  {
    'mood_name': 'Calm',
    'song_url': 'https://youtu.be/RsEZmictANA?si=Gm1h4LuaC41QeG4a',
    'podcast_url': 'https://youtu.be/K0hkhbGYaGQ?si=v2BhE50t6YakJFg7',
    'audiobook_url': 'https://youtu.be/fw4bjaje7pM?si=PgUDDrbEu2k5kdWy',
  },
  {
    'mood_name': 'Broken',
    'song_url': 'https://youtu.be/syFZfO_wfMQ?si=LC26VQfYuuWUZcSf',
    'podcast_url': 'https://youtu.be/GcJVygChaxA?si=T6kuCjr00Tz6nI33',
    'audiobook_url': 'https://youtu.be/_oHBwHQa5No?si=9ifB7Y0woKobvZi1',
  },
  {
    'mood_name': 'Stressed',
    'song_url': 'https://youtu.be/-5q5mZbe3V8?si=aTafRVwZxjxy_92X',
    'podcast_url': 'https://youtu.be/XKnkiSJGjTk?si=sPdMBrfbXT24w8oK',
    'audiobook_url': 'https://youtu.be/GRQj3hsQiiM?si=F0-dnclA5fuKtSWS',
  },
  {
    'mood_name': 'Lonely',
    'song_url': 'https://youtu.be/CwfoyVa980U?si=n3ykq7ovEDPDaJui',
    'podcast_url': 'https://youtu.be/0SPC_Q7-k40?si=9sAD7fbhys8SRSKr',
    'audiobook_url': 'https://youtu.be/ixmOdqmrJkk?si=cEKJkQ3254NIawNO',
  },
  {
    'mood_name': 'Excited',
    'song_url': 'https://youtu.be/QJO3ROT-A4E?si=63WeG1-gKG4IL1tA',
    'podcast_url': 'https://youtu.be/AR-86T8jpuQ?si=HgVMC2mO_shdhvBG',
    'audiobook_url': 'https://youtu.be/k2D2V0YJVKk?si=2ASgGcqWi4PPUSO6',
  },
];

class MoodDB {
  // نمط Singleton لضمان وجود نسخة واحدة فقط من قاعدة البيانات
  static final MoodDB _instance = MoodDB._internal();
  factory MoodDB() => _instance;
  MoodDB._internal();

  static Database? _db; // متغير قاعدة البيانات

  // getter لإرجاع قاعدة البيانات أو تهيئتها إذا لم تكن موجودة
  Future<Database> get database async {
    if (_db != null) return _db!;
    // تهيئة قاعدة البيانات مرة واحدة فقط
    String path = join(
      await getDatabasesPath(),
      'mood.db',
    ); // تحديد مسار القاعدة
    _db = await openDatabase(
      path,
      version: 13, // رفع رقم النسخة
      onCreate: _onCreate, // دالة الإنشاء الأولي
      onUpgrade: _onUpgrade, // دالة الترقية
    );
    return _db!;
  }

  // دالة إنشاء الجداول عند أول تشغيل
  Future<void> _onCreate(Database db, int version) async {
    await _createAndInsertAll(db); // إنشاء جدول نصائح المزاج وتعبئته
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        message TEXT NOT NULL
      )
    '''); // إنشاء جدول الرسائل
    // إدخال رسائل افتراضية في جدول الرسائل
    final messages = [
      'You are amazing! Believe in yourself.',
      'Every day is a new beginning.',
      'Stay positive and strong.',
      'Your potential is endless.',
      'Never give up on your dreams.',
      'stay single.',
    ];
    for (var msg in messages) {
      await db.insert('messages', {'message': msg}); // إدخال كل رسالة
    }
    await db.execute('''
      CREATE TABLE favorites (
        message TEXT PRIMARY KEY
      )
    '''); // إنشاء جدول المفضلة

    // إنشاء جدول mood_links
    await db.execute('''
      CREATE TABLE mood_links (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mood_name TEXT NOT NULL,
        song_url TEXT NOT NULL,
        podcast_url TEXT NOT NULL,
        audiobook_url TEXT NOT NULL
      )
    ''');
    // إدخال بيانات الروابط الافتراضية
    for (var row in moodLinksData) {
      await db.insert('mood_links', row);
    }
  }

  // دالة الترقية (عند تغيير رقم النسخة)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // عند أي ترقية، احذف بيانات جدول mood_links وأعد إدخال البيانات الجديدة
    await db.delete('mood_links');
    for (var row in moodLinksData) {
      await db.insert('mood_links', row);
    }
    // لا تحذف الجداول القديمة الأخرى!
  }

  // دالة إنشاء جدول نصائح المزاج وتعبئته بالنصائح الافتراضية
  Future<void> _createAndInsertAll(Database db) async {
    await db.execute('''
      CREATE TABLE mood_messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mood TEXT NOT NULL,
        message TEXT NOT NULL
      )
    '''); // إنشاء جدول نصائح المزاج
    // إدخال نصائح افتراضية لكل مزاج
    final moods = {
      'Happy': [
        'Keep smiling, life is beautiful!',
        'Joy is your natural state.',
        'Spread happiness wherever you go.',
      ],
      'Sad': [
        'It\'s okay to feel sad sometimes.',
        'This too shall pass.',
        'You are stronger than you think.',
      ],
      'Tired': [
        'Take a break, you deserve it.',
        'Rest is productive too.',
        'Recharge and come back stronger.',
      ],
      'Motivated': [
        'Keep pushing forward!',
        'Your hard work will pay off.',
        'Stay focused on your goals.',
      ],
      'Calm': [
        'Breathe in peace, breathe out stress.',
        'Calmness is your superpower.',
        'Let tranquility fill your mind.',
      ],
      'Broken': [
        'Even broken crayons still color.',
        'Healing takes time, be gentle with yourself.',
        'You are not alone in this.',
      ],
      'Stressed': [
        'Take a deep breath, you got this.',
        'Step back and give yourself a break.',
        'Stress is temporary, your strength is permanent.',
      ],
      'Lonely': [
        'You matter, even if you feel alone.',
        'Reach out to someone you trust.',
        'Your presence is a gift to the world.',
      ],
      'Excited': [
        'Embrace the excitement and enjoy the moment!',
        'Let your enthusiasm inspire others.',
        'Great things are coming your way!',
      ],
    };
    for (var mood in moods.keys) {
      for (var msg in moods[mood]!) {
        await db.insert('mood_messages', {
          'mood': mood,
          'message': msg,
        }); // إدخال نصيحة لكل مزاج
      }
    }
  }

  // جلب نصيحة عشوائية حسب المزاج
  Future<String?> getRandomMessage(String mood) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT message FROM mood_messages WHERE mood = ? ORDER BY RANDOM() LIMIT 1',
      [mood],
    );
    return result.isNotEmpty ? result.first['message'] as String : null;
  }

  // جلب رسالة عشوائية من جدول الرسائل
  Future<String?> getRandomAnyMessage() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT message FROM messages ORDER BY RANDOM() LIMIT 1',
    );
    return result.isNotEmpty ? result.first['message'] as String : null;
  }

  // إضافة رسالة إلى المفضلة
  Future<void> addFavorite(String message) async {
    final db = await database;
    await db.insert('favorites', {
      'message': message,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  // حذف رسالة من المفضلة
  Future<void> removeFavorite(String message) async {
    final db = await database;
    await db.delete('favorites', where: 'message = ?', whereArgs: [message]);
  }

  // جلب جميع الرسائل المفضلة
  Future<List<String>> getFavorites() async {
    final db = await database;
    final result = await db.query('favorites');
    return result.map((row) => row['message'] as String).toList();
  }

  Future<bool> isFavorite(String message) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'message = ?',
      whereArgs: [message],
    );
    return result.isNotEmpty;
  }

  Future<void> addMessage(String message) async {
    final db = await database;
    await db.insert('messages', {'message': message});
  }

  Future<List<String>> getMessages() async {
    final db = await database;
    final result = await db.query('messages');
    return result.map((row) => row['message'] as String).toList();
  }

  // دالة لجلب روابط المزاج حسب mood_name
  Future<Map<String, String>?> getMoodLinks(String moodName) async {
    final db = await database;
    final result = await db.query(
      'mood_links',
      where: 'mood_name = ?',
      whereArgs: [moodName],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return {
        'song_url': result.first['song_url'] as String,
        'podcast_url': result.first['podcast_url'] as String,
        'audiobook_url': result.first['audiobook_url'] as String,
      };
    }
    return null;
  }
}
