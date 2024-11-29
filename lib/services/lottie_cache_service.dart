import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';

class LottieCacheService {
  static final LottieCacheService _instance = LottieCacheService._internal();
  factory LottieCacheService() => _instance;
  LottieCacheService._internal();

  // Основные анимации
  static const String notesAnimation = '''
{
  "v": "5.5.7",
  "fr": 60,
  "ip": 0,
  "op": 180,
  "w": 512,
  "h": 512,
  "nm": "Notes Animation",
  "ddd": 0,
  "assets": [],
  "layers": [
    {
      "ddd": 0,
      "ind": 1,
      "ty": 4,
      "nm": "Paper",
      "sr": 1,
      "ks": {
        "o": {"a": 0, "k": 100},
        "r": {
          "a": 1,
          "k": [
            {"t": 0, "s": [0]},
            {"t": 90, "s": [-5]},
            {"t": 180, "s": [0]}
          ]
        },
        "p": {"a": 0, "k": [256, 256, 0]},
        "a": {"a": 0, "k": [0, 0, 0]},
        "s": {
          "a": 1,
          "k": [
            {"t": 0, "s": [100, 100]},
            {"t": 90, "s": [110, 110]},
            {"t": 180, "s": [100, 100]}
          ]
        }
      },
      "shapes": [
        {
          "ty": "rc",
          "p": {"a": 0, "k": [0, 0]},
          "s": {"a": 0, "k": [200, 250]},
          "r": {"a": 0, "k": 8}
        },
        {
          "ty": "fl",
          "c": {"a": 0, "k": [1, 1, 1, 1]}
        }
      ]
    },
    {
      "ddd": 0,
      "ind": 2,
      "ty": 4,
      "nm": "Lines",
      "sr": 1,
      "ks": {
        "o": {"a": 0, "k": 100},
        "r": {"a": 0, "k": 0},
        "p": {"a": 0, "k": [256, 256, 0]},
        "a": {"a": 0, "k": [0, 0, 0]},
        "s": {"a": 0, "k": [100, 100, 100]}
      },
      "shapes": [
        {
          "ty": "rc",
          "p": {"a": 0, "k": [0, -50]},
          "s": {"a": 0, "k": [150, 2]},
          "r": {"a": 0, "k": 0}
        },
        {
          "ty": "rc",
          "p": {"a": 0, "k": [0, 0]},
          "s": {"a": 0, "k": [150, 2]},
          "r": {"a": 0, "k": 0}
        },
        {
          "ty": "rc",
          "p": {"a": 0, "k": [0, 50]},
          "s": {"a": 0, "k": [150, 2]},
          "r": {"a": 0, "k": 0}
        },
        {
          "ty": "fl",
          "c": {"a": 0, "k": [0.8, 0.8, 0.8, 1]}
        }
      ]
    }
  ]
}''';

  static const String calendarAnimation = '''
{
  "v": "5.5.7",
  "fr": 60,
  "ip": 0,
  "op": 180,
  "w": 512,
  "h": 512,
  "nm": "Calendar Animation",
  "ddd": 0,
  "assets": [],
  "layers": [
    {
      "ddd": 0,
      "ind": 1,
      "ty": 4,
      "nm": "Calendar",
      "sr": 1,
      "ks": {
        "o": {"a": 0, "k": 100},
        "r": {
          "a": 1,
          "k": [
            {"t": 0, "s": [0]},
            {"t": 90, "s": [3]},
            {"t": 180, "s": [0]}
          ]
        },
        "p": {"a": 0, "k": [256, 256, 0]},
        "a": {"a": 0, "k": [0, 0, 0]},
        "s": {
          "a": 1,
          "k": [
            {"t": 0, "s": [100, 100]},
            {"t": 90, "s": [105, 105]},
            {"t": 180, "s": [100, 100]}
          ]
        }
      },
      "shapes": [
        {
          "ty": "rc",
          "p": {"a": 0, "k": [0, 0]},
          "s": {"a": 0, "k": [200, 250]},
          "r": {"a": 0, "k": 8}
        },
        {
          "ty": "fl",
          "c": {"a": 0, "k": [1, 1, 1, 1]}
        }
      ]
    },
    {
      "ddd": 0,
      "ind": 2,
      "ty": 4,
      "nm": "Header",
      "sr": 1,
      "ks": {
        "o": {"a": 0, "k": 100},
        "r": {"a": 0, "k": 0},
        "p": {"a": 0, "k": [256, 206, 0]},
        "a": {"a": 0, "k": [0, 0, 0]},
        "s": {"a": 0, "k": [100, 100, 100]}
      },
      "shapes": [
        {
          "ty": "rc",
          "p": {"a": 0, "k": [0, -100]},
          "s": {"a": 0, "k": [200, 40]},
          "r": {"a": 0, "k": 0}
        },
        {
          "ty": "fl",
          "c": {"a": 0, "k": [0.9, 0.9, 0.9, 1]}
        }
      ]
    }
  ]
}''';

