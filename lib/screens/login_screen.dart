// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:cargadatos/screens/main_menu_screen.dart';
import 'package:cargadatos/services/api_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete todos los campos')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.login(
        _usernameController.text,
        _passwordController.text,
      );

      ApiConfig.authToken = result['token'];

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainMenuScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AnimatedBackground(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 380),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 25,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.water_drop_outlined, size: 70, color: Colors.white),
                        const SizedBox(height: 16),
                        const Text(
                          'AquaMonitor Pro',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Monitoreo de calidad de agua en tiempo real',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 40),
                        _buildTextField(
                          controller: _usernameController,
                          hint: 'Nombre de usuario',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _passwordController,
                          hint: 'Contraseña',
                          icon: Icons.lock_outline,
                          obscureText: true,
                        ),
                        const SizedBox(height: 40),
                        _buildLoginButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.8)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
      onSubmitted: (_) => _login(),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 10,
          shadowColor: Colors.black.withOpacity(0.5),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D47A1)),
              )
            : const Text(
                'Ingresar al Sistema',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),
      ),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _dropController;
  final List<_WaterDrop> _drops = [];

  @override
  void initState() {
    super.initState();
    _dropController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..addListener(() {
      if (_dropController.value == 1.0) {
        _dropController.reset();
        _dropController.forward();
      }
    });
    _startDrops();
  }

  @override
  void dispose() {
    _dropController.dispose();
    super.dispose();
  }

  void _startDrops() {
    setState(() {
      _drops.clear();
      for (int i = 0; i < 25; i++) {
        _drops.add(_WaterDrop(delay: i * 0.1));
      }
    });
    _dropController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF01579B),
            Color(0xFF1565C0),
          ],
        ),
      ),
      child: Stack(
        children: _drops.map((drop) {
          return AnimatedBuilder(
            animation: _dropController,
            builder: (context, child) {
              final progress = (_dropController.value - drop.delay).clamp(0.0, 1.0);
              final yPosition = -20 + (progress * (MediaQuery.of(context).size.height + 40));
              final opacity = (1.0 - progress).clamp(0.0, 1.0);

              return Positioned(
                left: drop.xPosition * MediaQuery.of(context).size.width,
                top: yPosition,
                child: Opacity(
                  opacity: opacity,
                  child: Icon(
                    Icons.water_drop,
                    color: Colors.white.withOpacity(0.7),
                    size: drop.size,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class _WaterDrop {
  final double delay;
  final double xPosition;
  final double size;

  _WaterDrop({required this.delay})
      : xPosition = math.Random().nextDouble(),
        size = math.Random().nextDouble() * 20 + 10;
}
