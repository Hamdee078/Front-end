class UserModel {
  final String id;
  final String userName;
  final String name;
  final String role;

  UserModel({
    required this.id,
    required this.userName,
    required this.name,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      userName: json['userName'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userName': userName,
      'name': name,
      'role': role,
    };
  }
}
