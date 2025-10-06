import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Pagina2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      onDetect: (informacao) {
        print(informacao.barcodes.first.rawValue);
        showDialog(
          context: context, 
          builder: (BuildContext context) => AlertDialog(
            title: Text(informacao.barcodes.first.rawValue!),
            actions: <Widget> [
              TextButton(onPressed: () => Navigator.pop(context, 'Ok'), child: const Text('Ok')),
            ]
          )
        );
      },
    );
  }
}