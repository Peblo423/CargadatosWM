class MedicionSent {
  final int? sensorId;
  final int? locationId;
  final int? enteredBy;
  final int? sampledBy;
  final DateTime? sampledAt;
  final String? status;
  final String? source;
  final String? batchId;
  final String? comments;

  MedicionSent({
    required this.sensorId,
    required this.locationId,
    this.enteredBy,
    this.sampledBy,
    this.sampledAt,
    this.status,
    this.source,
    this.batchId,
    this.comments,
  });

  Map<String, dynamic> toJson() {
    return {
      'sensor_id': sensorId,
      'location_id': locationId,
      'entered_by': enteredBy,
      'sampled_by': sampledBy,
      'sampled_at': sampledAt?.toIso8601String(),
      'status': status,
      'source': source,
      'batch_id': batchId,
      'comments': comments,
    };
  }
  factory MedicionSent.fromJson(Map<String, dynamic> json) {
    return MedicionSent(
      sensorId: json['sensor_id'],
      locationId: json['location_id'],
      enteredBy: json['entered_by'],
      sampledBy: json['sampled_by'],
      sampledAt: DateTime.parse(json['sampled_at']['date']),
      status: json['status'],
      source: json['source'],
      batchId: json['batch_id'],
      comments: json['comments'],
    );
  }
}
