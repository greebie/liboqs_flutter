library liboqs_kem;

import 'package:liboqs_flutter/liboqs_flutter.dart';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

part 'kem_output_obj.dart';
part 'oqs_kem.dart';
part 'liboqs_kem_native_typedef.dart';

/// A wrapper for the Key Encapsulation tools in the liboqs C package.
///
/// Oqs is a package containing members of post-quantum or 'quantum safe'
/// cryptographic algorithms. These algorithms represent a collection of
/// solutions that can be used by non-quantum computers to protect against
/// cyberattacks from a Quantum Computer via Grover or Shor's algorithms.
///
/// This library is intended for experimental use only and should not be
/// considered safe for production purposes. If you are looking for a
/// quantum-safe solution for your mobile apps, keep in mind:
///  - there is no guarantee these algorithms are safe against quantum
///  attacks.
///  - the NIST has not confirmed which algorithms are the 'best' for quantum safety.
///  - Even if the algorithms are quantum safe, there is no guarantee they are
///  safe against traditional attacks.
///  - even if the algorithms are completely safe, this implementation merely exposes
///  the library for cryptographic purposes. Attacking an implementation system is
///  likely the more common source of a cyberattack.
///
///
class LiboqsKem {
  static final _liboqs = LiboqsFlutter.liboqs;

  /// The key that Alice and Bob exchange and Eve can see.
  static ffi.Pointer<ffi.Uint8> public;

  /// The key that Alice and Bob hide on their computer and Eve cannot see.
  static ffi.Pointer<ffi.Uint8> _secret;

  /// The method of Key Encapsulation
  static ffi.Pointer<OqsKem> kem;
  static OqsKem kemObj = kem.ref;

  static final KemEncaps _encaps = _liboqs
      .lookup<ffi.NativeFunction<kem_encaps_func>>("OQS_KEM_encaps")
      .asFunction<KemEncaps>();

  static final KemDecaps _decaps = _liboqs
      .lookup<ffi.NativeFunction<kem_decaps_func>>("OQS_KEM_decaps")
      .asFunction<KemDecaps>();

  static final KemFree _kemFree = _liboqs
      .lookup<ffi.NativeFunction<kem_free_func>>("OQS_KEM_free")
      .asFunction<KemFree>();

  static final KemKeypair _kemKeypair = _liboqs
      .lookup<ffi.NativeFunction<kem_keypair_func>>("OQS_KEM_keypair")
      .asFunction<KemKeypair>();

  static final KemNew _kemNew = _liboqs
      .lookup<ffi.NativeFunction<kem_new_func>>("OQS_KEM_new")
      .asFunction<KemNew>();

  /// Lookup to count the available algorithms in the oqs library build.
  static final int Function() _kemAlgCount = _liboqs
      .lookup<ffi.NativeFunction<kem_alg_count_func>>("OQS_KEM_alg_count")
      .asFunction<KemAlgCount>();

  /// Lookup to return 1 if the algorithm value is enabled, otherwise 0.
  ///
  /// The list of correct algorithm names can be found in the kem.h header
  /// file in liboqs.
  static final int Function(ffi.Pointer<Utf8>) _kemAlgIsEnabled = _liboqs
      .lookup<ffi.NativeFunction<kem_alg_is_enabled_func>>(
          'OQS_KEM_alg_is_enabled')
      .asFunction<KemAlgIsEnabled>();

  /// Lookup to produce an algorithm name from an index reference.
  ///
  /// @param i An index reference as an integer.
  /// @return A pointer to the name of the algorithm corresponding to the index.
  static final ffi.Pointer<Utf8> Function(int) _kemAlgIdentifier = _liboqs
      .lookup<ffi.NativeFunction<kem_alg_identifier_func>>(
          'OQS_KEM_alg_identifier')
      .asFunction<KemAlgIdentifier>();

  static final void Function(ffi.Pointer, int) _memSecureFree = _liboqs
      .lookup<ffi.NativeFunction<mem_cleanse_func>>('OQS_MEM_secure_free')
      .asFunction<MemCleanse>();

  static final void Function(ffi.Pointer) _memInsecureFree = _liboqs
      .lookup<ffi.NativeFunction<mem_insecure_free_func>>(
          'OQS_MEM_insecure_free')
      .asFunction<MemInsecureFree>();

  /// Initializes a key encapsulation structure (object)
  ///
  /// @param method The algorithm name (from the KemAlgorithm List)
  /// @return a Pointer to the OqsKem structure (values can be attained using
  /// the .ref attribute)
  static void makeNewKem(String method) {
    ffi.Pointer<Utf8> meth = method.toNativeUtf8();
    kem = _kemNew(meth);
    calloc.free(meth);
  }

