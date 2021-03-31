import 'package:flutter/material.dart';
import 'package:liboqs_flutter/liboqs_flutter.dart';

class SigApp extends StatefulWidget {
  @override
  _SigAppState createState() => _SigAppState();
}

class _SigAppState extends State<SigApp> {
  /// Signed (encrypted) text.
  String _signature;
  /// Message to encrypt.
  String _message;
  String _publicKey;
  String _secretKey;

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
