
import 'package:cargadatos/classes/magnitud_sent.dart';
import 'package:cargadatos/classes/magnitud_response.dart';
import 'package:cargadatos/classes/unidad_response.dart';
import 'package:cargadatos/services/api_service.dart';
import 'package:flutter/material.dart';

// PANTALLA DE MAGNITUDES
class MagnitudesScreen extends StatefulWidget {
  const MagnitudesScreen({super.key});

  @override
  State<MagnitudesScreen> createState() => _MagnitudesScreenState();
}

class _MagnitudesScreenState extends State<MagnitudesScreen> {
  List<MagnitudResponse> magnitudes = [];
  List<UnidadResponse> units = [];
  bool isLoading = true;
  int? selectedUnitId;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);
    try {
      final magnitudesData = await ApiService.getMagnitudes();
      final List<UnidadResponse> unitsData = await ApiService.getUnits();
      setState(() {
        magnitudes = magnitudesData;
        units = unitsData;
        isLoading = false;
        if (units.isNotEmpty) {
          selectedUnitId = units[0].id;
        }
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando datos: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _loadMagnitudes() async {
    try {
      final data = await ApiService.getMagnitudes();
      setState(() {
        magnitudes = data;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error recargando magnitudes: ${e.toString()}')),
        );
      }
    }
  }

  void _showAddDialog() {
    final formKey = GlobalKey<FormState>();
    final groupNameCtrl = TextEditingController();
    final nameEnCtrl = TextEditingController();
    final abbreviationCtrl = TextEditingController();
    final wqxCodeCtrl = TextEditingController();
    final wmoCodeCtrl = TextEditingController();
    final isoIeeeCodeCtrl = TextEditingController();
    final decimalsCtrl = TextEditingController();
    final minValueCtrl = TextEditingController();
    final maxValueCtrl = TextEditingController();
    bool allowNegative = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Magnitud'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (units.isNotEmpty)
                      DropdownButtonFormField<int>(
                        initialValue: selectedUnitId,
                        decoration: const InputDecoration(labelText: 'Unidad'),
                        items: units.map<DropdownMenuItem<int>>((unit) {
                          return DropdownMenuItem<int>(
                            value: unit.id,
                            child: Text(unit.ucumCode ?? 'Sin nombre'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedUnitId = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Seleccione una unidad' : null,
                      ),
                    _buildTextField(groupNameCtrl, 'Grupo'),
                    _buildTextField(nameEnCtrl, 'Nombre (EN)'),
                    _buildTextField(abbreviationCtrl, 'Abreviatura'),
                    _buildTextField(wqxCodeCtrl, 'Código WQX'),
                    _buildTextField(wmoCodeCtrl, 'Código WMO'),
                    _buildTextField(isoIeeeCodeCtrl, 'Código ISO/IEEE'),
                    _buildTextField(decimalsCtrl, 'Decimales', TextInputType.number),
                    _buildTextField(minValueCtrl, 'Valor Mínimo', TextInputType.number),
                    _buildTextField(maxValueCtrl, 'Valor Máximo', TextInputType.number),
                    SwitchListTile(
                      title: const Text('Permitir negativos'),
                      value: allowNegative,
                      onChanged: (bool value) {
                        setState(() {
                          allowNegative = value;
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
                  final newMagnitud = MagnitudSent(
                    unitId: selectedUnitId!,
                    groupName: groupNameCtrl.text,
                    nameEn: nameEnCtrl.text,
                    abbreviation: abbreviationCtrl.text,
                    wqxCode: wqxCodeCtrl.text,
                    wmoCode: wmoCodeCtrl.text,
                    isoIeeeCode: isoIeeeCodeCtrl.text,
                    decimals: int.parse(decimalsCtrl.text),
                    allowNegative: allowNegative,
                    minValue: double.parse(minValueCtrl.text),
                    maxValue: double.parse(maxValueCtrl.text),
                  );

                  await ApiService.createMagnitud(newMagnitud);
                  Navigator.pop(context);
                  _loadMagnitudes();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Magnitud creada con éxito')),
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
      [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
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
      appBar: AppBar(title: const Text('Gestión de Magnitudes')),
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
                onRefresh: _loadMagnitudes,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: magnitudes.length,
                  itemBuilder: (context, index) {
                    final magnitud = magnitudes[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[700],
                          child: const Icon(
                            Icons.straighten,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          magnitud.nameEn ?? 'Sin nombre',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(magnitud.abbreviation ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            try {
                              await ApiService.deleteMagnitud(
                                magnitud.id.toString(),
                              );
                              _loadMagnitudes();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Magnitud eliminada'),
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
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.add),
      ),
    );
  }
}
