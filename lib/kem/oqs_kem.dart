part of liboqs_kem;

/// A structure for storing and Key Encapsulation data, duplicates the OQS_KEM
/// struct in liboqs.
///
///
class OqsKem extends ffi.Struct {
  ffi.Pointer<Utf8> method_name; // ignore: non_constant_identifier_names
  ffi.Pointer<Utf8> alg_version; // ignore: non_constant_identifier_names
  @ffi.Uint8()
  int claimed_nist_level; // ignore: non_constant_identifier_names
  /// ffi library does not accept bool, so use 8 bit.
  @ffi.Uint8()
  int ind_cca; // ignore: non_constant_identifier_names
  /// Need full bit size to accommodate size_t
  @ffi.Uint64()
  int length_public_key; // ignore: non_constant_identifier_names
  @ffi.Uint64()
  int length_secret_key; // ignore: non_constant_identifier_names
  @ffi.Uint64()
  int length_ciphertext; // ignore: non_constant_identifier_names
  @ffi.Uint64()
  int length_shared_secret; // ignore: non_constant_identifier_names

  ffi.Pointer<ffi.NativeFunction<kem_key_pair_func>> keypair;
  ffi.Pointer<ffi.NativeFunction<kem_encaps_func>> encaps;
  ffi.Pointer<ffi.NativeFunction<kem_decaps_func>> decaps;

  factory OqsKem.allocate(
      ffi.Pointer<Utf8>
      method_name, // ignore: non_constant_identifier_names
      ffi.Pointer<Utf8>
      alg_version, // ignore: non_constant_identifier_names
      int claimed_nist_level, // ignore: non_constant_identifier_names
      int ind_cca, // ignore: non_constant_identifier_names
      int length_public_key, // ignore: non_constant_identifier_names
      int length_secret_key, // ignore: non_constant_identifier_names
      int length_ciphertext, // ignore: non_constant_identifier_names
      int length_shared_secret, // ignore: non_constant_identifier_names
      ffi.Pointer<ffi.NativeFunction<kem_key_pair_func>> keypair,
      ffi.Pointer<ffi.NativeFunction<kem_encaps_func>> encaps,
      ffi.Pointer<ffi.NativeFunction<kem_decaps_func>> decaps) =>
      calloc<OqsKem>().ref
        ..method_name = method_name
        ..alg_version = alg_version
        ..claimed_nist_level = claimed_nist_level
        ..ind_cca = ind_cca
        ..length_public_key = length_public_key
        ..length_secret_key = length_secret_key
        ..length_ciphertext = length_ciphertext
        ..length_shared_secret = length_shared_secret
        ..keypair = keypair
        ..encaps = encaps
        ..decaps = decaps;
}