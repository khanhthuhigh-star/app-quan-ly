import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/app_database.dart';
import '../data/image_store.dart';
import '../models/category_item.dart';
import '../models/transaction_type.dart';
import '../widgets/dialogs.dart';
import '../widgets/image_field.dart';

class CategoryFormScreen extends StatefulWidget {
  const CategoryFormScreen({super.key, this.editing});
  final CategoryItem? editing;
  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _form = GlobalKey<FormState>();
  late TransactionType _type;
  late TextEditingController _name;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _type = widget.editing?.type ?? TransactionType.expense;
    _name = TextEditingController(text: widget.editing?.name ?? '');
    _imagePath = widget.editing?.imagePath;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title:
              Text(widget.editing == null ? 'Thêm danh mục' : 'Sửa danh mục'),
          actions: widget.editing == null
              ? null
              : [
                  IconButton(
                      onPressed: _delete,
                      icon: const Icon(Icons.delete_outline))
                ],
        ),
        body: Form(
          key: _form,
          child: ListView(padding: const EdgeInsets.all(16), children: [
            SegmentedButton<TransactionType>(
              segments: const [
                ButtonSegment(
                    value: TransactionType.expense, label: Text('Chi')),
                ButtonSegment(
                    value: TransactionType.income, label: Text('Thu')),
              ],
              selected: {_type},
              onSelectionChanged: (value) =>
                  setState(() => _type = value.first),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Tên danh mục'),
              validator: (value) =>
                  (value ?? '').trim().isEmpty ? 'Nhập tên danh mục' : null,
            ),
            const SizedBox(height: 16),
            ImageField(
                path: _imagePath,
                onPick: _pickImage,
                onRemove: () => setState(() => _imagePath = null)),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('Lưu danh mục')),
          ]),
        ),
      );

  Future<void> _pickImage() async {
    final ImageSource? source = await chooseImageSource(context);
    if (source == null) return;
    final path = await ImageStore.pickAndCopy(source);
    if (path != null && mounted) setState(() => _imagePath = path);
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    await AppDatabase.instance.saveCategory(CategoryItem(
      id: widget.editing?.id,
      name: _name.text.trim(),
      type: _type,
      imagePath: _imagePath,
    ));
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    if (!await askConfirmation(context, 'Xóa danh mục này?')) return;
    try {
      await AppDatabase.instance.deleteCategory(widget.editing!.id!);
      if (mounted) Navigator.pop(context);
    } on StateError catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }
}
