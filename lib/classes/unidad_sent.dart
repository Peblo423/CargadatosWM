class UnidadSent {
  final String ucumCode;
  final String? uncefactCode;
  final String display;

  UnidadSent({
    required this.ucumCode,
    this.uncefactCode,
    required this.display,
  });

  Map<String, dynamic> toJson() {
    return {
      'ucum_code': ucumCode,
      'uncefact_code': uncefactCode,
      'display': display,
    };
  }
}
