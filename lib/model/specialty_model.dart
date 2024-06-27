class SpecialtyModel {
  final int? id;
  final String? specialty;
  final String? createdAt;
  final int? provinceId;

  SpecialtyModel({this.id, this.specialty, this.createdAt, this.provinceId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'specialty': specialty,
      'createdAt': createdAt,
      'provinceId': provinceId
    };
  }
}
