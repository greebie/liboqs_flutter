library liboqs_sig;
import 'package:liboqs_flutter/liboqs_flutter.dart';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

part 'liboqs_sig_native_typedef.dart';
part 'oqs_sig.dart';
part 'sig_output_obj.dart';

class LiboqsSig {
  static final _liboqs = LiboqsFlutter.liboqs;
  static ffi.Pointer<ffi.Uint8> public;
  static ffi.Pointer<ffi.Uint8> _secret;
  static ffi.Pointer<OqsSig> sig;
  static OqsSig sigObj = sig.ref;

  static void liboqsInit() {
    LiboqsFlutter.liboqsInit();
  }

  static final Sign _sign = _liboqs
      .lookup<ffi.NativeFunction<sign_func>>("OQS_SIG_sign")
      .asFunction<Sign>();

  static final Verify _verify = _liboqs
      .lookup<ffi.NativeFunction<verify_func>>("OQS_SIG_verify")
      .asFunction<Verify>();

  static final _sigFree = _liboqs
      .lookup<ffi.NativeFunction<sig_free_func>>("OQS_SIG_free")
      .asFunction<SigFree>();

  static final _sigNew = _liboqs
      .lookup<ffi.NativeFunction<new_sig_func>>("OQS_SIG_new")
      .asFunction<SigNew>();

  static final _sigAlgIsEnabled = _liboqs
      .lookup<ffi.NativeFunction<sig_alg_is_enabled_func>>("OQS_SIG_alg_is_enabled")
      .asFunction<SigAlgIsEnabled>();

  static final _sigAlgCount = _liboqs
      .lookup<ffi.NativeFunction<sig_alg_count_func>>("OQS_SIG_alg_count")
      .asFunction<SigAlgCount>();

  static final _sigAlgIdentifier = _liboqs
      .lookup<ffi.NativeFunction<sig_alg_identifier_func>>("OQS_SIG_alg_identifier")
      .asFunction<SigAlgIdentifier>();

  static final _sigKeyPair = _liboqs
      .lookup<ffi.NativeFunction<sig_key_pair_func>>("OQS_SIG_keypair")
      .asFunction<SigKeyPair>();

  static bool sigAlgEnabled(String alg) {
    final ffi.Pointer<Utf8> str = alg.toNativeUtf8();
    bool enabled = _sigAlgIsEnabled(str) == 1;
    calloc.free(str);
    return enabled;
  }

  static void makeNewSig(String method) {
    ffi.Pointer<Utf8> meth = method.toNativeUtf8();
    sig = _sigNew(meth);
    calloc.free(meth);
  }

  static String _makeSigPairFunc(ffi.Pointer<OqsSig> sig) {
    public = malloc<ffi.Uint8>(sig.ref.length_public_key +1);
    _secret = malloc<ffi.Uint8>(sig.ref.length_secret_key +1);
    int resp = _sigKeyPair(sig, public, _secret);
    return (resp == 0) ? String.fromCharCodes(public.asTypedList(sig.ref.length_public_key)) : "";
  }

  static SigOutput sign(String msg, String secretKey) {
    final ffi.Pointer<ffi.Uint8> secret = LiboqsFlutter.toBytesPointer(secretKey.codeUnits);
    final ffi.Pointer<ffi.Uint8> message = LiboqsFlutter.toBytesPointer(msg.codeUnits);
    final int message_len = msg.length;
    final ffi.Pointer<ffi.Uint64> signature_length = calloc<ffi.Uint64>();
    signature_length.value = sig.ref.length_signature;
    final ffi.Pointer<ffi.Uint8> signature = malloc<ffi.Uint8>(sig.ref.length_signature +1);
    final int resp = _sign(sig, signature, signature_length, message, message_len, secret);
    SigOutput ret = SigOutput(String.fromCharCodes(signature.asTypedList(sig.ref.length_signature)), signature_length.value);
    malloc.free(secret);
    malloc.free(signature);
    malloc.free(signature_length);
    malloc.free(message);
    return (resp == 0) ? ret : SigOutput("Invalid", 0);
  }

  static bool verify(String signature, String msg, String publicKey) {
    final ffi.Pointer<ffi.Uint8> public = LiboqsFlutter.toBytesPointer(publicKey.codeUnits);
    final ffi.Pointer<ffi.Uint8> signed = LiboqsFlutter.toBytesPointer(signature.codeUnits);
    final ffi.Pointer<ffi.Uint8> message = LiboqsFlutter.toBytesPointer(msg.codeUnits);
    final int messageLen = msg.length;
    final int resp = _verify(sig, message, messageLen, signed, sig.ref.length_signature, public);
    bool ret = resp == 0;
    malloc.free(public);
    malloc.free(signed);
    malloc.free(message);
    return ret;
  }

  static String makeSigPair() {
    return _makeSigPairFunc(sig);
  }

  static freeSig() {
    if (sig != null) _sigFree(sig);
  }

  static exportSecretKey() {
    return String.fromCharCodes(_secret.asTypedList(sig.ref.length_secret_key));
  }

  /// Returns the List of Key Encapsulation Algorithm names
  static List<String> getSigAlgorithmsList() {
    return List.generate(
        _sigAlgCount(), (index) => _sigAlgIdentifier(index).toDartString())
        .where((String x) => sigAlgEnabled(x))
        .toList();
  }
}