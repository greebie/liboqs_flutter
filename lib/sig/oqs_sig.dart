part of liboqs_sig;

/// A structure for storing and Key Encapsulation data, duplicates the OQS_KEM
/// struct in liboqs.
///
///
class OqsSig extends ffi.Struct {
  ffi.Pointer<Utf8> method_name; // ignore: non_constant_identifier_names
  ffi.Pointer<Utf8> alg_version; // ignore: non_constant_identifier_names
  @ffi.Uint8()
  int claimed_nist_level; // ignore: non_constant_identifier_names
  /// ffi library does not accept bool, so use 8 bit.
  @ffi.Uint8()
  int euf_cca; // ignore: non_constant_identifier_names
  /// Need full bit size to accommodate size_t
  @ffi.Uint64()
  int length_public_key; // ignore: non_constant_identifier_names
  @ffi.Uint64()
  int length_secret_key; // ignore: non_constant_identifier_names
  @ffi.Uint64()
  int length_signature; // ignore: non_constant_identifier_names

  ffi.Pointer<ffi.NativeFunction<sig_key_pair_func>> keypair;
  ffi.Pointer<ffi.NativeFunction<sign_func>> sign;
  ffi.Pointer<ffi.NativeFunction<verify_func>> verify;

  factory OqsSig.allocate(
      ffi.Pointer<Utf8>
      method_name, // ignore: non_constant_identifier_names
      ffi.Pointer<Utf8>
      alg_version, // ignore: non_constant_identifier_names
      int claimed_nist_level, // ignore: non_constant_identifier_names
      int euf_cca, // ignore: non_constant_identifier_names
      int length_public_key, // ignore: non_constant_identifier_names
      int length_secret_key, // ignore: non_constant_identifier_names
      int length_signature, // ignore: non_constant_identifier_names
      int length_shared_secret, // ignore: non_constant_identifier_names
      ffi.Pointer<ffi.NativeFunction<sig_key_pair_func>> keypair,
      ffi.Pointer<ffi.NativeFunction<sign_func>> sign,
      ffi.Pointer<ffi.NativeFunction<verify_func>> verify) =>
      calloc<OqsSig>().ref
        ..method_name = method_name
        ..alg_version = alg_version
        ..claimed_nist_level = claimed_nist_level
        ..euf_cca = euf_cca
        ..length_public_key = length_public_key
        ..length_secret_key = length_secret_key
        ..length_signature = length_signature
        ..keypair = keypair
        ..sign = sign
        ..verify = verify;
}