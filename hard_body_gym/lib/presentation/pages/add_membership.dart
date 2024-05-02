import 'package:flutter/material.dart';
import 'package:hard_body_gym/data/alert.dart';
import 'package:hard_body_gym/data/api.dart';
import 'package:hard_body_gym/data/extension.dart';
import 'package:hard_body_gym/presentation/provider/provider.dart';
import 'package:provider/provider.dart';

class AddMembershipPage extends StatefulWidget {
  const AddMembershipPage({super.key});
  static const String route = '/add-membership';

  @override
  State<AddMembershipPage> createState() => _AddMembershipPageState();
}

class _AddMembershipPageState extends State<AddMembershipPage> {
  final desc = TextEditingController();
  final price = TextEditingController();
  final start = TextEditingController();
  final end = TextEditingController();
  DateTime? currentStart;
  DateTime? currentEnd;
  final coinList = ['S/.', "\$"];
  late String coin = coinList.first;

  void _add() async {
    try {
      final service = Provider.of<DataService>(context, listen: false);
      final person = service.person;
      final user = service.user;
      if (start.text.isEmpty ||
          end.text.isEmpty ||
          desc.text.isEmpty ||
          price.text.isEmpty ||
          person == null ||
          currentStart == null ||
          currentEnd == null ||
          user == null) {
        return AlertHelper.show(
          context,
          title: 'Campos vacíos',
          content: 'Completa todos los campos obligatorios',
          buttonText: 'Aceptar',
        );
      }
      final resp = await ApiData.addMembership(
        currentStart!,
        currentEnd!,
        desc.text,
        double.tryParse(price.text) ?? 0,
        coin,
        person.idPerson,
        user.idPerson,
      );
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
    final data = Provider.of<DataService>(context, listen: false);
    final person = data.person;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir membresía'),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(person?.isMale == true ? Icons.man : Icons.woman),
                          const SizedBox(width: 8),
                          Expanded(child: Text(person?.fullName ?? '')),
                        ],
                      ),
                      if (person?.birthday != null) Text('FC: ${person?.birthday?.ddMMyy}'),
                      if (person?.email?.isNotEmpty == true) Text(person?.email ?? ''),
                      if (person?.roleName?.isNotEmpty == true) Text(person?.roleName ?? ''),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: desc,
                maxLength: 45,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Descripción',
                  label: Text('Descripción'),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: DropdownButtonFormField(
                      value: coin,
                      // isExpanded: true,
                      decoration: const InputDecoration(
                        hintText: 'Moneda',
                        label: Text('Moneda'),
                      ),
                      items: coinList
                          .map<DropdownMenuItem<String>>(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        coin = value;
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: price,
                      decoration: const InputDecoration(
                        hintText: 'Precio',
                        label: Text('Precio'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: start,
                      readOnly: true,
                      enabled: true,
                      onTap: () async {
                        final value = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          currentDate: currentStart,
                          initialDate: currentStart,
                        );
                        if (value == null) {
                          return;
                        }
                        start.text = value.yyMMdd;
                        currentStart = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Inicio',
                        label: Text('Inicio'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: end,
                      readOnly: true,
                      enabled: true,
                      onTap: () async {
                        final value = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          currentDate: currentEnd,
                          initialDate: currentEnd,
                        );
                        if (value == null) {
                          return;
                        }
                        end.text = value.yyMMdd;
                        currentEnd = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Fin',
                        label: Text('Fin'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
