import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '../services/sound_service.dart';

/// Widget لعرض ثلاث دوائر (أغنية، بودكاست، كتاب صوتي) مع صورة واسم.
/// عند الضغط على أي دائرة، يتم فتح الرابط المناسب حسب المزاج في المتصفح الخارجي.
class MoodLinksCircles extends StatelessWidget {
  final Map<String, String>
  links; // يجب تمرير الروابط: song_url, podcast_url, audiobook_url
  const MoodLinksCircles({required this.links, Key? key}) : super(key: key);

  // دالة تشغيل الصوت المضحك
  void _playFunnySound() {
    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.click);
  }

  // دالة لفتح الرابط في المتصفح الخارجي
  Future<void> _launchUrl(BuildContext context, String url) async {
    playFunnySound();
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تعذر فتح الرابط: $url\nتأكد من وجود متصفح أو تطبيق يوتيوب على جهازك.',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء محاولة فتح الرابط:\n$url\nالسبب: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // بيانات الدوائر (الصورة، الاسم، الرابط)
    final List<_CircleData> circles = [
      _CircleData(
        image: 'images/songg.jpeg',
        label: 'Song',
        url: links['song_url'] ?? '',
      ),
      _CircleData(
        image: 'images/voice.jpeg',
        label: 'Podcast',
        url: links['podcast_url'] ?? '',
      ),
      _CircleData(
        image: 'images/bookk.jpeg',
        label: 'Audiobook',
        url: links['audiobook_url'] ?? '',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            circles.map((circle) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      playFunnySound();
                      if (circle.url.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('لا يوجد رابط لهذا المزاج!')),
                        );
                        print('الرابط فارغ لهذا المزاج: ${circle.label}');
                        return;
                      }
                      print('سيتم فتح الرابط: ${circle.url}');
                      _launchUrl(context, circle.url);
                    },
                    child: CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage(circle.image),
                      backgroundColor: Colors.deepPurple.shade50,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    circle.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}

// كلاس داخلي بسيط لتمثيل بيانات كل دائرة
class _CircleData {
  final String image;
  final String label;
  final String url;
  _CircleData({required this.image, required this.label, required this.url});
}
