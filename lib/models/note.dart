import 'package:flutter/material.dart';

class Note {
  final String title;
  final String content;
  final Color color;
  final String stickerPath;
  final DateTime createdAt;

  Note({
    required this.title,
    required this.content,
    required this.color,
    required this.stickerPath,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();
}
