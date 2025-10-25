class SensorResponse {
  int? id;
  String? name;
  String? manufacturer;
  String? model;
  String? serialNumber;
  String? sensorType;
  Map<String, dynamic>? installedAt;
  bool? active;
  String? notes;

  SensorResponse({
    this.id,
    this.name,
    this.manufacturer,
    this.model,
    this.serialNumber,
    this.sensorType,
    this.installedAt,
    this.active,
    this.notes,
  });

  factory SensorResponse.fromJson(Map<String, dynamic> json) {
    return SensorResponse(
      id: json['id'],
      name: json['name'],
      manufacturer: json['manufacturer'],
      model: json['model'],
      serialNumber: json['serial_number'],
      sensorType: json['sensor_type'],
      installedAt: json['installed_at'],
      active: json['active'],
      notes: json['notes'],
    );
  }
}