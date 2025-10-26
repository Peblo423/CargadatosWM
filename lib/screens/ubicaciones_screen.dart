
import 'package:cargadatos/classes/ubicacion_response.dart';
import 'package:cargadatos/classes/ubicacion_sent.dart';
import 'package:cargadatos/services/api_service.dart';
import 'package:flutter/material.dart';

// PANTALLA DE UBICACIONES
class UbicacionesScreen extends StatefulWidget {
  const UbicacionesScreen({super.key});

  @override
  State<UbicacionesScreen> createState() => _UbicacionesScreenState();
}

class _UbicacionesScreenState extends State<UbicacionesScreen> {
  List<UbicacionResponse> ubicaciones = [];
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
          ),
        );
      }
    }
  }

  void _showAddDialog() {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final descriptionCtrl = TextEditingController();
    final latCtrl = TextEditingController();
    final lonCtrl = TextEditingController();
    final altitudeCtrl = TextEditingController();
    final addressCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Ubicación'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameCtrl, 'Nombre'),
                _buildTextField(descriptionCtrl, 'Descripción', maxLines: 2),
                _buildTextField(latCtrl, 'Latitud'),
                _buildTextField(lonCtrl, 'Longitud'),
                _buildTextField(altitudeCtrl, 'Altitud'),
                _buildTextField(addressCtrl, 'Dirección'),
              ],
            ),
          ),
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
                  final newUbicacion = UbicacionSent(
                    name: nameCtrl.text,
                    description: descriptionCtrl.text,
                    latitude: double.tryParse(latCtrl.text),
                    longitude: double.tryParse(lonCtrl.text),
                    altitude: double.tryParse(altitudeCtrl.text),
                    address: addressCtrl.text,
                  );

                  await ApiService.createLocation(newUbicacion);
                  Navigator.pop(context);
                  _loadUbicaciones();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ubicación creada con éxito')),
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
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
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
                          ubicacion.name ?? 'Sin nombre',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Lat: ${ubicacion.latDd ?? 'N/A'}\nLon: ${ubicacion.lonDd ?? 'N/A'}',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            try {
                              await ApiService.deleteLocation(
                                ubicacion.id.toString(),
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
