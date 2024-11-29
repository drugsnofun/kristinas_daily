import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> quotes = [
    "Каждый день - это новая возможность быть счастливой! ✨",
    "Твоя улыбка делает мир ярче! 🌟",
    "Верь в себя, ты удивительная! 💖",
    "Сегодня будет прекрасный день! 🌸",
    "Ты справишься со всем, что задумала! 💪",
  ];

  String currentQuote = "";

  @override
  void initState() {
    super.initState();
    _updateQuote();
  }

  void _updateQuote() {
    final random = DateTime.now().millisecondsSinceEpoch % quotes.length;
    setState(() {
      currentQuote = quotes[random];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.pink[50]!,
            Colors.pink[100]!,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Цитата дня",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    currentQuote,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _updateQuote,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              "Новая цитата",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
