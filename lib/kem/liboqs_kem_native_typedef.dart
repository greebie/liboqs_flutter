part of liboqs_kem;

/// Memory cleansing functions
///
typedef mem_cleanse_func = ffi.Void Function(ffi.Pointer ptr,
    ffi.Uint64 len);
typedef MemCleanse = void Function(ffi.Pointer ptr, int len);

typedef mem_insecure_free_func = ffi.Void Function(ffi.Pointer prt);
typedef MemInsecureFree = void Function(ffi.Pointer prt);

/// Type definition for key encapsulation key pair function inside OqsKEM
/// structure.
typedef kem_key_pair_func = ffi.Uint8 Function(
    // ignore: non_constant_identifier_names
    ffi.Pointer<ffi.Uint8> public_key,
    // ignore: non_constant_identifier_names
    ffi.Pointer<ffi.Uint8> secret_key);

typedef KemKeyPair = int Function(
    // ignore: non_constant_identifier_names
    ffi.Pointer<ffi.Uint8> public_key,
    // ignore: non_constant_identifier_names
    ffi.Pointer<ffi.Uint8> secret_key);

/// Type definition for key encapsulation function inside the OqsKem structure.
typedef kem_encaps_func = ffi.Uint8 Function(
    ffi.Pointer<OqsKem> kem,
    ffi.Pointer<ffi.Uint8> ciphertext,
    ffi.Pointer<ffi.Uint8>
    shared_secret, // ignore: non_constant_identifier_names
    ffi.Pointer<ffi.Uint8> public_key // ignore: non_constant_identifier_names
    );

/// Dart facimile for liboqs kem_encap function, duplicated for consistency.
typedef KemEncaps = int Function(
    ffi.Pointer<OqsKem> kem,
    ffi.Pointer<ffi.Uint8> ciphertext,
    ffi.Pointer<ffi.Uint8>
    shared_secret, // ignore: non_constant_identifier_names
    ffi.Pointer<ffi.Uint8> public_key // ignore: non_constant_identifier_names
    );

/// Type definition for key decapsulation function inside the OqsKem structure.
typedef kem_decaps_func = ffi.Uint8 Function(
    ffi.Pointer<OqsKem> kem,
    ffi.Pointer<ffi.Uint8>
    shared_secret, // ignore: non_constant_identifier_names
    ffi.Pointer<ffi.Uint8> ciphertext,
    ffi.Pointer<ffi.Uint8> secret_key // ignore: non_constant_identifier_names
    );

/// Dart facimile for liboqs kem_decaps function.
typedef KemDecaps = int Function(
    ffi.Pointer<OqsKem> kem,
    ffi.Pointer<ffi.Uint8>
    shared_secret, // ignore: non_constant_identifier_names
    ffi.Pointer<ffi.Uint8> ciphertext,
    ffi.Pointer<ffi.Uint8> secret_key // ignore: non_constant_identifier_names
    );

/// Type definitions to collect key encapsulation algorithm name from Liboqs.
typedef kem_alg_identifier_func = ffi.Pointer<Utf8> Function(ffi.Uint64 i);
typedef KemAlgIdentifier = ffi.Pointer<Utf8> Function(int i);

/// Type definition to check if an key encapsulation algorithm is enabled. Returns 1 or 0.
typedef kem_alg_is_enabled_func = ffi.Int16 Function(
    ffi.Pointer<Utf8> method_name); // ignore: non_constant_identifier_names
/// Facimile of kem_alg_is_enabled_func in Dart.
typedef KemAlgIsEnabled = int Function(
    ffi.Pointer<Utf8> method_name); // ignore: non_constant_identifier_names

typedef kem_free_func = ffi.Void Function(ffi.Pointer<OqsKem> kem);
typedef KemFree = void Function(ffi.Pointer<OqsKem> kem);

/// Type definition to count the number of available key encapsulation algorithms.
typedef kem_alg_count_func = ffi.Int16 Function();
typedef KemAlgCount = int Function();

/// Type definition to create a key encapsulation structure.
typedef kem_new_func = ffi.Pointer<OqsKem> Function(
    ffi.Pointer<Utf8> method_name); // ignore: non_constant_identifier_names
/// Type alias of kem_alg_count_func in Dart notation.
typedef KemNew = ffi.Pointer<OqsKem> Function(
    ffi.Pointer<Utf8> method_name); // ignore: non_constant_identifier_names

/// Type definition to allocate memory for public and secret keys
typedef kem_keypair_func = ffi.Uint8 Function(
    ffi.Pointer<OqsKem> kem,
    ffi.Pointer<ffi.Uint8> public_key, // ignore: non_constant_identifier_names
    ffi.Pointer<ffi.Uint8> secret_key); // ignore: non_constant_identifier_names

/// Type alias of kem_keypair_func in Dart notation.
typedef KemKeypair = int Function(
    ffi.Pointer<OqsKem> kem,
    ffi.Pointer<ffi.Uint8> public_key, // ignore: non_constant_identifier_names
    ffi.Pointer<ffi.Uint8> secret_key); // ignore: non_constant_identifier_names
