/// Add thousand separators to a number.
/// For example, 123456789 becomes 1,234,567,890.
String addThousands(int number) {
  return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match.group(1)},');
}
