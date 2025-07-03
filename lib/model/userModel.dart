class UserModel {
  final int? user_id; // <-- التعديل هنا
  final String? username;
  final String? phone;
  final String? password;
  final String? role;

  UserModel({
    this.user_id,
    this.username,
    this.phone,
    this.password,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      user_id: json['user_id'] ?? json['id'], // ✅ هي الأهم
      username: json['username'],
      phone: json['phone'],
      password: json['password'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'username': username,
      'phone': phone,
      'password': password,
      'role': role,
    };
  }

    UserModel copyWith({
    int? user_id,
    String? username,
    String? phone,
    String? password,
    String? role,
  }) {
    return UserModel(
      user_id: user_id ?? this.user_id,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }
}
