class UserModel {
  final int? id;
  final String? email;
  final String? userName;
  final String? password;

  UserModel({this.id, this.email, this.userName, this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'userName': userName,
      'password': password,
    };
  }
}
