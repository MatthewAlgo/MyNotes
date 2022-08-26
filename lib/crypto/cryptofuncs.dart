import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:pointycastle/asymmetric/oaep.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:pointycastle/signers/rsa_signer.dart';

class CryptoLocal {
  static AsymmetricKeyPair<PublicKey, PrivateKey> computeRSAKeyPair(
      SecureRandom secureRandom) {
    var rsapars = new RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 12);
    var params = new ParametersWithRandom(rsapars, secureRandom);
    var keyGenerator = new RSAKeyGenerator();
    keyGenerator.init(params);
    return keyGenerator.generateKeyPair();
  }

  static Future<AsymmetricKeyPair<PublicKey, PrivateKey>> getRSAKeyPair(
      SecureRandom secureRandom) async {
    return await compute(computeRSAKeyPair, secureRandom);
  }

  static SecureRandom exampleSecureRandom() {
    final secureRandom = FortunaRandom();

    final seedSource = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    return secureRandom;
  }

  static Uint8List rsaSign(RSAPrivateKey privateKey, Uint8List dataToSign) {
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201');

    signer.init(
        true, PrivateKeyParameter<RSAPrivateKey>(privateKey)); // true=sign

    final sig = signer.generateSignature(dataToSign);

    return sig.bytes;
  }

  static bool rsaVerify(
      RSAPublicKey publicKey, Uint8List signedData, Uint8List signature) {
    final sig = RSASignature(signature);

    final verifier = RSASigner(SHA256Digest(), '0609608648016503040201');

    verifier.init(
        false, PublicKeyParameter<RSAPublicKey>(publicKey)); // false=verify

    try {
      return verifier.verifySignature(signedData, sig);
    } on ArgumentError {
      return false; // for Pointy Castle 1.0.2 when signature has been modified
    }
  }

  static Uint8List rsaEncrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(myPublic)); // true=encrypt

    return _processInBlocks(encryptor, dataToEncrypt);
  }

  static Uint8List rsaDecrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false,
          PrivateKeyParameter<RSAPrivateKey>(myPrivate)); // false=decrypt

    return _processInBlocks(decryptor, cipherText);
  }

  static Uint8List _processInBlocks(
      AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

    final output = Uint8List(numBlocks * engine.outputBlockSize);

    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;

      outputOffset += engine.processBlock(
          input, inputOffset, chunkSize, output, outputOffset);

      inputOffset += chunkSize;
    }

    return (output.length == outputOffset)
        ? output
        : output.sublist(0, outputOffset);
  }
}