  static const String moodAnimation = '''
{
  "v": "5.5.7",
  "fr": 60,
  "ip": 0,
  "op": 180,
  "w": 512,
  "h": 512,
  "nm": "Mood Animation",
  "ddd": 0,
  "assets": [],
  "layers": [
    {
      "ddd": 0,
      "ind": 1,
      "ty": 4,
      "nm": "Face",
      "sr": 1,
      "ks": {
        "o": {"a": 0, "k": 100},
        "r": {
          "a": 1,
          "k": [
            {"t": 0, "s": [0]},
            {"t": 90, "s": [10]},
            {"t": 180, "s": [0]}
          ]
        },
        "p": {"a": 0, "k": [256, 256, 0]},
        "a": {"a": 0, "k": [0, 0, 0]},
        "s": {
          "a": 1,
          "k": [
            {"t": 0, "s": [100, 100]},
            {"t": 90, "s": [110, 110]},
            {"t": 180, "s": [100, 100]}
          ]
        }
      },
      "shapes": [
        {
          "ty": "el",
          "p": {"a": 0, "k": [0, 0]},
          "s": {"a": 0, "k": [200, 200]}
        },
        {
          "ty": "fl",
          "c": {"a": 0, "k": [1, 0.8, 0, 1]}
        }
      ]
    }
  ]
}
''';

  static const String happyMood = '''
{
  "v": "5.5.7",
  "fr": 60,
  "ip": 0,
  "op": 180,
  "w": 512,
  "h": 512,
  "nm": "Happy Mood",
  "ddd": 0,
  "assets": [],
  "layers": [
    {
      "ddd": 0,
      "ind": 1,
      "ty": 4,
      "nm": "Happy Face",
      "sr": 1,
      "ks": {
        "o": {"a": 0, "k": 100},
        "r": {
          "a": 1,
          "k": [
            {"t": 0, "s": [0]},
            {"t": 90, "s": [10]},
            {"t": 180, "s": [0]}
          ]
        },
        "p": {"a": 0, "k": [256, 256, 0]},
        "a": {"a": 0, "k": [0, 0, 0]},
        "s": {
          "a": 1,
          "k": [
            {"t": 0, "s": [100, 100]},
            {"t": 90, "s": [110, 110]},
            {"t": 180, "s": [100, 100]}
          ]
        }
      },
      "shapes": [
        {
          "ty": "el",
          "p": {"a": 0, "k": [0, 0]},
          "s": {"a": 0, "k": [200, 200]}
        },
        {
          "ty": "fl",
          "c": {"a": 0, "k": [1, 0.8, 0, 1]}
        }
      ]
    }
  ]
}
''';

  static const String sadMood = '''
{
  "v": "5.5.7",
  "fr": 60,
  "ip": 0,
  "op": 180,
  "w": 512,
  "h": 512,
  "nm": "Sad Mood",
  "ddd": 0,
  "assets": [],
  "layers": [
    {
      "ddd": 0,
      "ind": 1,
      "ty": 4,
      "nm": "Sad Face",
      "sr": 1,
      "ks": {
        "o": {"a": 0, "k": 100},
        "r": {
          "a": 1,
          "k": [
            {"t": 0, "s": [0]},
            {"t": 90, "s": [-5]},
            {"t": 180, "s": [0]}
          ]
        },
        "p": {"a": 0, "k": [256, 256, 0]},
        "a": {"a": 0, "k": [0, 0, 0]},
        "s": {
          "a": 1,
          "k": [
            {"t": 0, "s": [100, 100]},
            {"t": 90, "s": [95, 95]},
            {"t": 180, "s": [100, 100]}
          ]
        }
      },
      "shapes": [
        {
          "ty": "el",
          "p": {"a": 0, "k": [0, 0]},
          "s": {"a": 0, "k": [200, 200]}
        },
        {
          "ty": "fl",
          "c": {"a": 0, "k": [0.5, 0.5, 0.8, 1]}
        }
      ]
    }
  ]
}
''';

