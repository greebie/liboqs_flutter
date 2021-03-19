import 'package:ffi/ffi.dart';
import 'dart:ffi';
import 'package:flutter_test/flutter_test.dart';
import 'package:liboqs_flutter/liboqs_flutter.dart';

class TestLiboqs extends LiboqsKem {
  TestLiboqs() {
    LiboqsKem.liboqsInit();
    LiboqsKem.makeNewKem("Sabre-Kem");
    ///LiboqsKem.makeKemPair();
  }
}


void main() {
    setUp(() {

    });

    tearDown(() {
      });

    test ("Liboqs collects the list of algorithms", () {
      List<String> algoList = LiboqsKem.getKemAlgorithmsList();
      expect(algoList[0], equals("DEFAULT"));
      expect(algoList[10], equals("Kyber1024"));
      expect(algoList[25], equals("Saber-KEM"));
    });


    test ("Liboqs initializes an encryption method.", () {
      LiboqsKem.liboqsInit();
      LiboqsKem.makeNewKem("Saber-KEM");
      LiboqsKem.makeKemPair();
      String methodTest = LiboqsKem.kem.ref.method_name.toDartString();
      expect(methodTest, equals("Saber-KEM"));
      expect(LiboqsKem.kem.ref.length_public_key, equals(992));
      expect(LiboqsKem.kem.ref.length_shared_secret, equals(32));
      expect(LiboqsKem.kem.ref.length_secret_key, equals(2304));
      expect(LiboqsKem.kem.ref.length_ciphertext, equals(1088));
      LiboqsKem.freeKem();
    });


    test ( "Encaps and Decaps shared secret match", () {
      int publicKeyLength = 9616;
      int sharedSecretLength = 16;
      int secretKeyLength = 19888;
      int cipherTextLength = 9720;
      LiboqsKem.makeNewKem("DEFAULT");
      String public = LiboqsKem.makeKemPair();
      expect(LiboqsKem.kem.ref.length_public_key, equals(publicKeyLength));
      expect(LiboqsKem.kem.ref.length_shared_secret, equals(sharedSecretLength));
      expect(LiboqsKem.kem.ref.length_secret_key, equals(secretKeyLength));
      expect(LiboqsKem.kem.ref.length_ciphertext, equals(cipherTextLength));
      String methodTest2 = LiboqsKem.kem.ref.method_name.toDartString();
      expect(methodTest2, equals("FrodoKEM-640-AES"));
      KemOutput encrypted = LiboqsKem.encaps(public);
      String decrypted = LiboqsKem.decaps(encrypted.cipher);
      expect(decrypted, equals(encrypted.shared_secret));
      LiboqsKem.freeKem();
    });

    test( "secret and public are the correct size", () {
       LiboqsKem.makeNewKem("Kyber1024");
       String public = LiboqsKem.makeKemPair();
       String secret = LiboqsKem.exportSecretKey();
       expect(secret.length, equals(LiboqsKem.kem.ref.length_secret_key));
       expect(public.length, equals(LiboqsKem.kem.ref.length_public_key));
       LiboqsKem.freeKem();
    });

  }
