import 'package:flutter/material.dart';
import 'package:patrimonio/elementos_ui/genericos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patrimonio/pagina3/operacoes_banco_de_dados.dart';


class ProcessosPassados extends StatefulWidget {
  const ProcessosPassados ({super.key});

  @override
  State<ProcessosPassados> createState() => ProcessosPassadosState();
}

class ProcessosPassadosState extends State<ProcessosPassados> {
  List<DataRow> linhasTabela = [];

  Future<void> carregarProcessos() async {
    var querySnapshot = await FirebaseFirestore.instance.collection('processos_passados').orderBy('data', descending: true).get();

    linhasTabela.clear();
    for (var documento in querySnapshot.docs){
      linhasTabela.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text(documento.data()['sala'])),              
            DataCell(Text(documento.data()['data'].replaceAll('-', '/').substring(0, documento.data()['data'].length - 7))),
            DataCell(Text(documento.data()['responsavel'])),       
            DataCell(Text(documento.data()['tipo'])),                     
            DataCell(Text(documento.data()['descricao'])),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    carregarProcessos().then((_){
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPadrao(texto: 'Processos passados'),

      body: RolagemVertical(child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(label: Expanded(child: Text('Sala'))),
            DataColumn(label: Expanded(child: Text('Data'))),
            DataColumn(label: Expanded(child: Text('Responsável'))),
            DataColumn(label: Expanded(child: Text('Tipo'))),                    
            DataColumn(label: Expanded(child: Text('Descrição'))),
          ],
          rows: linhasTabela
        )
      )),
    );
  }
}