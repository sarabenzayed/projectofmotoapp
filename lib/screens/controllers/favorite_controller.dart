import 'package:flutter/material.dart';
import '../favorite_screen.dart';
import '../../services/mood_db_service.dart';
import '../../services/sound_service.dart';

// -----------------------------------------------------------------------------
// هذا الملف مسؤول عن إدارة منطق صفحة المفضلة (FavoriteController)
// يتحكم في تحميل الرسائل المفضلة وحذفها من قاعدة البيانات.
// -----------------------------------------------------------------------------
class FavoriteController extends StatefulWidget {
  const FavoriteController({Key? key}) : super(key: key);
  @override
  State<FavoriteController> createState() => _FavoriteControllerState();
}

class _FavoriteControllerState extends State<FavoriteController> {
  List<String> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favs = await MoodDB().getFavorites();
    setState(() {
      favorites = favs;
      isLoading = false;
    });
  }

  Future<void> _removeFavorite(String message) async {
    playFunnySound();
    await MoodDB().removeFavorite(message);
    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return FavoritePage(
      favorites: favorites,
      isLoading: isLoading,
      onReload: _loadFavorites,
      onRemove: _removeFavorite,
    );
  }
} 