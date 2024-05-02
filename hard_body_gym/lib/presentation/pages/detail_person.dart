import 'package:flutter/material.dart';
import 'package:hard_body_gym/data/api.dart';
import 'package:hard_body_gym/data/extension.dart';
import 'package:hard_body_gym/models/membership.dart';
import 'package:hard_body_gym/presentation/pages/add_membership.dart';
import 'package:hard_body_gym/presentation/provider/provider.dart';
import 'package:provider/provider.dart';

class DetailPersonPage extends StatefulWidget {
  const DetailPersonPage({super.key});
  static const String route = '/detail_person';

  @override
  State<DetailPersonPage> createState() => _DetailPersonPageState();
}

class _DetailPersonPageState extends State<DetailPersonPage> {
  final search = TextEditingController();
  Future<List<Membership>>? _future;

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
    final data = Provider.of<DataService>(context, listen: false);
    _future = ApiData.getMembership(idPerson: data.person?.idPerson);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataService>(context, listen: false);
    final person = data.person;
    return Scaffold(
      appBar: AppBar(
        title: Text(person?.fullName ?? 'Hard body gym'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'homeButton',
        onPressed: () async {
          await Navigator.pushNamed(context, AddMembershipPage.route);
          init();
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Listado de membresías'),
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
                    return Center(child: Text('${data.error}'));
                  }
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemCount: data.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = data.data![index];
                      return Card(
                        color: item.status == 'A' ? null : const Color(0xFFFFE0EE),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(item.status == 'A' ? Icons.golf_course_sharp : Icons.no_backpack_outlined),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(item.description)),
                                ],
                              ),
                              Text('Periodo: ${item.start.ddMMyy} - ${item.end.ddMMyy}'),
                              Row(
                                children: [
                                  item.coin == 'S' ? const Flexible(child: Text('S/.')) : const Icon(Icons.attach_money),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(item.price)),
                                ],
                              ),
                              TextButton(
                                onPressed: () => false,
                                child: const Text('Editar'),
                              )
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
