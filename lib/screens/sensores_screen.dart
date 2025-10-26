import 'package:cargadatos/classes/sensor_response.dart';
import 'package:cargadatos/classes/sensor_sent.dart';
import 'package:cargadatos/services/api_service.dart';
import 'package:flutter/material.dart';

// PANTALLA DE SENSORES
class SensoresScreen extends StatefulWidget {
  const SensoresScreen({super.key});

  @override
  State<SensoresScreen> createState() => _SensoresScreenState();
}

class _SensoresScreenState extends State<SensoresScreen> {
  List<SensorResponse> sensores = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSensores();
  }

  Future<void> _loadSensores() async {
    try {
      final data = await ApiService.getSensors();
      setState(() {
        sensores = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  void _showAddDialog() {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final manufacturerCtrl = TextEditingController();
    final modelCtrl = TextEditingController();
    final serialNumberCtrl = TextEditingController();
    final sensorTypeCtrl = TextEditingController();
    final installedAtCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    bool isActive = true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Sensor'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(nameCtrl, 'Nombre'),
                    _buildTextField(manufacturerCtrl, 'Fabricante'),
                    _buildTextField(modelCtrl, 'Modelo'),
                    _buildTextField(serialNumberCtrl, 'Número de Serie'),
                    _buildTextField(sensorTypeCtrl, 'Tipo de Sensor'),
                    _buildTextField(installedAtCtrl, 'Fecha Instalación (YYYY-MM-DDTHH:MM:SSZ)'),
                    _buildTextField(notesCtrl, 'Notas', maxLines: 3),
                    SwitchListTile(
                      title: const Text('Activo'),
                      value: isActive,
                      onChanged: (bool value) {
                        setState(() {
                          isActive = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  final newSensor = SensorSent(
                    name: nameCtrl.text,
                    manufacturer: manufacturerCtrl.text,
                    model: modelCtrl.text,
                    serialNumber: serialNumberCtrl.text,
                    sensorType: sensorTypeCtrl.text,
                    installedAt: installedAtCtrl.text,
                    active: isActive,
                    notes: notesCtrl.text,
                  );

                  await ApiService.createSensor(newSensor);
                  Navigator.pop(context);
                  _loadSensores();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sensor creado con éxito')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al crear: ${e.toString()}')),
                    );
                  }
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es requerido';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Sensores')),
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
            : RefreshIndicator(
                onRefresh: _loadSensores,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sensores.length,
                  itemBuilder: (context, index) {
                    final sensor = sensores[index];
                    final isActive = sensor.active ?? false;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isActive
                              ? Colors.green[700]
                              : Colors.grey[600],
                          child: const Icon(Icons.sensors, color: Colors.white),
                        ),
                        title: Text(
                          sensor.name ?? 'Sin nombre',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Estado: ${isActive ? "Activo" : "Inactivo"}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            try {
                              await ApiService.deleteSensor(
                                sensor.id.toString(),
                              );
                              _loadSensores();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Sensor eliminado'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${e.toString()}'),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.lightBlue[700],
        child: const Icon(Icons.add),
      ),
    );
  }
}