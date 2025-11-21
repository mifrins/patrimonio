import 'package:flutter/material.dart';
import 'package:patrimonio/elementos_visuais/genericos.dart';
import 'operacoes_banco_de_dados.dart';
import 'novo_processo/novo_processo.dart';

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

                onLongPress: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(sala),
                    content: const Text('Escolha uma ação'),
                    actions: <Widget>[
                      // Renomear
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context, 'Renomear');
                          Navigator.push(context, MaterialPageRoute<void>(builder: (context) => ProcessoRenomearSala(salaEscolhida: sala,)));
                        },
                        child: const Text('Renomear'),
                      ),
                      // Apagar
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context, 'Apagar');
                          Navigator.push(context, MaterialPageRoute<void>(builder: (context) => ProcessoApagarSala(salaEscolhida: sala,)));
                        },
                        child: const Text('Apagar'),
                      ),
                      // Cancelar
                      TextButton(onPressed: () => Navigator.pop(context, 'Cancelar'), child: const Text('Cancelar')),
                    ],
                  ),
                ),
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
      )),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute<void>(builder: (context) => ProcessoAdicionarSala()));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      )
    );
  }
}