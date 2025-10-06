import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Pagina1 extends StatefulWidget {
  const Pagina1 ({super.key});

  @override
  State<Pagina1> createState() => Pagina1State();
}

class Pagina1State extends State<Pagina1> {

  final textoQrCode = TextEditingController();

  void _atualizarQrCode(){
    setState(() {
      
    });
  }

  @override
  void dispose() {
    textoQrCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
			children: [

					SizedBox(height: 40,),        

					QrImageView(
									data: textoQrCode.text,
									version: QrVersions.auto,
									size: 110,
									gapless: true,
									errorCorrectionLevel: QrErrorCorrectLevel.L
					),

					SizedBox(height: 20,),   

					Row(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
							
							SizedBox(
							width: 180,
							height: 60,
							child: TextField(
									decoration: const InputDecoration(
											border: UnderlineInputBorder(),
											labelText: "Conteúdo do QR Code"
									),
									controller: textoQrCode,
                                    maxLength: 53,
									)
							),

							ElevatedButton(
							onPressed: _atualizarQrCode,
							child: Text('Gerar QR')
							),
					],
					)
			],
    );
  }
}