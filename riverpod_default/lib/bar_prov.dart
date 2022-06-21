import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'foo_prov.dart';

final barProv = StateProvider(
  (ref) => ref.watch(fooProv).bar,
);
