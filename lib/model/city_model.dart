class CityModel {
  final int? id;
  final String? city;
  final String? createdAt;
  final int? provinceId;

  CityModel({this.id, this.city, this.createdAt, this.provinceId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city': city,
      'createdAt': createdAt,
      'provinceId': provinceId
    };
  }
}
