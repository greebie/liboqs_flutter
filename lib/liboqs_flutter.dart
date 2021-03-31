library liboqs_flutter;
export 'kem/liboqs_kem.dart';
export 'sig/liboqs_sig.dart';

import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart';

part 'liboqs_native_typedef.dart';

class LiboqsFlutter {

  static ffi.DynamicLibrary _open() {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return ffi.DynamicLibrary.open('build/test/liboqs.dylib');
    } else {
      return Platform.isAndroid
          ? ffi.DynamicLibrary.open("liboqs.so")
          : ffi.DynamicLibrary.open("liboqs.dylib");
    }
  }

  /// Call the liboqs C library
  static final ffi.DynamicLibrary liboqs = _open();

  /// Lookup to initialize the available algorithms in oqs.
  static final void Function() liboqsInit = liboqs
      .lookup<ffi.NativeFunction<oqs_init>>("OQS_init")
      .asFunction<OqsInit>();

  static ffi.Pointer<ffi.Uint8> toBytesPointer(List<int> bytes) {
    final ffi.Pointer<ffi.Uint8> result = malloc<ffi.Uint8>(bytes.length);
    final List<int> nativeBytes = result.asTypedList(bytes.length).cast<int>();
    nativeBytes.setRange(0, bytes.length, bytes);
    return result;
  }
}