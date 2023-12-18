import 'package:intl/intl.dart';

extension DoubleUtils on double {
  String toPrice() {
    if (this == 0) return 'Gratuito';
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(this);
  }

  String toPercent() {
    if (this % 1 == 0) return "${toStringAsFixed(0)}%";
    return "${toString()}%";
  }
}

double monthProgress(DateTime dateTime) {
  int daysInMonth = DateTime(dateTime.year, dateTime.month + 1, 0).day;
  return dateTime.month + (dateTime.day / daysInMonth) - 1;
}