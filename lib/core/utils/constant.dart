

import 'package:uuid/uuid.dart';

class UuidState {
  static const _uuid = Uuid();

  String v4() => _uuid.v4();
}

const kDefaultRadius = 40.0;