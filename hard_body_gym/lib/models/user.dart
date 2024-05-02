import 'package:hard_body_gym/models/person.dart';

class User extends Person {
  User({
    required super.idPerson,
    required super.firstName,
    required super.lastName,
    required super.birthday,
    required super.registerAt,
    required super.email,
    required super.gender,
    required super.status,
    required this.idRole,
    required super.roleName,
    required this.roleDescription,
    required this.roleStatus,
    required this.idUser,
    required this.user,
    required this.userRegisterAt,
  });

  final int? idRole;
  final String? roleDescription;
  final bool? roleStatus;
  final int? idUser;
  final String? user;
  final DateTime? userRegisterAt;

  User copy({
    int? idPerson,
    String? firstName,
    String? lastName,
    DateTime? birthday,
    DateTime? registerAt,
    String? email,
    int? idRole,
    String? roleName,
    String? roleDescription,
    bool? roleStatus,
    int? idUser,
    String? user,
    DateTime? userRegisterAt,
    String? gender,
    bool? status,
  }) {
    return User(
      idPerson: idPerson ?? this.idPerson,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthday: birthday ?? this.birthday,
      registerAt: registerAt ?? this.registerAt,
      email: email ?? this.email,
      idRole: idRole ?? this.idRole,
      roleName: roleName ?? this.roleName,
      roleDescription: roleDescription ?? this.roleDescription,
      roleStatus: roleStatus ?? this.roleStatus,
      idUser: idUser ?? this.idUser,
      user: user ?? this.user,
      userRegisterAt: userRegisterAt ?? this.userRegisterAt,
      gender: gender ?? this.gender,
      status: status ?? this.status,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idPerson: json["id_person"] ?? 0,
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      birthday: DateTime.tryParse(json["birthday"] ?? ""),
      registerAt: DateTime.tryParse(json["register_at"] ?? ""),
      email: json["email"] ?? "",
      idRole: json["id_role"] ?? 0,
      roleName: json["role_name"],
      roleDescription: json["role_description"],
      roleStatus: json["role_status"] ?? 0,
      idUser: json["id_user"] ?? 0,
      user: json["user"] ?? "",
      userRegisterAt: DateTime.tryParse(json["user_register_at"] ?? ""),
      gender: json["gender"] ?? "M",
      status: json["status"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "id_person": idPerson,
        "first_name": firstName,
        "last_name": lastName,
        "birthday": birthday,
        "register_at": registerAt?.toIso8601String(),
        "email": email,
        "id_role": idRole,
        "role_name": roleName,
        "role_description": roleDescription,
        "role_status": roleStatus,
        "id_user": idUser,
        "user": user,
        "user_register_at": userRegisterAt?.toIso8601String(),
      };

  @override
  String toString() {
    return "$idPerson, $firstName, $lastName, $birthday, $registerAt, $email, $idRole, $roleName, $roleDescription, $roleStatus, $idUser, $user, $userRegisterAt, ";
  }
}
