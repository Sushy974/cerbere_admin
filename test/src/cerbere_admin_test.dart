// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:cerbere_admin/src/cerbere_admin.dart';

void main() {
  group('CerbereAdmin', () {
    test('can be instantiated', () {
      expect(CerbereAdmin(), isNotNull);
    });
  });
}
