class Sensor {
  final int? id;
  final String? name;
  final String? manufacturer;
  final String? model;
  final String? serialNumber;
  final String? sensorType;
  final DateTime? installedAt;
  final bool? active;
  final String? notes;

  Sensor({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.model,
    required this.serialNumber,
    required this.sensorType,
    required this.installedAt,
    required this.active,
    required this.notes,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'],
      name: json['name'],
      manufacturer: json['manufacturer'],
      model: json['model'],
      serialNumber: json['serial_number'],
      sensorType: json['sensor_type'],
      installedAt: DateTime.parse(json['installed_at']['date']),
      active: json['active'],
      notes: json['notes'],
    );
  }
}

/*{
        "id": 1,
        "name": "Water 7-in-1 Tester",
        "manufacturer": "Unknown",
        "model": "7-in-1 Bluetooth",
        "serial_number": "S/D - 123456789",
        "sensor_type": "multiparameter",
        "installed_at": {
            "date": "2025-10-16 01:00:00.781123",
            "timezone_type": 1,
            "timezone": "+00:00"
        },
        "active": true,
        "notes": "Measures pH, TDS, EC, ORP, Salinity, SG, Temp; Bluetooth app support; accuracy per product specs"
    }*/
