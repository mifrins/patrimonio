library;

import 'package:flutter/material.dart';
import 'package:patrimonio/elementos_ui/genericos.dart';
import 'package:patrimonio/elementos_ui/menu.dart';
import 'package:patrimonio/elementos_ui/formulario.dart';
import 'package:patrimonio/pagina3/operacoes_banco_de_dados.dart';

part 'mover_patrimonios.dart';

class NovoProcesso extends StatelessWidget{
  const NovoProcesso({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPadrao(texto: 'Novo Processo'),

      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
        
            SizedBox(height: 20,), 

            OpcaoMenu(
              'Processar inventário',
              (){/* Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const _ProcessarInventario())); */},
            ),            
        
            OpcaoMenu(
              'Mover patrimônio(s)',
              (){Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const _MoverPatrimonios()));},
            ),
          ]
        ),
      )
    );
  }
}