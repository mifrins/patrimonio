import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patrimonio/pagina3/operacoes_banco_de_dados.dart';

class Processo {
  DateTime data;
  String responsavel;
  String tipo;
  String descricao;
  String sala;

  Processo({
    required this.data,
    required this.responsavel,
    required this.tipo,
    required this.descricao,
    required this.sala,
  });

  Map<String, dynamic> paraMap() {
    return {
      'data': data.toIso8601String(),
      'responsavel': responsavel,
      'tipo': tipo,
      'descricao': descricao,
      'sala': sala,
    };
  }

  factory Processo.deMap(Map<String, dynamic> mapa) {
    return Processo(
      data: DateTime.parse(mapa['data']),
      responsavel: mapa['responsavel'],
      tipo: mapa['tipo'],
      descricao: mapa['descricao'],
      sala: mapa['sala'],
    );
  }

/*   static bool aprovarProcesso(QueryDocumentSnapshot<Map<String, dynamic>> processo, BuildContext context){
    FirebaseFirestore bd = FirebaseFirestore.instance;    
    String descricao = processo.data()['descricao'];


    switch(processo.data()['tipo']){

      case 'Movimentação de patrimônio':
        List<String> patrimoniosEscolhidos = descricao.substring(13, descricao.indexOf(' de ')).split(', ');
        String salaOrigem = descricao.substring(descricao.indexOf(' de ') + 4, descricao.indexOf(' para '));
        String salaDestino = descricao.substring(descricao.indexOf(' para ') + 6, descricao.length);

        // Copiar documentos da sala de origem para a sala de destino      
        for (var nPatrimonio in patrimoniosEscolhidos){
          encontrarPatrimonio(nPatrimonio).then((documento){
            if(documento != null){            
              documento.get().then((documentoSnapshot){
                bd.collection(salaDestino).doc(nPatrimonio).set(documentoSnapshot.data()!);
                documento.delete();
              });
            } else {
              showDialog(
                context: context, 
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Erro'),
                  content: Text('$nPatrimonio não foi encontrado e não foi movimentado.'),
                  actions: <Widget> [
                    TextButton(onPressed: () => Navigator.pop(context, 'Fechar'), child: const Text('Fechar')),
                  ]
                )
              );
            }
          });
        }
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Tipo de processo não reconhecido'),));
        return false;
    }

    //Se chegou até aqui, o processo pôde ser efetuado
    var processoAprovado = processo.data();
    var identificacaoUsuario = 'placeholder@teiacoltec.org';
    processoAprovado['responsavel'] = '${processoAprovado['responsavel']}, aprovado por $identificacaoUsuario';
    bd.collection('processos_passados').doc(processo.id).set(processoAprovado);
    bd.collection('processos_pendentes').doc(processo.id).delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Processo aprovado.'),));
    return true;
  } */
}