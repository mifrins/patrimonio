import 'package:flutter/material.dart';
import 'package:patrimonio/elementos_ui/genericos.dart';
import '../operacoes_banco_de_dados.dart';
import 'operacoes_patrimonio.dart';


class _SalaDropDown extends StatefulWidget{
  final String nome;
  const _SalaDropDown({required this.nome});

  @override
  State<_SalaDropDown> createState() => _SalaDropDownState();
}

class _SalaDropDownState extends State<_SalaDropDown> {
  bool aberto = false;
  IconData? iconeDropDown;
  
  Widget? tabelaPatrimonios;
  List<DataRow> linhasTabela = [];  

  @override
  Widget build(BuildContext context) {
    if(aberto){
      iconeDropDown = Icons.arrow_drop_down_rounded;
      tabelaPatrimonios = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Expanded(child: Text('N° Patrimônio', style: TextStyle(fontStyle: FontStyle.italic)))),
            DataColumn(label: Expanded(child: Text('Descrição do Item', style: TextStyle(fontStyle: FontStyle.italic)))),
            DataColumn(label: Expanded(child: Text('TR', style: TextStyle(fontStyle: FontStyle.italic)))),
            DataColumn(label: Expanded(child: Text('Conservação', style: TextStyle(fontStyle: FontStyle.italic)))),
            DataColumn(label: Expanded(child: Text('Valor bem', style: TextStyle(fontStyle: FontStyle.italic)))),
            DataColumn(label: Expanded(child: Text('OC', style: TextStyle(fontStyle: FontStyle.italic)))),
            DataColumn(label: Expanded(child: Text('QB', style: TextStyle(fontStyle: FontStyle.italic)))),
            DataColumn(label: Expanded(child: Text('NE', style: TextStyle(fontStyle: FontStyle.italic)))),
            DataColumn(label: Expanded(child: Text('SP', style: TextStyle(fontStyle: FontStyle.italic)))),
          ],
          rows: linhasTabela
        )
      );
    }else{
      iconeDropDown = Icons.arrow_drop_up_rounded;
      tabelaPatrimonios = SizedBox.shrink();
    }
    return Column(
      children: [
        TextButton(
          onPressed: (){
              setState((){
                aberto = !aberto;
                // Se estiver aberto, buscar os dados e depois reconstruir a tabela
                if(aberto){
                  listarPatrimoniosSala(widget.nome).then((listaDePatrimonios){
                    setState(() {
                      linhasTabela.clear();
                      for(var patrimonio in listaDePatrimonios){
                        linhasTabela.add(
                          DataRow(
                            cells: [
                              DataCell(Text(patrimonio.nPatrimonio)),
                              DataCell(Text(patrimonio.descricaoDoItem)),
                              DataCell(Text(patrimonio.tr)),
                              DataCell(Text(patrimonio.conservacao)),
                              DataCell(Text(patrimonio.valorBem.toString().replaceAll('.', ','))),
                              DataCell(Text(patrimonio.oc.toString().replaceAll('true', 'Sim').replaceAll('false', 'Não'))),
                              DataCell(Text(patrimonio.qb.toString().replaceAll('true', 'Sim').replaceAll('false', 'Não'))),
                              DataCell(Text(patrimonio.ne.toString().replaceAll('true', 'Sim').replaceAll('false', 'Não'))),
                              DataCell(Text(patrimonio.sp.toString().replaceAll('true', 'Sim').replaceAll('false', 'Não'))),
                            ],
                            onLongPress: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(patrimonio.nPatrimonio),
                                content: const Text('Escolha uma ação'),
                                actions: <Widget>[
                                  // Editar
                                  TextButton(
                                    onPressed: (){
                                      Navigator.pop(context, 'Editar');
                                      Navigator.push(context, MaterialPageRoute<void>(builder: (context) => ProcessoEditarPatrimonio(nPatrimonioEscolhido: patrimonio.nPatrimonio)));
                                    },
                                    child: const Text('Editar'),
                                  ),
                                  // Apagar
                                  TextButton(
                                    onPressed: (){
                                      Navigator.pop(context, 'Apagar');
                                      Navigator.push(context, MaterialPageRoute<void>(builder: (context) => ProcessoApagarPatrimonio(nPatrimonioInicial: patrimonio.nPatrimonio, fecharAposUso: true,)));
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
              }
            );
          },
          style: ButtonStyle(
            fixedSize: WidgetStateProperty.all<Size>(Size(MediaQuery.sizeOf(context).width, 60)),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
          ),
          child: 
            Row(children: [
              Icon(iconeDropDown, size: 40,),
              Text(widget.nome, style: TextStyle(color:Colors.black, fontSize: 20))
            ],)
        ),
        tabelaPatrimonios!,
        SizedBox(height: 7),
      ]
    );
  }
}

class CatalogoPatrimonios extends StatefulWidget {
  const CatalogoPatrimonios({super.key});

  @override
  State<CatalogoPatrimonios> createState() => _CatalogoPatrimoniosState();
}

class _CatalogoPatrimoniosState extends State<CatalogoPatrimonios> {
  List<_SalaDropDown> salas = [];

  @override
  void initState() {
    super.initState();
    // A tela vai começar vazia, mas vai recarregar quando a função listarSalas retornar algo
    listarSalas().then((listaDeSalas){
      setState(() {
          for(var salaNome in listaDeSalas){
            salas.add(
              _SalaDropDown(nome: salaNome)
            );
          }
      });

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBarPadrao(texto: 'Catálogo de Patrimônios'),

      // Configurar página para ter rolagem sem uma barra lateral
      body:  RolagemVertical( child: Column(
          children:salas
      )),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute<void>(builder: (context) => ProcessoCatalogarPatrimonio()));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      )
    );
  }
}
