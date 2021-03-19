library liboqs_flutter;
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:utf/utf.dart';
import 'package:convert/convert.dart';

part 'liboqs_kem.dart';
part 'oqs_kem.dart';
part 'liboqs_native_typedef.dart';
part 'oqs_sig.dart';
part 'kem_output_obj.dart';

class LiboqsFlutter {

  static ffi.DynamicLibrary _open() {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return ffi.DynamicLibrary.open('build/test/liboqs.dylib');
    } else {
      return Platform.isAndroid
          ? ffi.DynamicLibrary.open("liboqs.so")
          : ffi.DynamicLibrary.process();
    }
  }

  /// Call the liboqs C library
  static final ffi.DynamicLibrary _liboqs = _open();

  /// Lookup to initialize the available algorithms in oqs.
  static final void Function() _liboqsInit = _liboqs
      .lookup<ffi.NativeFunction<oqs_init>>("OQS_init")
      .asFunction<OqsInit>();
}