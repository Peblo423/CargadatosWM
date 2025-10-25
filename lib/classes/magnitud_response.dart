class MagnitudResponse {
  int? id;
  String? groupName;
  String? nameEn;
  String? abbreviation;
  String? wqxCode;
  String? wmoCode;
  String? isoIeeeCode;
  int? decimals;
  bool? allowNegative;
  String? minValue;
  String? maxValue;

  MagnitudResponse({
    this.id,
    this.groupName,
    this.nameEn,
    this.abbreviation,
    this.wqxCode,
    this.wmoCode,
    this.isoIeeeCode,
    this.decimals,
    this.allowNegative,
    this.minValue,
    this.maxValue,
  });
  factory MagnitudResponse.fromJson(Map<String, dynamic> json) {
    return MagnitudResponse(
      id: json['id'],
      groupName: json['group_name'],
      nameEn: json['name_en'],
      abbreviation: json['abbreviation'],
      wqxCode: json['wqx_code'],
      wmoCode: json['wmo_code'],
      isoIeeeCode: json['iso_ieee_code'],
      decimals: json['decimals'],
      allowNegative: json['allow_negative'],
      minValue: (json['min_value']),
      maxValue: (json['max_value']),
    );
  }
}
/*{
        "id": 1;
        "group_name": "Water";
        "name_en": "Water Temperature";
        "abbreviation": "WT";
        "wqx_code": "00010";
        "wmo_code": null;
        "iso_ieee_code": null;
        "decimals": 1;
        "allow_negative": true;
        "min_value": null;
        "max_value": null
    };*/