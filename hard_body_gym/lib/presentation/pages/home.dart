import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hard_body_gym/data/api.dart';
import 'package:hard_body_gym/data/extension.dart';
import 'package:hard_body_gym/models/person.dart';
import 'package:hard_body_gym/presentation/pages/add_person.dart';
import 'package:hard_body_gym/presentation/pages/detail_person.dart';
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

  void reChargeList() {
    final service = Provider.of<DataService>(context, listen: false);
    _future = ApiData.getPersons()..then((value) => service.persons = value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<DataService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hard Body Gym'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Image.asset(
              'assets/image/logo.png',
              width: 32,
            ),
          ),
        ],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'homeButton',
        onPressed: () async {
          await AddPersonPage.show(context);
          init();
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bienvenido, ${service.user?.fullName}'),
            const SizedBox(height: 16),
            TextField(
              controller: search,
              decoration: const InputDecoration(
                hintText: 'Buscar',
                label: Text('Buscar'),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Person>>(
                future: _future,
                builder: (_, data) {
                  if (data.connectionState == ConnectionState.waiting) {
                    if (service.persons.isNotEmpty) {
                      return _buildList(service.persons);
                    }
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (data.hasError) {
                    return Center(child: Text('${data.error}'));
                  }
                  return _buildList(data.data ?? []);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Person> data) {
    final service = Provider.of<DataService>(context, listen: false);
    return MasonryGridView.builder(
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return GestureDetector(
          onTap: () {
            service.person = item;
            Navigator.pushNamed(context, DetailPersonPage.route);
          },
          child: Card(
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                if (item.urlPhoto.isNotEmpty)
                  AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      item.urlPhoto,
                      fit: BoxFit.cover,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${item.isMale ? '♂' : '♀'} ${item.fullName}'),
                      if (item.birthday != null) Text('FC: ${item.birthday?.ddMMyy}'),
                      if (item.email?.isNotEmpty == true) Text(item.email ?? ''),
                      if (item.roleName?.isNotEmpty == true) Text(item.roleName ?? ''),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