  /// Initializes OQS, for
  static void liboqsInit() {
    LiboqsFlutter.liboqsInit();
  }

  /// Creates a key encapsulation pair
  ///
  /// @param kem The OqsKem pointer attained using makeNewKem
  /// @param secret_key_length The length of the secret key.
  /// @param public_key_length The length of the public key.
  static String _makeKemPairFunc(ffi.Pointer<OqsKem> kem) {
    //freeKeypair();
    public = malloc<ffi.Uint8>(kem.ref.length_public_key + 1);
    _secret = malloc<ffi.Uint8>(kem.ref.length_secret_key + 1);
    int resp = _kemKeypair(kem, public, _secret);
    //public[kem.ref.length_public_key] = 0;
    //secret[kem.ref.length_secret_key] = 0;
    return (resp == 0) ? String.fromCharCodes(public.asTypedList(kem.ref.length_public_key)): "";
  }

  static KemOutput encaps(String publicKey) {
    final ffi.Pointer<ffi.Uint8> public = LiboqsFlutter.toBytesPointer(publicKey.codeUnits);
    final ffi.Pointer<ffi.Uint8> sharedSecretBytes =
        malloc<ffi.Uint8>(kem.ref.length_shared_secret + 1);
    final ffi.Pointer<ffi.Uint8> cipherTextBytes =
        malloc<ffi.Uint8>(kem.ref.length_ciphertext + 1);
    final int resp = _encaps(kem, cipherTextBytes, sharedSecretBytes, public);
    KemOutput ret = KemOutput(
        String.fromCharCodes(
            cipherTextBytes.asTypedList(kem.ref.length_ciphertext)),
        String.fromCharCodes(
            sharedSecretBytes.asTypedList(kem.ref.length_shared_secret)));
    malloc.free(sharedSecretBytes);
    malloc.free(cipherTextBytes);
    malloc.free(public);
    return (resp == 0) ? ret : KemOutput("Invalid", "Invalid");
  }

  static String decaps(String cipher) {
    final ffi.Pointer<ffi.Uint8> sharedSecretDecapsBytes =
        malloc<ffi.Uint8>(kem.ref.length_shared_secret + 1);
    final ffi.Pointer<ffi.Uint8> cipherTextDecapsBytes =
        LiboqsFlutter.toBytesPointer(cipher.codeUnits);
    final int resp =
        _decaps(kem, sharedSecretDecapsBytes, cipherTextDecapsBytes, _secret);
    String ret = String.fromCharCodes(
        sharedSecretDecapsBytes.asTypedList(kem.ref.length_shared_secret));
    malloc.free(cipherTextDecapsBytes);
    malloc.free(sharedSecretDecapsBytes);
    return (resp == 0) ? ret : "Output failed";
  }

  /// Creates key encapsulation pair directly from OqsKem pointer
  static String makeKemPair() {
    return _makeKemPairFunc(kem);
  }

  static String exportSecretKey() {
    return String.fromCharCodes(_secret.asTypedList(kem.ref.length_secret_key));
  }

  /// Returns the result of [kemAlgIdentifier()] as a string instead of a
  /// pointer.
  static String getKemAlgorithmByIndex(int index) {
    print(index);
    if (index < _kemAlgCount() && index > 0) {
      return getKemAlgorithmsList()[index];
    } else {
      return "DEFAULT";
    }
  }

  static bool kemAlgIsEnabled(String alg) {
    final ffi.Pointer<Utf8> str = alg.toNativeUtf8();
    bool enabled = _kemAlgIsEnabled(str) == 1 ? true : false;
    calloc.free(str);
    return enabled;
  }

  static void freeKem() {
    if (kem != null) _kemFree(kem);
  }

  static void freeKeypair() {
    if (_secret != null)
      _memSecureFree(_secret, kem.ref.length_shared_secret + 1);
    if (public != null) _memSecureFree(public, kem.ref.length_public_key + 1);
    if (_secret != null) _memInsecureFree(_secret);
    if (public != null) _memInsecureFree(public);
  }

  /// Returns the List of Key Encapsulation Algorithm names
  static List<String> getKemAlgorithmsList() {
    return List.generate(
            _kemAlgCount(), (index) => _kemAlgIdentifier(index).toDartString())
        .where((x) => kemAlgIsEnabled((x)))
        .toList();
  }
}

class DecoyKem {}
