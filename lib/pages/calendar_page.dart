import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../services/lottie_cache_service.dart';
import 'dart:math' as math;

class Event {
  final String title;
  final String description;
  final DateTime date;
  final Color color;
  final String emoji;

  Event({
    required this.title,
    required this.description,
    required this.date,
    required this.color,
    required this.emoji,
  });
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final List<Event> events = [];
  DateTime selectedDate = DateTime.now();
  final List<String> weekDays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
  final List<String> months = [
    'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
    'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
  ];

  final _cacheService = LottieCacheService();
  String? _cachedAnimationPath;

  @override
  void initState() {
    super.initState();
    _loadAnimation();
  }

  Future<void> _loadAnimation() async {
    if (mounted) {
      setState(() {
        _cachedAnimationPath = 'assets/animations/calendar_new.json';
      });
    }
  }

  List<DateTime> _getDaysInMonth(DateTime date) {
    final first = DateTime(date.year, date.month, 1);
    final daysBefore = first.weekday - 1;
    final firstToDisplay = first.subtract(Duration(days: daysBefore));
    final last = DateTime(date.year, date.month + 1, 0);
    final daysAfter = 7 - last.weekday;
    final lastToDisplay = last.add(Duration(days: daysAfter));
    return List.generate(
      lastToDisplay.difference(firstToDisplay).inDays + 1,
      (index) => firstToDisplay.add(Duration(days: index)),
    );
  }

  bool _hasEventOnDay(DateTime date) {
    return events.any((event) =>
        event.date.year == date.year &&
        event.date.month == date.month &&
        event.date.day == date.day);
  }

  List<Event> _getEventsForDay(DateTime date) {
    return events.where((event) =>
        event.date.year == date.year &&
        event.date.month == date.month &&
        event.date.day == date.day).toList();
  }

  void _addEvent() {
    showDialog(
      context: context,
      builder: (context) {
        String title = '';
        String description = '';
        String selectedEmoji = '🎉';
        final List<String> emojis = ['🎉', '🎂', '🎁', '💝', '🌟'];
        Color selectedColor = Colors.pink[100]!;
        final List<Color> colors = [
          Colors.pink[100]!,
          Colors.purple[100]!,
          Colors.blue[100]!,
          Colors.green[100]!,
          Colors.orange[100]!,
        ];

        return AlertDialog(
          title: const Text('Новое событие'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Название'),
                  onChanged: (value) => title = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Описание'),
                  maxLines: 3,
                  onChanged: (value) => description = value,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: emojis
                      .map((emoji) => GestureDetector(
                            onTap: () => selectedEmoji = emoji,
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: colors
                      .map((color) => GestureDetector(
                            onTap: () => selectedColor = color,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ))
                      .toList(),
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
                if (title.isNotEmpty) {
                  setState(() {
                    events.add(Event(
                      title: title,
                      description: description,
                      date: selectedDate,
                      color: selectedColor,
                      emoji: selectedEmoji,
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

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInMonth(selectedDate);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = MediaQuery.of(context).padding;
    final maxWidth = math.min(screenWidth, 600.0);

    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    height: screenHeight * 0.35,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.pink[200]!.withOpacity(0.7),
                          Colors.purple[200]!.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: _cachedAnimationPath == null
                                ? const CircularProgressIndicator()
                                : Lottie.asset(
                                    _cachedAnimationPath!,
                                    fit: BoxFit.contain,
                                    frameRate: FrameRate(60),
                                    repeat: true,
                                  ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Добро пожаловать!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'Здесь ты можешь отслеживать свое настроение и вести заметки',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.purple[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.chevron_left),
                                  onPressed: () {
                                    setState(() {
                                      selectedDate = DateTime(
                                          selectedDate.year, selectedDate.month - 1);
                                    });
                                  },
                                ),
                                Text(
                                  '${months[selectedDate.month - 1]} ${selectedDate.year}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: () {
                                    setState(() {
                                      selectedDate = DateTime(
                                          selectedDate.year, selectedDate.month + 1);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: weekDays
                                  .map((day) => SizedBox(
                                        width: (maxWidth - 96) / 7,
                                        child: Center(
                                          child: Text(
                                            day,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: day == 'Сб' || day == 'Вс'
                                                  ? Colors.pink[300]
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(8),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              childAspectRatio: 1,
                            ),
                            itemCount: daysInMonth.length,
                            itemBuilder: (context, index) {
                              final date = daysInMonth[index];
                              final isSelected = date.year == selectedDate.year &&
                                  date.month == selectedDate.month &&
                                  date.day == selectedDate.day;
                              final isToday = date.year == DateTime.now().year &&
                                  date.month == DateTime.now().month &&
                                  date.day == DateTime.now().day;
                              final hasEvent = _hasEventOnDay(date);
                              final isCurrentMonth = date.month == selectedDate.month;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedDate = date;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.pink[100]
                                        : isToday
                                            ? Colors.pink[50]
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.pink
                                          : isToday
                                              ? Colors.pink[200]!
                                              : Colors.transparent,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Text(
                                          '${date.day}',
                                          style: TextStyle(
                                            color: !isCurrentMonth
                                                ? Colors.grey[400]
                                                : isSelected
                                                    ? Colors.pink
                                                    : Colors.black87,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      if (hasEvent)
                                        Positioned(
                                          right: 2,
                                          top: 2,
                                          child: Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Colors.pink[300],
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final events = _getEventsForDay(selectedDate);
                        if (index >= events.length) return null;
                        final event = events[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 8),
                          color: event.color.withOpacity(0.9),
                          child: ListTile(
                            leading: Text(
                              event.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                            title: Text(event.title),
                            subtitle: Text(event.description),
                          ),
                        );
                      },
                      childCount: _getEventsForDay(selectedDate).length,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(bottom: padding.bottom + 80),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addEvent,
          backgroundColor: Colors.pink[300],
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
