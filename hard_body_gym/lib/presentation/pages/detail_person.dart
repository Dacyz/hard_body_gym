import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
  Future<List<Membership>>? _future;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(init);
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
    final person = data.person!;
    return Scaffold(
      appBar: AppBar(
        title: Text(person.fullName),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'homeButton',
        onPressed: () async {
          await AddMembershipPage.show(context);
          init();
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (person.urlPhoto.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AspectRatio(
                    aspectRatio: 1.2,
                    child: Image.network(
                      person.urlPhoto,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            Text('${person.isMale ? '♂' : '♀'} ${person.fullName}'),
            if (person.birthday != null) Text('FC: ${person.birthday?.ddMMyy}'),
            if (person.email?.isNotEmpty == true) Text(person.email ?? ''),
            if (person.roleName?.isNotEmpty == true) Text(person.roleName ?? ''),
            const Text('Listado de membresías'),
            const SizedBox(height: 16),
            FutureBuilder(
              future: _future,
              builder: (_, data) {
                if (data.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (data.hasError) {
                  return SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: Center(
                      child: Text('${data.error}'),
                    ),
                  );
                }
                return MasonryGridView.builder(
                  gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemCount: data.data?.length ?? 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                                const SizedBox(width: 2),
                                Expanded(child: Text('Periodo: ${item.start.ddMMyy} - ${item.end.ddMMyy}'),),
                              ],
                            ),
                            Text(item.description),
                            Row(
                              children: [
                                item.coin == 'S' ? const Flexible(child: Text('S/.')) : const Icon(Icons.attach_money),
                                const SizedBox(width: 8),
                                Expanded(child: Text(item.price)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
