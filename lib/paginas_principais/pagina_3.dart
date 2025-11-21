import 'package:flutter/material.dart';

import 'package:patrimonio/pagina3/catalogo_patrimonios.dart';
import 'package:patrimonio/pagina3/catalogo_salas.dart';

class _OpcaoMenu extends StatelessWidget{
  final String texto;
  final VoidCallback rotaConstrutorPagina;
  const _OpcaoMenu(this.texto, this.rotaConstrutorPagina);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: rotaConstrutorPagina,
          style: ButtonStyle(
            fixedSize: WidgetStateProperty.all<Size>(Size(MediaQuery.sizeOf(context).width - 40, 80)),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          ),
          child: Text(texto, style: TextStyle( fontSize: 20)),
        ),
        SizedBox(height: 7),   
      ]
    );
  }
}

class Pagina3 extends StatelessWidget{
  const Pagina3({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        SizedBox(height: 20,), 

        _OpcaoMenu(
          "Catálogo de patrimônios",
          (){ Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const CatalogoPatrimonios()));},
        ),

        _OpcaoMenu(
          "Catálogo de salas",
          (){ Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const CatalogoSalas()));},
        ),

        _OpcaoMenu(
          "Abrir novo processo",
          (){},
        ),

        _OpcaoMenu(
          "Ver processos passados",
          (){ Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const CatalogoPatrimonios()));},
        ),
      ]
    );
  }
}