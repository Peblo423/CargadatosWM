
import 'package:cargadatos/classes/medicion_response.dart';
import 'package:cargadatos/classes/medicion_sent.dart';
import 'package:cargadatos/classes/sensor_response.dart';
import 'package:cargadatos/classes/ubicacion_response.dart';
import 'package:cargadatos/services/api_service.dart';
import 'package:flutter/material.dart';

// PANTALLA DE MEDICIONES
class MedicionesScreen extends StatefulWidget {
  const MedicionesScreen({super.key});

  @override
  State<MedicionesScreen> createState() => _MedicionesScreenState();
}

class _MedicionesScreenState extends State<MedicionesScreen> {
  List<MedicionResponse> mediciones = [];
  List<UbicacionResponse> locations = [];
  List<SensorResponse> sensors = [];

  String? selectedLocationId;
  String? selectedSensorId;

  final TextEditingController enteredByController = TextEditingController();
  final TextEditingController sampledByController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController batchIdController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final locationsData = await ApiService.getLocations();
      final sensorsData = await ApiService.getSensors();
      final medicionesData = await ApiService.getMeasurements();

      setState(() {
        locations = locationsData;
        sensors = sensorsData;
        mediciones = medicionesData;
        isLoading = false;
        if (locations.isNotEmpty) {
          selectedLocationId = locations[0].id.toString();
        }
        if (sensors.isNotEmpty) selectedSensorId = sensors[0].id.toString();
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  Future<void> _agregarMedicion() async {
    if (selectedLocationId == null || selectedSensorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sensor y Ubicación son requeridos')),
      );
      return;
    }

    try {
      final MedicionSent nuevaMedicion = MedicionSent(
        sensorId: int.parse(selectedSensorId!),
        locationId: int.parse(selectedLocationId!),
        enteredBy: int.tryParse(enteredByController.text),
        sampledBy: int.tryParse(sampledByController.text),
        sampledAt: DateTime.now(), // Usando la fecha y hora actual
        status: statusController.text.isNotEmpty ? statusController.text : null,
        source: sourceController.text.isNotEmpty ? sourceController.text : null,
        batchId: batchIdController.text.isNotEmpty
            ? batchIdController.text
            : null,
        comments: commentsController.text.isNotEmpty
            ? commentsController.text
            : null,
      );

      await ApiService.createMeasurement(nuevaMedicion);

      // Limpiar controladores
      for (var c in [
        enteredByController,
        sampledByController,
        statusController,
        sourceController,
        batchIdController,
        commentsController,
      ]) {
        c.clear();
      }

      _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Medición registrada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Mediciones')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Nueva Medición',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1565C0),
                                ),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                initialValue: selectedLocationId,
                                decoration: const InputDecoration(
                                  labelText: 'Ubicación',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.location_on),
                                ),
                                items: locations.map<DropdownMenuItem<String>>((
                                  loc,
                                ) {
                                  return DropdownMenuItem(
                                    value: loc.id.toString(),
                                    child: Text(loc.name ?? ''),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedLocationId = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                initialValue: selectedSensorId,
                                decoration: const InputDecoration(
                                  labelText: 'Sensor',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.sensors),
                                ),
                                items: sensors.map<DropdownMenuItem<String>>((
                                  sensor,
                                ) {
                                  return DropdownMenuItem(
                                    value: sensor.id.toString(),
                                    child: Text(sensor.name ?? ''),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedSensorId = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: enteredByController,
                                decoration: const InputDecoration(
                                  labelText: 'Ingresado por (ID)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: sampledByController,
                                decoration: const InputDecoration(
                                  labelText: 'Muestreado por (ID)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: statusController,
                                decoration: const InputDecoration(
                                  labelText: 'Estado',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: sourceController,
                                decoration: const InputDecoration(
                                  labelText: 'Fuente',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: batchIdController,
                                decoration: const InputDecoration(
                                  labelText: 'ID de Lote',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: commentsController,
                                decoration: const InputDecoration(
                                  labelText: 'Comentarios',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 3,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _agregarMedicion,
                                icon: const Icon(Icons.add),
                                label: const Text('Registrar Medición'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(16),
                                  backgroundColor: Colors.blue[700],
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 32,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Historial de Mediciones',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _loadData,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: mediciones.length,
                        itemBuilder: (context, index) {
                          final medicion = mediciones[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue[700],
                                child: const Icon(
                                  Icons.analytics,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                'Sensor: ${medicion.sensor} / Loc: ${medicion.location}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Fecha: ${medicion.sampledAt.toLocal().toString()}\nComentarios: ${medicion.comments}',
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
