import 'package:hard_body_gym/data/extension.dart';

class Person {
  Person({
    required this.idPerson,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.registerAt,
    required this.email,
    required this.gender,
    required this.status,
    required this.roleName,
  });

  final int idPerson;
  final String firstName;
  final String lastName;
  final DateTime? birthday;
  final DateTime? registerAt;
  final String? email;
  final String gender;
  final bool status;
  final String? roleName;

  String get fullName => '$firstName $lastName';
  bool get isMale => gender == 'M';

  Person copyWith({
    int? idPerson,
    String? firstName,
    String? lastName,
    DateTime? birthday,
    DateTime? registerAt,
    String? email,
    String? gender,
    bool? status,
    String? roleName,
  }) {
    return Person(
      idPerson: idPerson ?? this.idPerson,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthday: birthday ?? this.birthday,
      registerAt: registerAt ?? this.registerAt,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      roleName: roleName ?? this.roleName,
    );
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      idPerson: json["id_person"] ?? 0,
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      birthday: DateTime.tryParse(json["birthday"] ?? ""),
      registerAt: DateTime.tryParse(json["register_at"] ?? ""),
      email: json["email"] ?? "",
      gender: json["gender"] ?? "",
      status: json["status"] ?? false,
      roleName: json["role_name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id_person": idPerson,
        "first_name": firstName,
        "last_name": lastName,
        "birthday": birthday?.yyMMdd,
        "register_at": registerAt?.toIso8601String(),
        "email": email,
        "gender": gender,
        "status": status,
        "role_name": roleName,
      };

  @override
  String toString() {
    return "$idPerson, $firstName, $lastName, $birthday, $registerAt, $email, $gender, $status, $roleName, ";
  }
}