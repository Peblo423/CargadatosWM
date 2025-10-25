class MedicionResponse {
  final int id;
  final int sensor;
  final int location;
  final int enteredBy;
  final int sampledBy;
  final DateTime registeredAt;
  final DateTime sampledAt;
  final String status;
  final String source;
  final String? batchId;
  final String comments;

  MedicionResponse({
    required this.id,
    required this.sensor,
    required this.location,
    required this.enteredBy,
    required this.sampledBy,
    required this.registeredAt,
    required this.sampledAt,
    required this.status,
    required this.source,
    this.batchId,
    required this.comments,
  });

  factory MedicionResponse.fromJson(Map<String, dynamic> json) {
    return MedicionResponse(
      id: json['id'],
      sensor: json['sensor'],
      location: json['location'],
      enteredBy: json['entered_by'],
      sampledBy: json['sampled_by'],
      registeredAt: DateTime.parse(json['registered_at']['date']),
      sampledAt: DateTime.parse(json['sampled_at']['date']),
      status: json['status'],
      source: json['source'],
      batchId: json['batch_id'],
      comments: json['comments'],
    );
  }
}

/*{
        "id": 1,
        "sensor": 1,
        "location": 4,
        "entered_by": 1,
        "sampled_by": 2,
        "registered_at": {
            "date": "2025-10-16 01:00:00.812586",
            "timezone_type": 1,
            "timezone": "+00:00"
        },
        "sampled_at": {
            "date": "2025-10-16 00:55:00.812586",
            "timezone_type": 1,
            "timezone": "+00:00"
        },
        "status": "received",
        "source": "device",
        "batch_id": null,
        "comments": "Muestra 7-en-1 en COCINA"
    }, */