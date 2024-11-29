import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/note.dart';
import '../services/lottie_cache_service.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
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

  Widget _buildHeaderAnimation() {
    return Lottie.asset(
      LottieCacheService.notesAnimation,
      width: 200,
      height: 200,
      fit: BoxFit.contain,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: notes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildHeaderAnimation(),
                        const SizedBox(height: 16),
                        Text(
                          'Нет заметок',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _addNewNote,
                          child: const Text('Добавить заметку'),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return Card(
                        color: note.color,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    note.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: Text(
                                      note.content,
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: Lottie.asset(
                                  note.stickerPath,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addNewNote,
            child: const Text('Добавить заметку'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
