import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Pagina2 extends StatelessWidget {
  const Pagina2 ({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      onDetect: (informacao) {
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