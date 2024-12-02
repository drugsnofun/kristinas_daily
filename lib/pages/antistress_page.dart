import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ZenMode {
  sand,
  magnet,
  neon,
  gradient
}

class AntistressPage extends StatefulWidget {
  const AntistressPage({super.key});

  @override
  State<AntistressPage> createState() => _AntistressPageState();
}

class _AntistressPageState extends State<AntistressPage> with TickerProviderStateMixin {
  final List<ZenParticle> _particles = [];
  final Random _random = Random();
  ZenMode _currentMode = ZenMode.sand;
  Offset? _touchPosition;
  bool _isPressed = false;
  bool _isInitialized = false;
  
  final Map<ZenMode, Color> _modeColors = {
    ZenMode.sand: Colors.amber,
    ZenMode.magnet: Colors.purple,
    ZenMode.neon: Colors.cyan,
    ZenMode.gradient: Colors.pink,
  };

  final Map<ZenMode, String> _modeNames = {
    ZenMode.sand: 'Песок',
    ZenMode.magnet: 'Магнит',
    ZenMode.neon: 'Неон',
    ZenMode.gradient: 'Градиент',
  };

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _initializeParticles(Size screenSize) {
    if (_isInitialized) return;
    _isInitialized = true;
    
    const numParticles = 1000;
    for (var i = 0; i < numParticles; i++) {
      _particles.add(ZenParticle(
        position: Offset(
          _random.nextDouble() * screenSize.width,
          _random.nextDouble() * screenSize.height,
        ),
        velocity: Offset.zero,
        color: _getParticleColor(i / numParticles),
        size: _random.nextDouble() * 4 + 2,
      ));
    }
  }

