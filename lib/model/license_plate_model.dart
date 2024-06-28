class LicensePlateModel {
  final int? id;
  final int? licensePlate;
  final String? createdAt;
  final int? provinceId;

  LicensePlateModel(
      {this.id, this.licensePlate, this.createdAt, this.provinceId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'licensePlate': licensePlate,
      'createdAt': createdAt,
      'provinceId': provinceId
    };
  }
}
