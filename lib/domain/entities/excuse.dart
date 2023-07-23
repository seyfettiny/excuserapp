class Excuse {
  final int id;
  final String excuse;
  final String category;
  final String? locale;
  Excuse({
    required this.id,
    required this.excuse,
    required this.category,
    this.locale,
  });
}
