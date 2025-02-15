@TestOn('!js')
import 'package:stash/src/api/codec/msgpack/reader.dart';
import 'package:stash/src/api/codec/msgpack/writer.dart';
import 'package:test/test.dart';

void main() {
  void packUnpackUint64() {
    var bytes = msgPackWrite(9223372036854775807);
    var value = msgPackRead(bytes);
    expect(value, 9223372036854775807);
  }

  void packUnpackInt64() {
    var bytes = msgPackWrite(-9223372036854775808);
    var value = msgPackRead(bytes);
    expect(value, -9223372036854775808);
  }

  group('int', () {
    test('packUnpackUint64', packUnpackUint64);
    test('packUnpackInt64', packUnpackInt64);
  });
}
