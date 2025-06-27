import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/sound_service.dart';

class ChoiceCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final String id;
  final bool isSelected;
  final bool isFavorited;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ChoiceCard({
    required this.label,
    required this.imagePath,
    required this.id,
    required this.isSelected,
    required this.isFavorited,
    this.onTap,
    this.onLongPress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
         // playFunnySound();
          if (onTap != null) onTap!();
        },
        onLongPress: onLongPress,
        child: Card(
          elevation: 6,
          color: Colors.white.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isSelected ? Colors.deepPurple : Colors.black,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    child: Image.asset(
                      imagePath,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (isFavorited)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(Icons.favorite, color: Colors.deepPurple),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
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
