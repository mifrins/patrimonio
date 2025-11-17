import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patrimonio/elementos_visuais/genericos.dart';
import 'operacoes_banco_de_dados.dart';

class CatalogoSalas extends StatefulWidget {
  const CatalogoSalas ({super.key});

  @override
  State<CatalogoSalas> createState() => CatalogoSalasState();
}

class CatalogoSalasState extends State<CatalogoSalas> {

  List<DataRow> linhasTabela = [];

  @override
  void initState() {
    super.initState();
    // A tela vai começar vazia, mas vai recarregar quando a função listarSalas retornar algo
    listarSalas().then((listaDeSalas){
      setState(() {
          for(var sala in listaDeSalas){
            linhasTabela.add(
              DataRow(
                cells: <DataCell>[
                  DataCell(Text(sala)),
                ],
              ),
            );
          }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPadrao(texto: 'Catálogo de salas'),

      body: RolagemVertical(child: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Expanded(
              child: Text('Sala', style: TextStyle(fontStyle: FontStyle.italic)),
            ),
          ),
        ],
        rows: linhasTabela
      ))
    );
  }
}