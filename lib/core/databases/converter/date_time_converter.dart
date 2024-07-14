import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

class DateTimeConverter extends TypeConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromSql(String fromDb) {
    print("Date time mapToDart: $fromDb");
    return DateTime.parse(fromDb);
  }

  @override
  String toSql(DateTime value) {
    print("Date time mapToSql: ${value.toString()}");
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(value);
  }
}