  static const String neutralMood = '''
{
  "v": "5.5.7",
  "fr": 60,
  "ip": 0,
  "op": 180,
  "w": 512,
  "h": 512,
  "nm": "Neutral Mood",
  "ddd": 0,
  "assets": [],
  "layers": [
    {
      "ddd": 0,
      "ind": 1,
      "ty": 4,
      "nm": "Neutral Face",
      "sr": 1,
      "ks": {
        "o": {"a": 0, "k": 100},
        "r": {
          "a": 1,
          "k": [
            {"t": 0, "s": [0]},
            {"t": 90, "s": [3]},
            {"t": 180, "s": [0]}
          ]
        },
        "p": {"a": 0, "k": [256, 256, 0]},
        "a": {"a": 0, "k": [0, 0, 0]},
        "s": {
          "a": 1,
          "k": [
            {"t": 0, "s": [100, 100]},
            {"t": 90, "s": [102, 102]},
            {"t": 180, "s": [100, 100]}
          ]
        }
      },
      "shapes": [
        {
          "ty": "el",
          "p": {"a": 0, "k": [0, 0]},
          "s": {"a": 0, "k": [200, 200]}
        },
        {
          "ty": "fl",
          "c": {"a": 0, "k": [0.7, 0.7, 0.7, 1]}
        }
      ]
    }
  ]
}
''';

  static const String angryMood = '''
{
  "v": "5.5.7",
  "fr": 60,
  "ip": 0,
  "op": 180,
  "w": 512,
  "h": 512,
  "nm": "Angry Mood",
  "ddd": 0,
  "assets": [],
  "layers": [
    {
      "ddd": 0,
      "ind": 1,
      "ty": 4,
      "nm": "Angry Face",
      "sr": 1,
      "ks": {
        "o": {"a": 0, "k": 100},
        "r": {
          "a": 1,
          "k": [
            {"t": 0, "s": [0]},
            {"t": 45, "s": [-8]},
            {"t": 90, "s": [8]},
            {"t": 135, "s": [-8]},
            {"t": 180, "s": [0]}
          ]
        },
        "p": {"a": 0, "k": [256, 256, 0]},
        "a": {"a": 0, "k": [0, 0, 0]},
        "s": {
          "a": 1,
          "k": [
            {"t": 0, "s": [100, 100]},
            {"t": 90, "s": [108, 108]},
            {"t": 180, "s": [100, 100]}
          ]
        }
      },
      "shapes": [
        {
          "ty": "el",
          "p": {"a": 0, "k": [0, 0]},
          "s": {"a": 0, "k": [200, 200]}
        },
        {
          "ty": "fl",
          "c": {"a": 0, "k": [0.9, 0.3, 0.3, 1]}
        }
      ]
    }
  ]
}
''';

  static const String sleepyMood = '''
{
  "v": "5.5.7",
  "fr": 60,
  "ip": 0,
  "op": 180,
  "w": 512,
  "h": 512,
  "nm": "Sleepy Mood",
  "ddd": 0,
  "assets": [],
  "layers": [
    {
      "ddd": 0,
      "ind": 1,
      "ty": 4,
      "nm": "Sleepy Face",
      "sr": 1,
      "ks": {
        "o": {"a": 0, "k": 100},
        "r": {
          "a": 1,
          "k": [
            {"t": 0, "s": [0]},
            {"t": 90, "s": [15]},
            {"t": 180, "s": [0]}
          ]
        },
        "p": {"a": 0, "k": [256, 256, 0]},
        "a": {"a": 0, "k": [0, 0, 0]},
        "s": {
          "a": 1,
          "k": [
            {"t": 0, "s": [100, 100]},
            {"t": 45, "s": [95, 95]},
            {"t": 90, "s": [100, 100]},
            {"t": 135, "s": [95, 95]},
            {"t": 180, "s": [100, 100]}
          ]
        }
      },
      "shapes": [
        {
          "ty": "el",
          "p": {"a": 0, "k": [0, 0]},
          "s": {"a": 0, "k": [200, 200]}
        },
        {
          "ty": "fl",
          "c": {"a": 0, "k": [0.6, 0.4, 0.8, 1]}
        }
      ]
    }
  ]
}
''';

