import 'package:ffi/ffi.dart';
import 'dart:ffi';
import 'package:flutter_test/flutter_test.dart';
import 'package:liboqs_flutter/liboqs_flutter.dart';

void main() {

  test("Signature algorithms collected correctly", () {
    List<String> algoList = LiboqsSig.getSigAlgorithmsList();
    expect(algoList[0], equals("DEFAULT"));
    expect(algoList[10], equals("Rainbow-I-Circumzenithal"));
    expect(algoList[25], equals("SPHINCS+-Haraka-192s-simple"));
  });

  test ("Liboqs initializes an encryption method.", () {
    int publicKeyLength = 1312;
    int secretKeyLength = 2528;
    int signatureLength = 2420;
    LiboqsSig.liboqsInit();
    LiboqsSig.makeNewSig("DEFAULT");
    LiboqsSig.makeSigPair();
    String methodTest = LiboqsSig.sig.ref.method_name.toDartString();
    expect(methodTest, equals("Dilithium2"));
    expect(LiboqsSig.sig.ref.length_public_key, equals(publicKeyLength));
    expect(LiboqsSig.sig.ref.length_secret_key, equals(secretKeyLength));
    expect(LiboqsSig.sig.ref.length_signature, equals(signatureLength));
    LiboqsSig.freeSig();
  });

  test ( "Sig and Verify match", () {
    int publicKeyLength = 1312;
    int secretKeyLength = 2528;
    int signatureLength = 2420;
    String message = "super secret message";
    int messageLen = message.length;
    LiboqsSig.makeNewSig("DEFAULT");
    String public = LiboqsSig.makeSigPair();
    String secret = LiboqsSig.exportSecretKey();
    expect(LiboqsSig.sig.ref.length_public_key, equals(public.length));
    expect(LiboqsSig.sig.ref.length_secret_key, equals(secretKeyLength));
    expect(LiboqsSig.sig.ref.length_signature, equals(signatureLength));
    String methodTest2 = LiboqsSig.sig.ref.method_name.toDartString();
    expect(methodTest2, equals("Dilithium2"));
    SigOutput encrypted = LiboqsSig.sign(message, secret);
    expect(encrypted.signature.length, equals(encrypted.signatureLen));
    bool verified = LiboqsSig.verify(encrypted.signature, message, public);
    expect(verified, equals(true));
    LiboqsKem.freeKem();
  });

}