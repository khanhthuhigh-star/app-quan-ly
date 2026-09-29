import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../data/app_database.dart';
import '../data/image_store.dart';
import '../models/category_item.dart';
import '../models/expense_transaction.dart';
import '../models/transaction_type.dart';
import '../widgets/dialogs.dart';
import '../widgets/image_field.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key, this.editing});
  final ExpenseTransaction? editing;
  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _form = GlobalKey<FormState>();
  late TransactionType _type;
  int? _categoryId;
  late TextEditingController _amount;
  late TextEditingController _note;
  late DateTime _date;
  String? _imagePath;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final item = widget.editing;
    _type = item?.type ?? TransactionType.expense;
    _categoryId = item?.categoryId;
    _amount = TextEditingController(text: item?.amount.toString() ?? '');
    _note = TextEditingController(text: item?.note ?? '');
    _date = item?.occurredAt ?? DateTime.now();
    _imagePath = item?.imagePath;
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title:
              Text(widget.editing == null ? 'Thêm giao dịch' : 'Sửa giao dịch'),
          actions: widget.editing == null
              ? null
              : [
                  IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: _delete),
                ],
        ),
        body: FutureBuilder<List<CategoryItem>>(
          future: AppDatabase.instance.categories(_type),
          builder: (_, snapshot) {
            final categories = snapshot.data ?? [];
            if (_categoryId != null &&
                categories.every((item) => item.id != _categoryId)) {
              _categoryId = null;
            }
            return Form(
              key: _form,
              child: ListView(padding: const EdgeInsets.all(16), children: [
                SegmentedButton<TransactionType>(
                  segments: const [
                    ButtonSegment(
                        value: TransactionType.expense,
                        label: Text('Chi'),
                        icon: Icon(Icons.north_east)),
                    ButtonSegment(
                        value: TransactionType.income,
                        label: Text('Thu'),
                        icon: Icon(Icons.south_west)),
                  ],
                  selected: {_type},
                  onSelectionChanged: (value) => setState(() {
                    _type = value.first;
                    _categoryId = null;
                  }),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amount,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Số tiền', prefixText: '₫ '),
                  validator: (value) => int.tryParse((value ?? '')
                              .replaceAll(RegExp(r'[^0-9]'), '')) ==
                          null
                      ? 'Nhập số tiền hợp lệ'
                      : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  initialValue: _categoryId,
                  decoration: const InputDecoration(labelText: 'Danh mục'),
                  items: categories
                      .map((item) => DropdownMenuItem(
                          value: item.id, child: Text(item.name)))
                      .toList(),
                  onChanged: (value) => setState(() => _categoryId = value),
                  validator: (value) => value == null ? 'Chọn danh mục' : null,
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.outline)),
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Ngày giao dịch'),
                  subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(_date)),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 16),
                TextFormField(
                    controller: _note,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        labelText: 'Ghi chú (không bắt buộc)')),
                const SizedBox(height: 16),
                ImageField(
                    path: _imagePath,
                    onPick: _pickImage,
                    onRemove: () => setState(() => _imagePath = null)),
                const SizedBox(height: 24),
                FilledButton(
                    onPressed: _saving ? null : _save,
                    child: Text(_saving ? 'Đang lưu...' : 'Lưu giao dịch')),
              ]),
            );
          },
        ),
      );

  Future<void> _pickDate() async {
    final date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (date == null || !mounted) return;
    final time = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(_date));
    if (time != null) {
      setState(() => _date =
          DateTime(date.year, date.month, date.day, time.hour, time.minute));
    }
  }

  Future<void> _pickImage() async {
    final ImageSource? source = await chooseImageSource(context);
    if (source == null) return;
    final path = await ImageStore.pickAndCopy(source);
    if (path != null && mounted) {
      setState(() => _imagePath = path);
    }
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    await AppDatabase.instance.saveTransaction(ExpenseTransaction(
      id: widget.editing?.id,
      type: _type,
      categoryId: _categoryId!,
      amount: int.parse(_amount.text.replaceAll(RegExp(r'[^0-9]'), '')),
      note: _note.text.trim(),
      imagePath: _imagePath,
      occurredAt: _date,
    ));
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    if (await askConfirmation(context, 'Xóa giao dịch này?')) {
      await AppDatabase.instance.deleteTransaction(widget.editing!.id!);
      if (mounted) Navigator.pop(context);
    }
  }
}
