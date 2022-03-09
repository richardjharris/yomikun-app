import 'package:hive_flutter/hive_flutter.dart';

part 'bookmark.g.dart';

/// Represents a bookmark to a page or item within the application.
@HiveType(typeId: 0)
class Bookmark {
  @HiveField(0)
  final String url;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime dateAdded;

  Bookmark({
    required this.url,
    required this.title,
    required this.dateAdded,
  });

  String get urlAction => Uri.parse(url).path;

  Map<String, String> get urlParameters => Uri.parse(url).queryParameters;

  @override
  String toString() {
    return 'Bookmark{url: $url, title: $title, dateAdded: $dateAdded}';
  }
}
