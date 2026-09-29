import '../models/transaction_type.dart';

class DateRange {
  const DateRange(this.from, this.to);

  final DateTime from;
  final DateTime to;

  static DateRange forPeriod(DateTime date, Period period) {
    final day = DateTime(date.year, date.month, date.day);
    switch (period) {
      case Period.day:
        return DateRange(day, day.add(const Duration(days: 1)));
      case Period.week:
        final start = day.subtract(Duration(days: day.weekday - 1));
        return DateRange(start, start.add(const Duration(days: 7)));
      case Period.month:
        final start = DateTime(day.year, day.month);
        return DateRange(start, DateTime(day.year, day.month + 1));
    }
  }

  static DateTime shift(DateTime date, Period period, int direction) {
    switch (period) {
      case Period.day:
        return date.add(Duration(days: direction));
      case Period.week:
        return date.add(Duration(days: 7 * direction));
      case Period.month:
        final targetYear = date.year;
        final targetMonth = date.month + direction;
        final lastDayOfTargetMonth =
            DateTime(targetYear, targetMonth + 1, 0).day;
        final targetDay =
            date.day > lastDayOfTargetMonth ? lastDayOfTargetMonth : date.day;
        return DateTime(targetYear, targetMonth, targetDay);
    }
  }
}
