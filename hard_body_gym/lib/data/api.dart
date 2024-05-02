import 'dart:convert';
import 'package:hard_body_gym/data/const.dart';
import 'package:hard_body_gym/data/extension.dart';
import 'package:hard_body_gym/models/membership.dart';
import 'package:hard_body_gym/models/person.dart';
import 'package:hard_body_gym/models/user.dart';
import 'package:http/http.dart' as http;

class ApiData {
  static Future<User?> login(
    String user,
    String password,
  ) async {
    final data = {
      "user": user,
      "password": password,
    };
    final uri = Uri.parse('${Constants.host}/auth/login.php');
    final resp = await http
        .post(uri, body: jsonEncode(data), headers: Constants.headers)
        .timeout(const Duration(seconds: Constants.timeOutSeconds));
    if (resp.statusCode == 200) {
      final user = json.decode(resp.body);
      if (user['success'] != true) {
        throw user['message'] ?? 'Error al iniciar sesión';
      }
      return User.fromJson(user['user']);
    }
    return null;
  }

  static Future<bool> addPerson(
    String firstName,
    String lastName,
    String gender,
    DateTime? birthday,
    String? email,
  ) async {
    final data = {
      "firstName": firstName,
      "lastName": lastName,
      "birthday": birthday?.yyMMdd,
      "email": email?.isEmpty != false ? null : email,
      "gender": gender,
    };
    final uri = Uri.parse('${Constants.host}/data/add_person.php');
    final resp = await http
        .post(uri, body: jsonEncode(data), headers: Constants.headers)
        .timeout(const Duration(seconds: Constants.timeOutSeconds));
    if (resp.statusCode == 200) {
      final decoded = json.decode(resp.body);
      if (decoded['success'] != true) {
        throw decoded['message'] ?? 'Error al registrar';
      }
      return true;
    }
    return false;
  }

  static Future<List<Person>> getPersons() async {
    final uri = Uri.parse('${Constants.host}/data/get_person.php');
    final resp =
        await http.get(uri, headers: Constants.headers).timeout(const Duration(seconds: Constants.timeOutSeconds));
    if (resp.statusCode == 200) {
      final decoded = json.decode(resp.body);
      print(decoded);
      if (decoded['success'] != true) {
        throw decoded['message'] ?? 'Error al obtener personas';
      }
      return (decoded['personas'] as List).map((e) => Person.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<Membership>> getMembership({required final int? idPerson}) async {
    final uri = Uri.parse('${Constants.host}/data/get_membership.php?person=$idPerson');
    final resp =
        await http.get(uri, headers: Constants.headers).timeout(const Duration(seconds: Constants.timeOutSeconds));
    if (resp.statusCode == 200) {
      final decoded = json.decode(resp.body);
      print(decoded);
      if (decoded['success'] != true) {
        throw decoded['message'] ?? 'Error al obtener personas';
      }
      return (decoded['memberships'] as List).map((e) => Membership.fromJson(e)).toList();
    }
    return [];
  }

  static Future<bool> addMembership(
    DateTime start,
    DateTime end,
    String? description,
    double price,
    String coin,
    int idPerson,
    int registerBy,
  ) async {
    final data = {
      "start": start.yyMMdd,
      "end": end.yyMMdd,
      "description": description?.isNotEmpty == false ? null : description,
      "price": price,
      "coin": coin,
      "id_person": idPerson,
      "register_by": registerBy,
    };
    final uri = Uri.parse('${Constants.host}/data/add_membership.php');
    final resp = await http
        .post(uri, body: jsonEncode(data), headers: Constants.headers)
        .timeout(const Duration(seconds: Constants.timeOutSeconds));
    if (resp.statusCode == 200) {
      final decoded = json.decode(resp.body);
      if (decoded['success'] != true) {
        throw decoded['message'] ?? 'Error al registrar';
      }
      return true;
    }
    return false;
  }
}
