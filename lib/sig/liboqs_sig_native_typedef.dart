part of liboqs_sig;

/// Type definition for key encapsulation key pair function inside OqsKEM
/// structure.
typedef sig_key_pair_func = ffi.Uint8 Function(
    ffi.Pointer<OqsSig> sig,
    // ignore: non_constant_identifier_names
    ffi.Pointer<ffi.Uint8> public_key,
    // ignore: non_constant_identifier_names
    ffi.Pointer<ffi.Uint8> secret_key);
typedef SigKeyPair = int Function(
    ffi.Pointer<OqsSig> sig,
    // ignore: non_constant_identifier_names
    ffi.Pointer<ffi.Uint8> public_key,
    // ignore: non_constant_identifier_names
    ffi.Pointer<ffi.Uint8> secret_key);

/// Signature encryption function type definitions
typedef sign_func = ffi.Uint8 Function(
    ffi.Pointer<OqsSig> sig,
    ffi.Pointer<ffi.Uint8> signature,
    ffi.Pointer<ffi.Uint64> signature_len,
    ffi.Pointer<ffi.Uint8> message,
    ffi.Uint64 message_len,
    ffi.Pointer<ffi.Uint8> secret_key);
typedef Sign = int Function(
    ffi.Pointer<OqsSig> sig,
    ffi.Pointer<ffi.Uint8> signature,
    ffi.Pointer<ffi.Uint64> signature_len,
    ffi.Pointer<ffi.Uint8> message,
    int message_len,
    ffi.Pointer<ffi.Uint8> secret_key);

/// Signature verification function type definitions
typedef verify_func = ffi.Uint8 Function(
    ffi.Pointer<OqsSig> sig,
    ffi.Pointer<ffi.Uint8> message,
    ffi.Uint64 message_len,
    ffi.Pointer<ffi.Uint8> signature,
    ffi.Uint64 signature_len,
    ffi.Pointer<ffi.Uint8> public_key);
typedef Verify = int Function (
    ffi.Pointer<OqsSig> sig,
    ffi.Pointer<ffi.Uint8> message,
    int message_len,
    ffi.Pointer<ffi.Uint8> signature,
    int signature_len,
    ffi.Pointer<ffi.Uint8> public_key);

/// Free the OQS_SIG pointer.
typedef sig_free_func = ffi.Void Function (
    ffi.Pointer<OqsSig> sig
    );
typedef SigFree = void Function (ffi.Pointer<OqsSig> sig);


/// Type definition to create a new signature (OQS_SIG) object.
typedef new_sig_func = ffi.Pointer<OqsSig> Function(
    ffi.Pointer<Utf8> method
    );
typedef SigNew = ffi.Pointer<OqsSig> Function(
    ffi.Pointer<Utf8> method
    );

/// Type definition to check if a signature algorithm is enabled. Returns 1 or 0.
typedef sig_alg_is_enabled_func = ffi.Int16 Function(
    ffi.Pointer<Utf8> method_name); // ignore: non_constant_identifier_names
/// Facimile of kem_alg_is_enabled_func in Dart.
typedef SigAlgIsEnabled = int Function(
    ffi.Pointer<Utf8> method_name); // ignore: non_constant_identifier_names

/// Type definition to count the number of available signature algorithms.
typedef sig_alg_count_func = ffi.Int16 Function();
typedef SigAlgCount = int Function();

/// Type definitions to collect signature algorithm name from Liboqs.
typedef sig_alg_identifier_func = ffi.Pointer<Utf8> Function(ffi.Uint64 i);
typedef SigAlgIdentifier = ffi.Pointer<Utf8> Function(int i);
