import 'package:flutter/material.dart';
import 'package:patrimonio/elementos_ui/menu.dart';

import 'package:patrimonio/pagina3/catalogo_patrimonios/catalogo_patrimonios.dart';
import 'package:patrimonio/pagina3/catalogo_salas/catalogo_salas.dart';

import 'package:patrimonio/pagina3/novo_processo/novo_processo.dart';

class Pagina3 extends StatelessWidget{
  const Pagina3({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        SizedBox(height: 20,), 

        OpcaoMenu(
          "Catálogo de patrimônios",
          (){ Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const CatalogoPatrimonios()));},
        ),

        OpcaoMenu(
          "Catálogo de salas",
          (){ Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const CatalogoSalas()));},
        ),

        OpcaoMenu(
          "Abrir novo processo",
          (){ Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const NovoProcesso()));},
        ),

        OpcaoMenu(
          "Ver processos abertos",
          (){ Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const CatalogoPatrimonios()));},
        ),

        OpcaoMenu(
          "Ver processos passados",
          (){ Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const CatalogoPatrimonios()));},
        ),
      ]
    );
  }
}