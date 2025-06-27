// هذا الملف يمثل صفحة عرض رسالة أو نصيحة عشوائية (RandomAdvicePageWithFavorite)
// يمكن للمستخدم إضافة الرسالة المعروضة إلى المفضلة من خلال هذه الصفحة.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RandomAdvicePageWithFavorite extends StatelessWidget {
  final String message;
  final Future<void> Function(BuildContext) onAddFavorite;
  const RandomAdvicePageWithFavorite({required this.message, required this.onAddFavorite, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: Text('Your Sign For Today'),
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
                message,
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
                  await onAddFavorite(context);
                },
                icon: Icon(
                  Icons.favorite,
                  color: const Color.fromARGB(255, 235, 4, 4),
                ),
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
            ],
          ),
        ),
      ),
    );
  }
}
