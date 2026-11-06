import 'package:intl/intl.dart';

final _price = NumberFormat.currency(
  locale: 'es_CO',
  symbol: r'$',
  decimalDigits: 0,
);
final _date = DateFormat('dd/MM/yyyy HH:mm');

String formatPrice(num value) => _price.format(value);

String formatDate(DateTime date) => _date.format(date);
