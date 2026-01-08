import 'package:intl/intl.dart';

/// Consistent formatting for currency/price values across the app.
///
/// Examples:
/// - formatMoney(12500, 'USD') -> "USD 12,500"
/// - formatMoney(12500.5, 'NGN', fractionDigits: 2) -> "NGN 12,500.50"
///
/// For non-currency numeric values (e.g. sizes), use [formatNumber].
String formatMoney(
  num? amount,
  String? currencyCode, {
  int fractionDigits = 0,
}) {
  if (amount == null) return '';

  final code = (currencyCode ?? '').trim().isEmpty
      ? ''
      : currencyCode!.trim().toUpperCase();

  final formatter = NumberFormat.decimalPattern()
    ..minimumFractionDigits = fractionDigits
    ..maximumFractionDigits = fractionDigits;

  final formatted = formatter.format(amount);
  return code.isEmpty ? formatted : '$code $formatted';
}

/// Formats a plain numeric value with grouping separators.
///
/// Example: formatNumber(12000) -> "12,000"
String formatNumber(num? value, {int fractionDigits = 0}) {
  if (value == null) return '';
  final formatter = NumberFormat.decimalPattern()
    ..minimumFractionDigits = fractionDigits
    ..maximumFractionDigits = fractionDigits;
  return formatter.format(value);
}
