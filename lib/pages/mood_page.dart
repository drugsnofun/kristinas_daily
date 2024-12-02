import 'package:flutter/material.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  String _selectedMood = '';
  final TextEditingController _noteController = TextEditingController();
  final List<Map<String, dynamic>> _moodEntries = [];

  final List<Map<String, dynamic>> _moods = [
    {
      'emoji': '😊',
      'text': 'Счастлив(а)',
      'color': Colors.yellow[600],
    },
    {
      'emoji': '🙂',
      'text': 'Хорошо',
      'color': Colors.green[400],
    },
    {
      'emoji': '😐',
      'text': 'Нормально',
      'color': Colors.blue[400],
    },
    {
      'emoji': '😕',
      'text': 'Не очень',
      'color': Colors.orange[400],
    },
    {
      'emoji': '😢',
      'text': 'Грустно',
      'color': Colors.red[400],
    },
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _addMoodEntry() {
    if (_selectedMood.isNotEmpty) {
      setState(() {
        _moodEntries.insert(0, {
          'mood': _selectedMood,
          'note': _noteController.text,
          'timestamp': DateTime.now(),
          'color': _moods.firstWhere((m) => m['text'] == _selectedMood)['color'],
        });
        _selectedMood = '';
        _noteController.clear();
      });
    }
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
              const Color(0xFF1A237E).withOpacity(0.8),
              const Color(0xFF311B92).withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Как ваше настроение?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _moods.map((mood) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedMood = mood['text'];
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _selectedMood == mood['text']
                                          ? mood['color']
                                          : Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          mood['emoji'],
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          mood['text'],
                                          style: TextStyle(
                                            color: _selectedMood == mood['text']
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.8),
                                            fontWeight: _selectedMood == mood['text']
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _noteController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Добавить заметку...',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _addMoodEntry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber, // Яркий цвет фона кнопки для контраста
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Сохранить',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black, // Тёмный цвет текста для контраста
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _moodEntries.length,
                    itemBuilder: (context, index) {
                      final entry = _moodEntries[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: entry['color'],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    entry['mood'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${entry['timestamp'].hour}:${entry['timestamp'].minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                            if (entry['note'].isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                entry['note'],
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
