class UserModel {
  final String? id;
  final String username;
  final String email;
  final String password;
  final String? profileImageBase64;

  const UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.profileImageBase64,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "password": password,
      if (profileImageBase64 != null) "profileImageBase64": profileImageBase64,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      username: json["username"],
      email: json["email"],
      password: json["password"],
      profileImageBase64: json["profileImageBase64"],
    );
  }
}
