class UnidadResponse {
  int? id;
  String? ucumCode;
  String? uncefactCode;
  String? display;

  UnidadResponse({
    this.id,
    this.ucumCode,
    this.uncefactCode,
    this.display,
  });

  factory UnidadResponse.fromJson(Map<String, dynamic> json) {
    return UnidadResponse(
      id: json['id'],
      ucumCode: json['ucum_code'],
      uncefactCode: json['uncefact_code'],
      display: json['display'],
    );
  }
}
