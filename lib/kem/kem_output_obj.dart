part of liboqs_kem;

class KemOutput {
  final String cipher;
  final String shared_secret;
  KemOutput(this.cipher, this.shared_secret);
}