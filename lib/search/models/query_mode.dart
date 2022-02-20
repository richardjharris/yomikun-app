import 'package:hive_flutter/hive_flutter.dart';

part 'query_mode.g.dart';

@HiveType(typeId: 4)
enum QueryMode {
  @HiveField(0)
  mei,
  @HiveField(1)
  sei,
  @HiveField(2)
  person,
  @HiveField(3)
  wildcard,
}
