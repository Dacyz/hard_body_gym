import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hard_body_gym/data/api.dart';
import 'package:hard_body_gym/data/extension.dart';
import 'package:hard_body_gym/models/person.dart';
import 'package:hard_body_gym/presentation/pages/add_person.dart';
import 'package:hard_body_gym/presentation/provider/provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String route = '/Home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final search = TextEditingController();
  Future<List<Person>>? _future;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(init);
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  void init([dynamic timeStamp]) {
    reChargeList();
  }

  void reChargeList() async {
    _future = ApiData.getPersons();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hard Body Gym'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'homeButton',
        onPressed: () async {
          await Navigator.pushNamed(context, AddPersonPage.route);
          init();
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bienvenido, ${data.user?.fullName}'),
            const SizedBox(height: 16),
            const Text('Menbresias por vencer'),
            const SizedBox(height: 16),
            const Text('Listado de miembros'),
            TextField(
              controller: search,
              decoration: const InputDecoration(
                hintText: 'Buscar',
                label: Text('Buscar'),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              width: double.infinity,
              child: FutureBuilder(
                future: _future,
                builder: (_, data) {
                  if (data.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (data.hasError) {
                    return const Center(child: Text('Error'));
                  }
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemCount: data.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = data.data![index];
                      return Card(
                        color: item.isMale ? null : const Color(0xFFFFE0EE),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(item.isMale ? Icons.man : Icons.woman),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(item.fullName)),
                                ],
                              ),
                              if (item.birthday != null) Text('FC: ${item.birthday?.ddMMyy}'),
                              if (item.email?.isNotEmpty == true) Text(item.email ?? ''),
                              if (item.roleName?.isNotEmpty == true) Text(item.roleName ?? ''),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
