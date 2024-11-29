import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/note.dart';
import '../services/lottie_cache_service.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _cacheService = LottieCacheService();
  Uint8List? _cachedAnimation;
  Uint8List? _butterflySticker;
  Uint8List? _unicornSticker;
  final List<Note> notes = [];
  
  final List<Color> noteColors = [
    const Color(0xFFFFC9C9), // нежно-розовый
    const Color(0xFFFFE0B2), // персиковый
    const Color(0xFFE1BEE7), // лавандовый
    const Color(0xFFB2EBF2), // голубой
    const Color(0xFFC8E6C9), // мятный
    const Color(0xFFF8BBD0), // розовый
  ];

  final Map<String, String> stickers = {
    'Бабочка': LottieCacheService.butterflySticker,
    'Единорог': LottieCacheService.unicornSticker,
  };

  String _selectedSticker = LottieCacheService.butterflySticker;

  void _selectSticker(String stickerPath) {
    setState(() {
      _selectedSticker = stickerPath;
    });
  }

  void _addNewNote() {
    showDialog(
      context: context,
      builder: (context) {
        String title = '';
        String content = '';
        Color selectedColor = noteColors[0];

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Новая заметка'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Заголовок',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => title = value,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Содержание',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) => content = value,
                    ),
                    const SizedBox(height: 16),
                    const Text('Выберите стикер:'),
                    _buildStickerPicker(),
                    const SizedBox(height: 16),
                    const Text('Выберите цвет:'),
                    Container(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: noteColors.length,
                        itemBuilder: (context, index) {
                          final color = noteColors[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedColor = color;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selectedColor == color
                                      ? Colors.pink
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: selectedColor == color
                                    ? [
                                        BoxShadow(
                                          color: Colors.pink.withOpacity(0.3),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Отмена'),
                ),
                TextButton(
                  onPressed: () {
                    if (title.isNotEmpty && content.isNotEmpty) {
                      setState(() {
                        notes.add(Note(
                          title: title,
                          content: content,
                          color: selectedColor,
                          stickerPath: _selectedSticker,
                        ));
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Сохранить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStickerPicker() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStickerOption(LottieCacheService.butterflySticker),
          _buildStickerOption(LottieCacheService.unicornSticker),
        ],
      ),
    );
  }

  Widget _buildStickerOption(String stickerPath) {
    return GestureDetector(
      onTap: () => _selectSticker(stickerPath),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Lottie.asset(
          stickerPath,
          width: 60,
          height: 60,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAnimation();
    _loadStickers();
  }

  Future<void> _loadAnimation() async {
    try {
      final animation = await _cacheService.loadAnimation('notes');
      if (mounted) {
        setState(() {
          _cachedAnimation = animation;
        });
      }
    } catch (e) {
      print('Error loading notes animation: $e');
    }
  }

  Future<void> _loadStickers() async {
    try {
      final service = LottieCacheService();
      _butterflySticker = await service.loadSticker('butterfly');
      _unicornSticker = await service.loadSticker('unicorn');
      setState(() {});
    } catch (e) {
      print('Error loading stickers: $e');
    }
  }

  Widget _buildSticker(Uint8List? stickerData) {
    if (stickerData == null) return const SizedBox();
    return SizedBox(
      width: 60,
      height: 60,
      child: Lottie.memory(
        stickerData,
        repeat: true,
        reverse: true,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildNoteCard(Note note, int index) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      color: noteColors[index % noteColors.length],
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                index % 2 == 0
                    ? _buildSticker(_butterflySticker)
                    : _buildSticker(_unicornSticker),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              note.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('dd.MM.yyyy HH:mm').format(note.createdAt),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.pink[100]!,
              Colors.purple[100]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: _cachedAnimation == null
                      ? const CircularProgressIndicator()
                      : Lottie.memory(
                          _cachedAnimation!,
                          fit: BoxFit.contain,
                          frameRate: FrameRate(60),
                          repeat: true,
                        ),
                ),
              ),
              Expanded(
                child: notes.isEmpty
                    ? Center(
                        child: Text(
                          'Нет заметок',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          return _buildNoteCard(note, index);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
