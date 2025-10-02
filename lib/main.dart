import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'patrimonio.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF018B7B)),
      ),
      home: const PaginaInicial(),
    );
  }
}

class PaginaInicial extends StatelessWidget {
  const PaginaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(

        body: TabBarView(
          children: [
            _Pagina1(),
            _Pagina2(),
            _Pagina3(),
          ],
        ),

        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.qr_code_2_sharp,)),
              Tab(icon: Icon(Icons.qr_code_scanner_sharp ,)),
              Tab(text: ' '),
            ]
          )
        ),
      ),
    );
  }
}

class _Pagina1 extends StatefulWidget {
  const _Pagina1 ({super.key});

  @override
  State<_Pagina1> createState() => _Pagina1State();
}

class _Pagina1State extends State<_Pagina1> {

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

class _Pagina2 extends StatelessWidget {
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

class _Pagina3 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Image(image:AssetImage('assets/images/coltec_icon.png'),);
  }
}