  Color _getParticleColor(double progress) {
    switch (_currentMode) {
      case ZenMode.sand:
        return Colors.amber.withOpacity(0.8);
      case ZenMode.magnet:
        return Colors.purple.withOpacity(0.8);
      case ZenMode.neon:
        return HSLColor.fromAHSL(
          0.8,
          (progress * 360) % 360,
          1.0,
          0.5,
        ).toColor();
      case ZenMode.gradient:
        return Color.lerp(
          Colors.pink,
          Colors.blue,
          progress,
        )!.withOpacity(0.8);
    }
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 16), () {
      if (!mounted) return;
      _updateParticles();
      _startAnimation();
    });
  }

  void _updateParticles() {
    if (!_isInitialized) return;
    final screenSize = MediaQuery.of(context).size;
    setState(() {
      for (var particle in _particles) {
        switch (_currentMode) {
          case ZenMode.sand:
            _updateSandParticle(particle, screenSize);
            break;
          case ZenMode.magnet:
            _updateMagnetParticle(particle, screenSize);
            break;
          case ZenMode.neon:
            _updateNeonParticle(particle, screenSize);
            break;
          case ZenMode.gradient:
            _updateGradientParticle(particle, screenSize);
            break;
        }
      }
    });
  }

  void _updateSandParticle(ZenParticle particle, Size screenSize) {
    if (_touchPosition != null && _isPressed) {
      final distance = (particle.position - _touchPosition!).distance;
      if (distance < 100) {
        final angle = (particle.position - _touchPosition!).direction;
        particle.velocity += Offset(cos(angle), sin(angle)) * (100 - distance) / 100 * 2;
      }
    }
    
    particle.velocity += const Offset(0, 0.5); // Гравитация
    particle.velocity *= 0.95; // Трение
    particle.position += particle.velocity;

    // Границы экрана
    if (particle.position.dy > screenSize.height - particle.size) {
      particle.position = Offset(particle.position.dx, screenSize.height - particle.size);
      particle.velocity = Offset(particle.velocity.dx * 0.3, -particle.velocity.dy * 0.3);
    }
    if (particle.position.dx < 0 || particle.position.dx > screenSize.width) {
      particle.velocity = Offset(-particle.velocity.dx * 0.3, particle.velocity.dy);
    }
  }

  void _updateMagnetParticle(ZenParticle particle, Size screenSize) {
    if (_touchPosition != null) {
      final distance = (particle.position - _touchPosition!).distance;
      if (distance < 200) {
        final angle = (particle.position - _touchPosition!).direction;
        final force = _isPressed ? -1.0 : 1.0;
        particle.velocity += Offset(cos(angle), sin(angle)) * force * (200 - distance) / 200;
      }
    }
    
    particle.velocity *= 0.95;
    particle.position += particle.velocity;

    // Держим частицы в пределах экрана
    particle.position = Offset(
      particle.position.dx.clamp(0, screenSize.width),
      particle.position.dy.clamp(0, screenSize.height),
    );
  }

  void _updateNeonParticle(ZenParticle particle, Size screenSize) {
    if (_touchPosition != null && _isPressed) {
      final distance = (particle.position - _touchPosition!).distance;
      if (distance < 150) {
        final angle = _random.nextDouble() * pi * 2;
        particle.velocity += Offset(cos(angle), sin(angle)) * 2;
        particle.color = HSLColor.fromAHSL(
          0.8,
          (_random.nextDouble() * 360),
          1.0,
          0.5,
        ).toColor();
      }
    }
    
    particle.velocity *= 0.98;
    particle.position += particle.velocity;

    // Отражение от границ
    if (particle.position.dx < 0 || particle.position.dx > screenSize.width) {
      particle.velocity = Offset(-particle.velocity.dx, particle.velocity.dy);
    }
    if (particle.position.dy < 0 || particle.position.dy > screenSize.height) {
      particle.velocity = Offset(particle.velocity.dx, -particle.velocity.dy);
    }
  }

  void _updateGradientParticle(ZenParticle particle, Size screenSize) {
    if (_touchPosition != null && _isPressed) {
      final distance = (particle.position - _touchPosition!).distance;
      if (distance < 120) {
        final progress = distance / 120;
        particle.color = Color.lerp(
          Colors.pink,
          Colors.blue,
          progress,
        )!.withOpacity(0.8);
        
        final angle = (particle.position - _touchPosition!).direction;
        particle.velocity += Offset(cos(angle), sin(angle)) * (1 - progress) * 2;
      }
    }
    
    particle.velocity *= 0.95;
    particle.position += particle.velocity;

    // Плавное возвращение в пределы экрана
    if (particle.position.dx < 0) particle.velocity += const Offset(0.5, 0);
    if (particle.position.dx > screenSize.width) particle.velocity += const Offset(-0.5, 0);
    if (particle.position.dy < 0) particle.velocity += const Offset(0, 0.5);
    if (particle.position.dy > screenSize.height) particle.velocity += const Offset(0, -0.5);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _touchPosition = details.localPosition;
      _isPressed = true;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    _initializeParticles(screenSize);
    
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
        child: Stack(
          children: [
            // Частицы
            GestureDetector(
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: CustomPaint(
                size: Size(screenSize.width, screenSize.height),
                painter: ParticlePainter(
                  particles: _particles,
                  mode: _currentMode,
                ),
              ),
            ),
            // Режимы
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ZenMode.values.map((mode) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentMode = mode;
                            HapticFeedback.lightImpact();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _currentMode == mode
                              ? _modeColors[mode]
                              : _modeColors[mode]?.withOpacity(0.3),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          _modeNames[mode] ?? '',
                          style: TextStyle(
                            color: Colors.white.withOpacity(
                              _currentMode == mode ? 1.0 : 0.7,
                            ),
                            fontWeight: _currentMode == mode
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    )).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ZenParticle {
  Offset position;
  Offset velocity;
  Color color;
  final double size;

  ZenParticle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
  });
}

class ParticlePainter extends CustomPainter {
  final List<ZenParticle> particles;
  final ZenMode mode;

  ParticlePainter({
    required this.particles,
    required this.mode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      if (mode == ZenMode.neon) {
        paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
        paint.strokeWidth = 2;
      }

      canvas.drawCircle(particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
