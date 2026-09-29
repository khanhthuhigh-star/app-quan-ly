import 'package:intl/intl.dart';

class Money {
  static final _format = NumberFormat.decimalPattern('vi_VN');
  static String format(int value) => '${_format.format(value)} ₫';
}
