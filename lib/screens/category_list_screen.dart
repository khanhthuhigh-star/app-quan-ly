import 'package:flutter/material.dart';

import '../data/app_database.dart';
import '../models/category_item.dart';
import '../models/transaction_type.dart';
import '../widgets/thumbnail.dart';
import 'category_form_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});
  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Danh mục')),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CategoryFormScreen()));
            setState(() {});
          },
          icon: const Icon(Icons.add),
          label: const Text('Danh mục'),
        ),
        body: FutureBuilder<List<CategoryItem>>(
          future: AppDatabase.instance.categories(),
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final items = snapshot.data!;
            return ListView(children: [
              for (final type in TransactionType.values) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
                  child: Text('Khoản ${type.label.toLowerCase()}',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                ...items
                    .where((item) => item.type == type)
                    .map((category) => ListTile(
                          leading: Thumbnail(
                              path: category.imagePath,
                              icon: Icons.category,
                              color: type.color),
                          title: Text(category.name),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        CategoryFormScreen(editing: category)));
                            setState(() {});
                          },
                        )),
              ],
            ]);
          },
        ),
      );
}
