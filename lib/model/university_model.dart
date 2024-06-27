class UniversityModel {
  final int? id;
  final String? university;
  final String? createdAt;
  final int? provinceId;

  UniversityModel({this.id, this.university, this.createdAt, this.provinceId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'university': university,
      'createdAt': createdAt,
      'provinceId': provinceId
    };
  }
}