  // Стикеры для заметок
  static const String butterflySticker = '''
{
  "v": "5.5.7",
  "fr": 60,
  "ip": 0,
  "op": 180,
  "w": 512,
  "h": 512,
  "nm": "Butterfly Animation",
  "ddd": 0,
  "assets": [],
  "layers": [
    {
      "ddd": 0,
      "ind": 1,
      "ty": 4,
      "nm": "Butterfly",
      "sr": 1,
      "ks": {
        "o": {"a": 0, "k": 100},
        "r": {
          "a": 1,
          "k": [
            {"t": 0, "s": [0]},
            {"t": 45, "s": [15]},
            {"t": 90, "s": [0]},
            {"t": 135, "s": [-15]},
            {"t": 180, "s": [0]}
          ]
        },
        "p": {
          "a": 1,
          "k": [
            {"t": 0, "s": [256, 256, 0]},
            {"t": 45, "s": [256, 246, 0]},
            {"t": 90, "s": [256, 256, 0]},
            {"t": 135, "s": [256, 246, 0]},
            {"t": 180, "s": [256, 256, 0]}
          ]
        },
        "a": {"a": 0, "k": [0, 0, 0]},
        "s": {
          "a": 1,
          "k": [
            {"t": 0, "s": [100, 100]},
            {"t": 90, "s": [110, 110]},
            {"t": 180, "s": [100, 100]}
          ]
        }
      },
      "shapes": [
        {
          "ty": "gr",
          "it": [
            {
              "ty": "sh",
              "ks": {
                "a": 0,
                "k": {
                  "i": [[0,0], [0,0], [0,0]],
                  "o": [[0,0], [0,0], [0,0]],
                  "v": [[-50,0], [0,-50], [50,0]],
                  "c": false
                }
              }
            },
            {
              "ty": "st",
              "c": {"a": 0, "k": [1, 0.8, 0.9, 1]},
              "o": {"a": 0, "k": 100},
              "w": {"a": 0, "k": 8}
            }
          ]
        },
        {
          "ty": "gr",
          "it": [
            {
              "ty": "sh",
              "ks": {
                "a": 0,
                "k": {
                  "i": [[0,0], [0,0], [0,0]],
                  "o": [[0,0], [0,0], [0,0]],
                  "v": [[-50,0], [0,50], [50,0]],
                  "c": false
                }
              }
            },
            {
              "ty": "st",
              "c": {"a": 0, "k": [1, 0.8, 0.9, 1]},
              "o": {"a": 0, "k": 100},
              "w": {"a": 0, "k": 8}
            }
          ]
        }
      ]
    }
  ]
}''';

  static const String unicornSticker = '''
{
  "v": "5.5.7",
  "fr": 60,
  "ip": 0,
  "op": 180,
  "w": 512,
  "h": 512,
  "nm": "Unicorn Animation",
  "ddd": 0,
  "assets": [],
  "layers": [
    {
      "ddd": 0,
      "ind": 1,
      "ty": 4,
      "nm": "Unicorn",
      "sr": 1,
      "ks": {
        "o": {"a": 0, "k": 100},
        "r": {
          "a": 1,
          "k": [
            {"t": 0, "s": [0]},
            {"t": 90, "s": [5]},
            {"t": 180, "s": [0]}
          ]
        },
        "p": {"a": 0, "k": [256, 256, 0]},
        "a": {"a": 0, "k": [0, 0, 0]},
        "s": {
          "a": 1,
          "k": [
            {"t": 0, "s": [100, 100]},
            {"t": 90, "s": [105, 105]},
            {"t": 180, "s": [100, 100]}
          ]
        }
      },
      "shapes": [
        {
          "ty": "gr",
          "it": [
            {
              "ty": "sh",
              "ks": {
                "a": 0,
                "k": {
                  "i": [[0,0], [0,0], [0,0], [0,0]],
                  "o": [[0,0], [0,0], [0,0], [0,0]],
                  "v": [[-40,-20], [0,-60], [40,-20], [0,40]],
                  "c": true
                }
              }
            },
            {
              "ty": "fl",
              "c": {"a": 0, "k": [0.9, 0.8, 1, 1]}
            }
          ]
        },
        {
          "ty": "gr",
          "it": [
            {
              "ty": "sh",
              "ks": {
                "a": 0,
                "k": {
                  "i": [[0,0], [0,0]],
                  "o": [[0,0], [0,0]],
                  "v": [[0,-60], [0,-80]],
                  "c": false
                }
              }
            },
            {
              "ty": "st",
              "c": {"a": 0, "k": [1, 0.8, 0.9, 1]},
              "o": {"a": 0, "k": 100},
              "w": {"a": 0, "k": 8}
            }
          ]
        }
      ]
    }
  ]
}''';

  Future<Uint8List> loadSticker(String name) async {
    String jsonString;
    switch (name.toLowerCase()) {
      case 'butterfly':
        jsonString = butterflySticker;
        break;
      case 'unicorn':
        jsonString = unicornSticker;
        break;
      default:
        throw Exception('Sticker not found: $name');
    }
    return Uint8List.fromList(utf8.encode(jsonString));
  }

  final Map<String, Uint8List> _cache = {};

  Future<Uint8List> loadAnimation(String name) async {
    String jsonString;
    switch (name.toLowerCase()) {
      case 'notes':
        jsonString = notesAnimation;
        break;
      case 'calendar':
        jsonString = calendarAnimation;
        break;
      case 'mood':
        jsonString = moodAnimation;
        break;
      default:
        throw Exception('Animation not found: $name');
    }
    return Uint8List.fromList(utf8.encode(jsonString));
  }

  void clearCache() {
    _cache.clear();
  }
}
