import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../services/lottie_cache_service.dart';

class MoodEntry {
  final String mood;
  final String note;
  final DateTime date;

  MoodEntry({
    required this.mood,
    required this.note,
    required this.date,
  });
}

class MoodPage extends StatefulWidget {
  const MoodPage({Key? key}) : super(key: key);

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  final List<MoodEntry> moodEntries = [];
  final List<String> moods = ['😊', '😐', '😢', '😡', '😴'];
  String _selectedMood = '';
  String _moodNote = '';

  void _showMoodDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Как ты себя чувствуешь?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMoodOption('Happy'),
                  _buildMoodOption('Neutral'),
                ],
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Заметка',
                  hintText: 'Опиши свои чувства...',
                ),
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    _moodNote = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                if (_moodNote.isNotEmpty) {
                  setState(() {
                    moodEntries.add(MoodEntry(
                      mood: _selectedMood,
                      note: _moodNote,
                      date: DateTime.now(),
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
  }

  void _selectMood(String mood) {
    setState(() {
      if (mood == 'Happy') {
        _selectedMood = '😊';
      } else if (mood == 'Neutral') {
        _selectedMood = '😐';
      }
    });
  }

  Widget _buildMoodAnimation() {
    return Lottie.asset(
      LottieCacheService.moodAnimation,
      width: 200,
      height: 200,
      fit: BoxFit.contain,
    );
  }

  Widget _buildMoodOption(String mood) {
    String animationPath = mood == 'Happy' 
        ? LottieCacheService.happyMood 
        : LottieCacheService.neutralMood;
        
    return GestureDetector(
      onTap: () => _selectMood(mood),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Lottie.asset(
          animationPath,
          width: 80,
          height: 80,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMoodAnimation(),
            const SizedBox(height: 16),
            const Text(
              'Раздел в разработке',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _showMoodDialog,
              child: const Text('Добавить настроение'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMoodDialog,
        backgroundColor: Colors.pink[100],
        child: const Icon(
          Icons.add,
          color: Colors.pink,
        ),
      ),
    );
  }
}
