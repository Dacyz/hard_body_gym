import 'package:hard_body_gym/data/extension.dart';

class Membership {
  Membership({
    required this.idMembership,
    required this.start,
    required this.end,
    required this.description,
    required this.price,
    required this.coin,
    required this.registerAt,
    required this.idPerson,
    required this.status,
    required this.registerBy,
  });

  final int idMembership;
  final DateTime start;
  final DateTime end;
  final String description;
  final String price;
  final String coin;
  final DateTime? registerAt;
  final int idPerson;
  final String status;
  final int registerBy;

  String get date => start.year == end.year ? "${start.ddMM} - ${end.ddMM}" : "${start.ddMMyy} - ${end.ddMMyy}";

  Membership copyWith({
    int? idMembership,
    DateTime? start,
    DateTime? end,
    String? description,
    String? price,
    String? coin,
    DateTime? registerAt,
    int? idPerson,
    String? status,
    int? registerBy,
  }) {
    return Membership(
      idMembership: idMembership ?? this.idMembership,
      start: start ?? this.start,
      end: end ?? this.end,
      description: description ?? this.description,
      price: price ?? this.price,
      coin: coin ?? this.coin,
      registerAt: registerAt ?? this.registerAt,
      idPerson: idPerson ?? this.idPerson,
      status: status ?? this.status,
      registerBy: registerBy ?? this.registerBy,
    );
  }

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      idMembership: json["id_membership"] ?? 0,
      start: DateTime.tryParse(json["start"] ?? "") ?? DateTime.now(),
      end: DateTime.tryParse(json["end"] ?? "") ?? DateTime.now(),
      description: json["description"] ?? "",
      price: json["price"] ?? "",
      coin: json["coin"] ?? "",
      registerAt: DateTime.tryParse(json["register_at"] ?? ""),
      idPerson: json["id_person"] ?? 0,
      status: json["status"] ?? "",
      registerBy: json["register_by"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id_membership": idMembership,
        "start": start.yyMMdd,
        "end": end.yyMMdd,
        "description": description,
        "price": price,
        "coin": coin,
        "register_at": registerAt?.toIso8601String(),
        "id_person": idPerson,
        "status": status,
        "register_by": registerBy,
      };

  @override
  String toString() {
    return "$idMembership, $start, $end, $description, $price, $coin, $registerAt, $idPerson, $status, $registerBy, ";
  }
}
