import 'package:flutter/material.dart';
import 'package:liboqs_flutter/liboqs_flutter.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
          TextButton(
              child: Text("Kem Example"),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => KemApp()))),
          TextButton(child: Text("Signature Example"), onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => SigApp())))
        ])));
  }
}

class SigApp extends StatefulWidget {
  @override
  _SigAppState createState() => _SigAppState();
}

class _SigAppState extends State<SigApp> {
  String _signature;
  String _publicKey;
  String _secretKey;
  String _message;
  TextEditingController _controller = TextEditingController();
  List<String> _algorithms;
  List<Widget> _algorithmWidgets;
  int _currentAlgorithm;
  String _method = "DEFAULT";
  bool _signed = true;
  _SigAppState();
  @override
  void initState() {
    LiboqsKem.liboqsInit();
    setState(() {
      _currentAlgorithm = 0;
      _signature = "";
      _message = "";
      _algorithms = LiboqsSig.getSigAlgorithmsList();
      _algorithmWidgets = LiboqsSig.getSigAlgorithmsList().map((String x) {
        return ListTile(
          leading: Text(""),
          title: Text("Algorithm: $x", style: TextStyle(fontSize: 15)),
          subtitle: Text("", style: TextStyle(fontSize: 10)),
        );
      }).toList();
    });
    updateSigState();
    super.initState();
  }

  updateSigState() {
    setState(() {
      _method = _algorithms[_currentAlgorithm];
      LiboqsSig.makeNewSig(_method);
      _publicKey = LiboqsSig.makeSigPair();
      _secretKey = LiboqsSig.exportSecretKey();
    });
  }

  showSignature(BuildContext context) {
    _setSignatureState();
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("OK"));

    AlertDialog signatureTextBox = AlertDialog(
      title: Text("Signature"),
      content: Text("$_signature" ?? "No signature generated"),
      actions: [
        okButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return signatureTextBox;
        });
  }

  bool _verify(signature, message, publicKey) {
    return LiboqsSig.verify(signature, message, publicKey);
  }

  showVerificationTest(BuildContext context, bool test) {
    IconData icon = test ? Icons.check_circle_outline_sharp : Icons.dangerous;
    String text = test
        ? "Congratulations the signature has been verified to the message."
        : "Oh Dear, something went wrong";
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("OK"));

    AlertDialog verificationTextBox = AlertDialog(
      title: Text(text),
      content: Icon(icon, size: 100),
      actions: [
        okButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return verificationTextBox;
        });
  }

  _setSignatureState() {
    updateSigState();
    final sig = LiboqsSig.sign(_message, _secretKey);
    setState(() {
      _signature = sig.signature;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Message Signing and Verification Example.'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                maxLines: 4,
                  controller: _controller,
                  onChanged: (text) {
                  setState(() {
                    _message = text;
                  });
            }),
              Flexible(
                  child: ListWheelScrollView(
                      controller: FixedExtentScrollController(initialItem: 0),
                      itemExtent: 50,
                      useMagnifier: true,
                      magnification: 1.5,
                      diameterRatio: 2.0,
                      offAxisFraction: 0.50,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          _currentAlgorithm;
                        });
                      },
                      children: _algorithmWidgets)),
              ElevatedButton(
                child: Text(_signed ? "Show signature" : "Verify signature"),
                onPressed: () {
                  _signed
                      ? showSignature(context)
                      : showVerificationTest(
                          context, _verify(_signature, _message, _publicKey));
                  setState(() {
                    _signed = !_signed;
                  });
                },
              ),
            ]));
  }
}

class KemApp extends StatefulWidget {
  @override
  _KemAppState createState() => _KemAppState();
}

class _KemAppState extends State<KemApp> {
  String _sharedSecret;
  String _cipherText;
  get cipherText => _cipherText;
  String _publicKey;
  String _secretKey;
  List<String> _algorithms;
  List<Widget> _algorithmWidgets;
  int _currentAlgorithm;
  String _method = "DEFAULT";
  bool _encaps = true;

  _KemAppState();
  @override
  void initState() {
    LiboqsKem.liboqsInit();
    setState(() {
      _currentAlgorithm = 0;
      _sharedSecret = "";
      _cipherText = "";
      _algorithms = LiboqsKem.getKemAlgorithmsList();
      _algorithmWidgets = LiboqsKem.getKemAlgorithmsList().map((String x) {
        return ListTile(
          leading: Text(""),
          title: Text("Algorithm: $x", style: TextStyle(fontSize: 15)),
          subtitle: Text("", style: TextStyle(fontSize: 10)),
        );
      }).toList();
    });
    updateKemState();
    super.initState();
  }

  void updateKemState() {
    setState(() {
      _method = _algorithms[_currentAlgorithm];
      LiboqsKem.makeNewKem(_method);
      _publicKey = LiboqsKem.makeKemPair();
      _secretKey = LiboqsKem.exportSecretKey();
    });
  }

  _setSharedSecretState() {
    updateKemState();
    final pair = LiboqsKem.encaps(_publicKey);
    setState(() {
      _cipherText = pair.cipher;
      _sharedSecret = pair.shared_secret;
    });
  }

  _testGeneratedKeyPairState(secretKey, sharedSecret) {
    return LiboqsKem.decaps(secretKey) == sharedSecret;
  }

  showDecipherTest(BuildContext context, bool test) {
    IconData icon = test ? Icons.check_circle_outline_sharp : Icons.dangerous;
    String text = test
        ? "Congratulations the Decapsulation matched the shared_secret"
        : "Oh Dear, something went wrong";
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("OK"));

    AlertDialog decapsTextBox = AlertDialog(
      title: Text(text),
      content: Icon(icon, size: 100),
      actions: [
        okButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return decapsTextBox;
        });
  }

  showcipherText(BuildContext context, cipherText) {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("OK"));

    AlertDialog cipherTextBox = AlertDialog(
      title: Text("CipherText"),
      content: Text("$cipherText" ?? "No cipher"),
      actions: [
        okButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return cipherTextBox;
        });
  }

  @override
  Widget build(BuildContext context) {
    final cipherText = _cipherText;
    final sharedSecret = _sharedSecret;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Key Encryption Example.'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              child: ListWheelScrollView(
                  controller: FixedExtentScrollController(initialItem: 0),
                  itemExtent: 50,
                  useMagnifier: true,
                  magnification: 1.5,
                  diameterRatio: 2.0,
                  offAxisFraction: 0.50,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _currentAlgorithm;
                    });
                  },
                  children: _algorithmWidgets)),
          ElevatedButton(
            child:
                Text(_encaps ? "Show generated pair" : "Test generated pair"),
            onPressed: () {
              _encaps
                  ? _setSharedSecretState()
                  : showDecipherTest(context,
                      _testGeneratedKeyPairState(cipherText, sharedSecret));
              setState(() {
                _encaps = !_encaps;
              });
            },
          ),
          Row(children: [
            Text(sharedSecret),
            ElevatedButton(
                child: Text("See Ciphertext"),
                onPressed: () {
                  final text = cipherText;
                  showcipherText(context, text);
                })
          ])
        ],
      ),
    );
  }
}
