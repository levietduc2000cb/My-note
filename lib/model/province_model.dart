class ProvinceModel {
  final int? id;
  final String? provinceName;
  final int? userId;
  final String? createdAt;

  ProvinceModel({
    this.id,
    this.provinceName,
    this.userId,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'provinceName': provinceName, 'createdAt': createdAt};
  }

  Map<String, dynamic> toMapHasUserId() {
    return {
      'id': id,
      'provinceName': provinceName,
      'userId': userId,
      'createdAt': createdAt
    };
  }
}
