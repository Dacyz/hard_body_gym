import 'package:flutter/material.dart';
import 'package:hard_body_gym/data/alert.dart';
import 'package:hard_body_gym/data/api.dart';
import 'package:hard_body_gym/data/extension.dart';
import 'package:hard_body_gym/presentation/provider/provider.dart';
import 'package:provider/provider.dart';

class AddMembershipPage extends StatefulWidget {
  const AddMembershipPage({super.key});

  static show(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const AddMembershipPage();
      },
    );
  }

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
          const Text('Añadir membresía'),
          TextField(
            controller: desc,
            maxLength: 45,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.top,
            maxLines: 3,
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
