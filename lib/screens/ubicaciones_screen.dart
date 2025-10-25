
import 'package:cargadatos/services/api_service.dart';
import 'package:flutter/material.dart';

// PANTALLA DE UBICACIONES
class UbicacionesScreen extends StatefulWidget {
  const UbicacionesScreen({Key? key}) : super(key: key);

  @override
  State<UbicacionesScreen> createState() => _UbicacionesScreenState();
}

class _UbicacionesScreenState extends State<UbicacionesScreen> {
  List<dynamic> ubicaciones = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUbicaciones();
  }

  Future<void> _loadUbicaciones() async {
    try {
      final data = await ApiService.getLocations();
      setState(() {
        ubicaciones = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            duration: Duration(seconds: 999),
          ),
        );
      }
    }
  }

  void _showAddDialog() {
    final nameController = TextEditingController();
    final latController = TextEditingController();
    final lonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Ubicación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del lugar',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: latController,
              decoration: const InputDecoration(
                labelText: 'Latitud',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: lonController,
              decoration: const InputDecoration(
                labelText: 'Longitud',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
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
                  await ApiService.createLocation({
                    'name': nameController.text,
                    'latitude': latController.text,
                    'longitude': lonController.text,
                  });
                  Navigator.pop(context);
                  _loadUbicaciones();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ubicación creada')),
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
      appBar: AppBar(title: const Text('Gestión de Ubicaciones')),
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
                onRefresh: _loadUbicaciones,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: ubicaciones.length,
                  itemBuilder: (context, index) {
                    final ubicacion = ubicaciones[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.cyan[700],
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          ubicacion['name'] ?? 'Sin nombre',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Lat: ${ubicacion['latitude'] ?? ''}\nLon: ${ubicacion['longitude'] ?? ''}',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            try {
                              await ApiService.deleteLocation(
                                ubicacion['id'].toString(),
                              );
                              _loadUbicaciones();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Ubicación eliminada'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${e.toString()}')),
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
        backgroundColor: Colors.cyan[700],
        child: const Icon(Icons.add),
      ),
    );
  }
}
