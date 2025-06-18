// class UserModel {
//   final int id;
//   final String name;
//   final String phone;
//   final String password;
//   final String role;
//   final List<String>? subjects; // المواد المرتبطة

//   UserModel({
//     required this.id,
//     required this.name,
//     required this.phone,
//     required this.password,
//     required this.role,
//     this.subjects,
//   });

//   UserModel copyWith({
//     int? id,
//     String? name,
//     String? phone,
//     String? password,
//     String? role,
//     List<String>? subjects,
//   }) {
//     return UserModel(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       phone: phone ?? this.phone,
//       password: password ?? this.password,
//       role: role ?? this.role,
//       subjects: subjects ?? this.subjects,
//     );
//   }

//   /// من JSON إلى UserModel
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'],
//       name: json['username'] ?? json['name'] ?? '',
//       phone: json['phone'] ?? '',
//       password: json['password'] ?? '',
//       role: json['role'] ?? '',
//       subjects: (json['subjects'] != null)
//           ? List<String>.from(json['subjects'])
//           : null,
//     );
//   }

//   /// من UserModel إلى JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'username': name,
//       'phone': phone,
//       'password': password,
//       'role': role,
//       'subjects': subjects,
//     };
//   }
// }



class UserModel {
  late final int? user_id;
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
      user_id: json['user_id'],
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
