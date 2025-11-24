import 'package:flutter/material.dart';
import 'package:patrimonio/elementos_ui/genericos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patrimonio/pagina3/operacoes_banco_de_dados.dart';


class ProcessosPendentes extends StatefulWidget {
  const ProcessosPendentes ({super.key});

  @override
  State<ProcessosPendentes> createState() => ProcessosPendentesState();
}

class ProcessosPendentesState extends State<ProcessosPendentes> {
  List<DataRow> linhasTabela = [];

  Future<void> carregarProcessos() async {
    var querySnapshot = await FirebaseFirestore.instance.collection('processos_pendentes').get();

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

          onLongPress: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Processo por ${documento.data()['responsavel']}'),
              content: const Text('Escolha uma ação'),
              actions: <Widget>[
                TextButton(
                  onPressed: (){
                    Navigator.pop(context, 'Aprovar');
                    aprovarProcesso(documento, context).then((deuCerto){
                      if(deuCerto){ 
                        print('chegou aki');
                        carregarProcessos().then((_){
                          setState(() {});
                        });
                      }
                    });
                  },
                  child: const Text('Aprovar'),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.pop(context, 'Apagar');
                    //Navigator.push(context, MaterialPageRoute<void>(builder: (context) => ProcessoApagarSala(salaEscolhida: sala,)));
                  },
                  child: const Text('Apagar'),
                ),
                TextButton(onPressed: () => Navigator.pop(context, 'Cancelar'), child: const Text('Cancelar')),
              ],
            ),
          ),
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
      appBar: AppBarPadrao(texto: 'Processos pendentes'),

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