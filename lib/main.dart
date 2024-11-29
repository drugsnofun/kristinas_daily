import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/notes_page.dart';
import 'pages/mood_page.dart';
import 'pages/photo_page.dart';
import 'pages/calendar_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kristina\'s Daily',
      theme: ThemeData(
        primarySwatch: MaterialColor(
          0xFFFFB5C5, // Пастельный розовый
          <int, Color>{
            50: Color(0xFFFFF0F3),
            100: Color(0xFFFFE4E9),
            200: Color(0xFFFFD4DC),
            300: Color(0xFFFFC4CF),
            400: Color(0xFFFFB5C5),
            500: Color(0xFFFFA5BB),
            600: Color(0xFFFF95B1),
            700: Color(0xFFFF85A7),
            800: Color(0xFFFF759D),
            900: Color(0xFFFF6593),
          },
        ),
        scaffoldBackgroundColor: Color(0xFFFFF0F3), // Светлый фон
        fontFamily: 'Roboto',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    NotesPage(),
    MoodPage(),
    PhotoPage(),
    CalendarPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kristina\'s Daily',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Заметки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            label: 'Настроение',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Фото',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Календарь',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
