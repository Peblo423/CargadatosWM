
import 'package:cargadatos/classes/sensor.dart';
import 'package:cargadatos/services/api_service.dart';
import 'package:flutter/material.dart';

// PANTALLA DE SENSORES
class SensoresScreen extends StatefulWidget {
  const SensoresScreen({Key? key}) : super(key: key);

  @override
  State<SensoresScreen> createState() => _SensoresScreenState();
}

class _SensoresScreenState extends State<SensoresScreen> {
  List<Sensor> sensores = [];
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  void _showAddDialog() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Sensor'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nombre del sensor',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                try {
                  await ApiService.createSensor({
                    'name': nameController.text,
                    'active': true,
                  });
                  Navigator.pop(context);
                  _loadSensores();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sensor creado')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
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
