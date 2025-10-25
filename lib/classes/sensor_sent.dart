class SensorSent {
  final String name;
  final String? manufacturer;
  final String? model;
  final String? serialNumber;
  final String? sensorType;
  final String? installedAt;
  final bool active;
  final String? notes;

  SensorSent({
    required this.name,
    this.manufacturer,
    this.model,
    this.serialNumber,
    this.sensorType,
    this.installedAt,
    required this.active,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'manufacturer': manufacturer,
      'model': model,
      'serial_number': serialNumber,
      'sensor_type': sensorType,
      'installed_at': installedAt,
      'active': active,
      'notes': notes,
    };
  }
}
