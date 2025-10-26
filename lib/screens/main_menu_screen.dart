
import 'package:cargadatos/screens/login_screen.dart';
import 'package:cargadatos/screens/magnitudes_screen.dart';
import 'package:cargadatos/screens/mediciones_screen.dart';
import 'package:cargadatos/screens/sensores_screen.dart';
import 'package:cargadatos/screens/ubicaciones_screen.dart';
import 'package:cargadatos/screens/units_screen.dart';
import 'package:cargadatos/services/api_service.dart';
import 'package:flutter/material.dart';

// MENÚ PRINCIPAL
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Mediciones de Agua'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ApiConfig.authToken = null;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Icon(Icons.water_drop, size: 80, color: Colors.blue[700]),
              const SizedBox(height: 10),
              Text(
                'Gestión de Calidad del Agua',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Expanded(
                child: GridView.count(
                  crossAxisCount: MediaQuery.of(context).size.width > 600
                      ? 3
                      : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildMenuCard(
                      context,
                      'Magnitudes',
                      Icons.straighten,
                      Colors.blue[600]!,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MagnitudesScreen(),
                        ),
                      ),
                    ),
                    _buildMenuCard(
                      context,
                      'Ubicaciones',
                      Icons.location_on,
                      Colors.cyan[600]!,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UbicacionesScreen(),
                        ),
                      ),
                    ),
                    _buildMenuCard(
                      context,
                      'Sensores',
                      Icons.sensors,
                      Colors.lightBlue[600]!,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SensoresScreen(),
                        ),
                      ),
                    ),
                    _buildMenuCard(
                      context,
                      'Mediciones',
                      Icons.analytics,
                      Colors.blue[800]!,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MedicionesScreen(),
                        ),
                      ),
                    ),
                    _buildMenuCard(
                      context,
                      'Unidades',
                      Icons.format_list_numbered,
                      Colors.indigo[600]!,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UnitsScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
