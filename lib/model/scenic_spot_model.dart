class ScenicSpotModel {
  final int? id;
  final String? scenicSpot;
  final String? createdAt;
  final int? provinceId;

  ScenicSpotModel({this.id, this.scenicSpot, this.createdAt, this.provinceId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'scenicSpot': scenicSpot,
      'createdAt': createdAt,
      'provinceId': provinceId
    };
  }
}
