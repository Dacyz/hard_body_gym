import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hard_body_gym/data/alert.dart';
import 'package:hard_body_gym/data/api.dart';
import 'package:hard_body_gym/data/extension.dart';

class AddPersonPage extends StatefulWidget {
  const AddPersonPage({super.key});
  static const String route = '/add-person';

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  final user = TextEditingController();
  final pass = TextEditingController();
  final mail = TextEditingController();
  final date = TextEditingController();
  DateTime? currentDate;
  final genderList = ['Masculino', 'Femenino'];
  String? gender;

  void _add() async {
    try {
      if (gender == null || user.text.isEmpty || pass.text.isEmpty) {
        return AlertHelper.show(
          context,
          title: 'Campos vacíos',
          content: 'Completa todos los campos obligatorios',
          buttonText: 'Aceptar',
        );
      }
      final resp = await ApiData.addPerson(user.text, pass.text, gender![0], currentDate, mail.text);
      if (!resp) {
        return AlertHelper.show(
          context,
          title: 'Error al registrar',
          content: 'Algunos de los valores fueron rechazados',
          buttonText: 'Atrás',
        );
      }
      Navigator.pop(context);
    } catch (e) {
      return AlertHelper.show(
        context,
        title: 'Error al registrar',
        content: '$e',
        buttonText: 'Atrás',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir persona'),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addPersonButton',
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: user,
                decoration: const InputDecoration(
                  hintText: 'Nombres',
                  label: Text('Nombres'),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: pass,
                decoration: const InputDecoration(
                  hintText: 'Apellidos',
                  label: Text('Apellidos'),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: mail,
                decoration: const InputDecoration(
                  hintText: 'Correo electrónico',
                  label: Text('Correo electrónico'),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                value: gender,
                isExpanded: true,
                decoration: const InputDecoration(
                  hintText: 'Genero',
                  label: Text('Genero'),
                ),
                items: genderList
                    .map<DropdownMenuItem<String>>(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  gender = value;
                  setState(() {});
                },
              ),
              const SizedBox(height: 8),
              TextField(
                controller: date,
                readOnly: true,
                enabled: true,
                onTap: () async {
                  final value = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    currentDate: currentDate,
                    initialDate: currentDate,
                  );
                  if (value == null) {
                    return;
                  }
                  date.text = value.yyMMdd;
                  currentDate = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Fecha de nacimiento',
                  label: Text('Fecha de nacimiento'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
