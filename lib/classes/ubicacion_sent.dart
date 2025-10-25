class UbicacionSent {
  final String name;
  final String? description;
  final double? latitude;
  final double? longitude;
  final double? altitude;
  final String? address;

  UbicacionSent({
    required this.name,
    this.description,
    this.latitude,
    this.longitude,
    this.altitude,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'address': address,
    };
  }
}
