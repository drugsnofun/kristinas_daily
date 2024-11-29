import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class LottieCacheService {
  static final LottieCacheService _instance = LottieCacheService._internal();
  factory LottieCacheService() => _instance;
  LottieCacheService._internal();

  static const String notesAnimation = 'assets/animations/notes_new.json';
  static const String moodAnimation = 'assets/animations/mood_new.json';
  static const String calendarAnimation = 'assets/animations/calendar_new.json';

  // Стикеры для заметок
  static const String butterflySticker = 'assets/stickers/butterfly.json';
  static const String unicornSticker = 'assets/stickers/unicorn.json';

  // Анимации для трекера настроения
  static const String happyMood = 'assets/animations/mood_new.json';
  static const String neutralMood = 'assets/animations/test.json';

  final Map<String, Uint8List> _cache = {};

  Future<Uint8List> loadAnimation(String assetPath) async {
    if (_cache.containsKey(assetPath)) {
      return _cache[assetPath]!;
    }

    try {
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();
      _cache[assetPath] = bytes;
      return bytes;
    } catch (e) {
      debugPrint('Error loading Lottie animation: $e');
      rethrow;
    }
  }

  void clearCache() {
    _cache.clear();
  }
}
