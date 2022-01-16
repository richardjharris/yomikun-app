import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../services/name_database.dart';

final databaseProvider = Provider((_) => NameDatabase());
