class UbicacionResponse {
  int? id;
  String? name;
  String? description;
  double? latDd;
  double? lonDd;
  double? altitudeM;
  String? address;
  bool? active;
  Map<String, dynamic>? createdAt;

  UbicacionResponse({
    this.id,
    this.name,
    this.description,
    this.latDd,
    this.lonDd,
    this.altitudeM,
    this.address,
    this.active,
    this.createdAt,
  });

  factory UbicacionResponse.fromJson(Map<String, dynamic> json) {
    return UbicacionResponse(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      latDd: json['lat_dd'] is String ? double.tryParse(json['lat_dd']) : json['lat_dd'],
      lonDd: json['lon_dd'] is String ? double.tryParse(json['lon_dd']) : json['lon_dd'],
      altitudeM: json['altitude_m'] is String ? double.tryParse(json['altitude_m']) : json['altitude_m'],
      address: json['address'],
      active: json['active'],
      createdAt: json['created_at'],
    );
  }
}
