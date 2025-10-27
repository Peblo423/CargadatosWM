// ignore_for_file: deprecated_member_use

import 'package:cargadatos/classes/magnitud_response.dart';
import 'package:cargadatos/classes/medicion_response.dart';
import 'package:cargadatos/classes/sensor_response.dart';
import 'package:cargadatos/classes/ubicacion_response.dart';
import 'package:cargadatos/classes/unidad_response.dart';
import 'package:cargadatos/classes/water_drop.dart';
import 'package:cargadatos/screens/login_screen.dart';
import 'package:cargadatos/screens/magnitudes_screen.dart';
import 'package:cargadatos/screens/mediciones_screen.dart';
import 'package:cargadatos/screens/sensores_screen.dart';
import 'package:cargadatos/screens/ubicaciones_screen.dart';
import 'package:cargadatos/screens/units_screen.dart';
import 'package:cargadatos/services/api_service.dart';
import 'package:flutter/material.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> with TickerProviderStateMixin {
  late List<SensorResponse> sensores = [];
  late List<MagnitudResponse> magnitudes = [];
  late List<UbicacionResponse> locations = [];
  late List<UnidadResponse> units = [];
  late List<MedicionResponse> measurements = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final magnitudesData = await ApiService.getMagnitudes();
    final locationsData = await ApiService.getLocations();
    final unitsData = await ApiService.getUnits();
    final sensoresData = await ApiService.getSensors();
    final measurementsData = await ApiService.getMeasurements();

    setState(() {
      magnitudes = magnitudesData;
      locations = locationsData;
      units = unitsData;
      sensores = sensoresData;
      measurements = measurementsData;
    });
  }
  @override
  Widget build(BuildContext context) {
    final List<Widget> modules = [
      _HoverCard(
        title: 'Magnitudes',
        subtitle: 'Variables físicas',
        stat: '${magnitudes.length} activas',
        icon: Icons.straighten_rounded,
        primaryColor: const Color(0xFF2196F3),
        secondaryColor: const Color(0xFF1976D2),
        decorIcon: Icons.trending_up,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MagnitudesScreen(),
          ),
        ),
      ),
      _HoverCard(
        title: 'Ubicaciones',
        subtitle: 'Puntos de muestreo',
        stat: '${locations.length} sitios',
        icon: Icons.location_on_rounded,
        primaryColor: const Color(0xFF00BCD4),
        secondaryColor: const Color(0xFF0097A7),
        decorIcon: Icons.map,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UbicacionesScreen(),
          ),
        ),
      ),
      _HoverCard(
        title: 'Sensores',
        subtitle: 'Dispositivos activos',
        stat: '${sensores.length} online',
        icon: Icons.sensors_rounded,
        primaryColor: const Color(0xFF03A9F4),
        secondaryColor: const Color(0xFF0288D1),
        decorIcon: Icons.wifi,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SensoresScreen(),
          ),
        ),
      ),
      _HoverCard(
        title: 'Mediciones',
        subtitle: 'Datos registrados',
        stat: '${measurements.length} en total',
        icon: Icons.analytics_rounded,
        primaryColor: const Color(0xFF1565C0),
        secondaryColor: const Color(0xFF0D47A1),
        decorIcon: Icons.show_chart,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MedicionesScreen(),
          ),
        ),
      ),
      _HoverCard(
        title: 'Unidades',
        subtitle: 'Sistema de medida',
        stat: '${units.length} tipos',
        icon: Icons.format_list_numbered_rounded,
        primaryColor: const Color(0xFF3F51B5),
        secondaryColor: const Color(0xFF303F9F),
        decorIcon: Icons.straighten,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UnitsScreen(),
          ),
        ),
      )
    ];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1565C0),
              const Color(0xFF0D47A1),
              const Color(0xFF01579B),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header elaborado
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.water_drop,
                                color: const Color(0xFF1565C0),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AquaMonitor Pro',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                    letterSpacing: 1.2,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.3),
                                        offset: const Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green[400],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.circle,
                                              size: 8, color: Colors.white),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Sistema Activo',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.logout, color: Colors.white),
                                onPressed: () {
                                  ApiConfig.authToken = null;
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LoginScreen()),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Salir',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Stats bar
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(Icons.location_on, locations.length.toString(), 'Ubicaciones'),
                          _buildDivider(),
                          _buildStatItem(Icons.devices, sensores.length.toString(), 'Sensores'),
                          _buildDivider(),
                          _buildStatItem(Icons.assessment, measurements.length.toString(), 'Mediciones'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Cards Grid con más contenido
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Módulos del Sistema',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF2196F3),
                                    const Color(0xFF1976D2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.apps, size: 14, color: Colors.white),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${modules.length} Módulos',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: GridView.count(
                            crossAxisCount:
                                MediaQuery.of(context).size.width > 600 ? 5 : 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.0,
                            children: modules,
                          ),
                        ),
                      ),
                      
                      // Footer mega elaborado
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue[50]!,
                                    Colors.cyan[50]!,
                                  ],
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildFooterFeature(
                                    Icons.water_drop,
                                    'Calidad del Agua',
                                    Colors.blue[700]!,
                                  ),
                                  _buildFooterFeature(
                                    Icons.eco,
                                    'Eco-Friendly',
                                    Colors.green[700]!,
                                  ),
                                  _buildFooterFeature(
                                    Icons.security,
                                    'Datos Seguros',
                                    Colors.orange[700]!,
                                  ),
                                  _buildFooterFeature(
                                    Icons.cloud_done,
                                    'Cloud Sync',
                                    Colors.purple[700]!,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[100],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.info_outline,
                                          size: 16,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '© 2025 AquaMonitor',
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            'Sistema de Monitoreo',
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 9,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.blue[700]!,
                                              Colors.blue[900]!,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.upgrade,
                                                size: 14, color: Colors.white),
                                            const SizedBox(width: 4),
                                            Text(
                                              'v1.2.0',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget _buildFooterFeature(IconData icon, String text, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget separado para las cards con hover
class _HoverCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String stat;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData decorIcon;
  final VoidCallback onTap;

  const _HoverCard({
    required this.title,
    required this.subtitle,
    required this.stat,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.decorIcon,
    required this.onTap,
  });

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _dropController;
  final List<WaterDrop> _drops = [];

  @override
  void initState() {
    super.initState();
    _dropController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..addListener(() {
      if (_isHovered && _dropController.value == 1.0) {
        _dropController.reset();
        _dropController.forward();
      }
    });
  }

  @override
  void dispose() {
    _dropController.dispose();
    super.dispose();
  }

  void _startDrops() {
    setState(() {
      _isHovered = true;
      _drops.clear();
      // Crear varias gotas con diferentes delays
      for (int i = 0; i < 3; i++) {
        _drops.add(WaterDrop(delay: i * 0.3));
      }
    });
    _dropController.forward();
  }

  void _stopDrops() {
    setState(() {
      _isHovered = false;
      _drops.clear();
    });
    _dropController.stop();
    _dropController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _startDrops(),
      onExit: (_) => _stopDrops(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: _isHovered
                ? LinearGradient(
                    colors: [widget.primaryColor, widget.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: _isHovered ? null : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.primaryColor.withOpacity(_isHovered ? 0.5 : 0.3),
                blurRadius: _isHovered ? 20 : 12,
                offset: Offset(0, _isHovered ? 10 : 6),
              ),
            ],
            border: Border.all(
              color: widget.primaryColor.withOpacity(_isHovered ? 0.8 : 0.2),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Círculos decorativos
                if (!_isHovered) ...[
                  Positioned(
                    right: -30,
                    top: -30,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            widget.primaryColor.withOpacity(0.15),
                            widget.primaryColor.withOpacity(0.05),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -20,
                    bottom: -20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            widget.secondaryColor.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],

                // Gotas de agua animadas
                if (_isHovered)
                  ..._drops.map((drop) => AnimatedBuilder(
                    animation: _dropController,
                    builder: (context, child) {
                      final progress = (_dropController.value - drop.delay).clamp(0.0, 1.0);
                      final yPosition = progress * 200;
                      final opacity = (1.0 - progress).clamp(0.0, 1.0);
                      
                      return Positioned(
                        left: drop.xPosition,
                        top: yPosition - 20,
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
                  )),

                // Badge con stat
                Positioned(
                  top: 10,
                  right: 10,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: _isHovered
                          ? LinearGradient(
                              colors: [Colors.white, Colors.white.withOpacity(0.9)],
                            )
                          : LinearGradient(
                              colors: [widget.primaryColor, widget.secondaryColor],
                            ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _isHovered 
                              ? Colors.white.withOpacity(0.4)
                              : widget.primaryColor.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.stat,
                      style: TextStyle(
                        color: _isHovered ? widget.primaryColor : Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: _isHovered
                              ? LinearGradient(
                                  colors: [Colors.white, Colors.white.withOpacity(0.9)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [widget.primaryColor, widget.secondaryColor],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: _isHovered 
                                  ? Colors.white.withOpacity(0.4)
                                  : widget.primaryColor.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          size: 26,
                          color: _isHovered ? widget.primaryColor : Colors.white,
                        ),
                      ),
                      const Spacer(),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _isHovered ? Colors.white : Colors.grey[800],
                        ),
                        child: Text(widget.title),
                      ),
                      const SizedBox(height: 3),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: 10,
                          color: _isHovered ? Colors.white.withOpacity(0.9) : Colors.grey[600],
                        ),
                        child: Text(
                          widget.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 30,
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: _isHovered
                                  ? LinearGradient(
                                      colors: [Colors.white, Colors.white.withOpacity(0.7)],
                                    )
                                  : LinearGradient(
                                      colors: [widget.primaryColor, widget.secondaryColor],
                                    ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                widget.decorIcon,
                                size: 12,
                                color: _isHovered
                                    ? Colors.white.withOpacity(0.8)
                                    : widget.primaryColor.withOpacity(0.6),
                              ),
                              const SizedBox(width: 3),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 10,
                                color: _isHovered
                                    ? Colors.white.withOpacity(0.7)
                                    : Colors.grey[400],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
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

