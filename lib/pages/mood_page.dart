import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../services/lottie_cache_service.dart';
import 'dart:typed_data';

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
  final _cacheService = LottieCacheService();
  Uint8List? _cachedAnimation;
  final List<MoodEntry> moodEntries = [];
  final List<String> moods = ['😊', '😐', '😢', '😡', '😴'];
  String _selectedMood = '';
  String _moodNote = '';

  @override
  void initState() {
    super.initState();
    _loadAnimation();
  }

  Future<void> _loadAnimation() async {
    try {
      final animation = await _cacheService.loadAnimation('mood');
      if (mounted) {
        setState(() {
          _cachedAnimation = animation;
        });
      }
    } catch (e) {
      print('Error loading mood animation: $e');
    }
  }

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

  Widget _buildMoodOption(String mood) {
    bool isSelected = _selectedMood == mood;
    String animationPath = mood == 'Happy' 
        ? LottieCacheService.happyMood 
        : LottieCacheService.neutralMood;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMood = mood;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Lottie.asset(
          animationPath,
          width: 80,
          height: 80,
          repeat: true,
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
              Colors.blue[100]!,
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
                child: moodEntries.isEmpty
                    ? Center(
                        child: Text(
                          'Нет записей о настроении',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: moodEntries.length,
                        itemBuilder: (context, index) {
                          final entry = moodEntries[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: ListTile(
                              leading: Text(
                                entry.mood,
                                style: const TextStyle(fontSize: 24),
                              ),
                              title: Text(entry.note),
                              subtitle: Text(
                                entry.date.toString().split('.')[0],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    moodEntries.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMoodDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
