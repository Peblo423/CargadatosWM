class MagnitudSent {
  final int unitId;
  final String groupName;
  final String nameEn;
  final String abbreviation;
  final String wqxCode;
  final String wmoCode;
  final String isoIeeeCode;
  final int decimals;
  final bool allowNegative;
  final double minValue;
  final double maxValue;

  MagnitudSent({
    required this.unitId,
    required this.groupName,
    required this.nameEn,
    required this.abbreviation,
    required this.wqxCode,
    required this.wmoCode,
    required this.isoIeeeCode,
    required this.decimals,
    required this.allowNegative,
    required this.minValue,
    required this.maxValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'unit_id': unitId,
      'group_name': groupName,
      'name_en': nameEn,
      'abbreviation': abbreviation,
      'wqx_code': wqxCode,
      'wmo_code': wmoCode,
      'iso_ieee_code': isoIeeeCode,
      'decimals': decimals,
      'allow_negative': allowNegative,
      'min_value': minValue,
      'max_value': maxValue,
    };
  }
}

/*{
  "group_name": "Water",
  "name_en": "Electrical Conductivity",
  "abbreviation": "EC",
  "unit_id": 1,
  "wqx_code": "00095",
  "wmo_code": "EC001",
  "iso_ieee_code": "ISO-EC-01",
  "decimals": 2,
  "allow_negative": false,
  "min_value": 0.0,
  "max_value": 2000.0
}*/