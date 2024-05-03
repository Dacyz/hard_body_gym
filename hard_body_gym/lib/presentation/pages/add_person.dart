import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hard_body_gym/data/alert.dart';
import 'package:hard_body_gym/data/api.dart';
import 'package:hard_body_gym/data/extension.dart';
import 'package:hard_body_gym/presentation/provider/provider.dart';
import 'package:provider/provider.dart';

class AddPersonPage extends StatefulWidget {
  const AddPersonPage({super.key});

  static show(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const AddPersonPage();
      },
    );
  }

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
  String image = '';

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
      String? urlPhoto;
      if (image.isNotEmpty) {
        final service = Provider.of<DataService>(context, listen: false);
        urlPhoto = await service.uploadImage(File(image));
      }
      final resp = await ApiData.addPerson(user.text, pass.text, gender![0], currentDate, mail.text, urlPhoto);
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
    final service = Provider.of<DataService>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Añadir persona'),
          const SizedBox(height: 24),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: Colors.white,
                  border: Border.all(color: Colors.black, width: 1),
                  image: image.isEmpty
                      ? null
                      : DecorationImage(
                          image: FileImage(File(image)),
                          fit: BoxFit.cover,
                        ),
                ),
                child: image.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 48,
                      )
                    : null,
              ),
              if (image.isEmpty) ...[
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: IconButton.filled(
                    onPressed: () async {
                      final value = await service.pickImage();
                      if (value == null) return;
                      image = value.path;
                      setState(() {});
                    },
                    color: Colors.black,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      elevation: const MaterialStatePropertyAll(8),
                    ),
                    icon: const Icon(Icons.image),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton.filled(
                    onPressed: () async {
                      final value = await service.pickPhoto();
                      if (value == null) return;
                      image = value.path;
                      setState(() {});
                    },
                    color: Colors.black,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      elevation: const MaterialStatePropertyAll(8),
                    ),
                    icon: const Icon(Icons.camera_alt),
                  ),
                ),
              ],
              if (image.isNotEmpty)
                Positioned(
                  top: -5,
                  right: -5,
                  child: IconButton.filled(
                    onPressed: () async {
                      image = '';
                      setState(() {});
                    },
                    color: Colors.black,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      elevation: const MaterialStatePropertyAll(8),
                    ),
                    icon: const Icon(Icons.close),
                  ),
                ),
            ],
          ),
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
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField(
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
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
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
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _add,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
