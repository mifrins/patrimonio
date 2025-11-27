import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patrimonio/classes/patrimonio.dart';
import 'package:flutter/material.dart';

Future<List<String>> listarSalas() async{
  List<String> salas = [];

  // Pegar referência do banco de dados
  FirebaseFirestore bd = FirebaseFirestore.instance;

  // Obter todos documentos na coleção "salas", e usar elas por meio da variável querySnapshot
  QuerySnapshot querySnapshot = await bd.collection('salas').get();

  for (var documento in querySnapshot.docs){
    salas.add(documento.id);
  }

  return salas;
}

Future<List<Patrimonio>> listarPatrimoniosSala(String sala) async{
  List<Patrimonio> patrimonios = [];

  // Pegar referência do banco de dados
  FirebaseFirestore bd = FirebaseFirestore.instance;

  // Obter todos documentos na coleção da sala escolhida, e usar elas por meio da variável querySnapshot
  QuerySnapshot querySnapshot = await  bd.collection(sala).get();

  for (var documento in querySnapshot.docs){
    patrimonios.add(Patrimonio.deMap(documento.data() as Map<String, dynamic>));
  }
  return patrimonios;
}

Future<List<String>> listarTodosPatrimonios() async{
  List<String> patrimonios = [];

  FirebaseFirestore bd = FirebaseFirestore.instance;

  for (var sala in await listarSalas()){
    QuerySnapshot querySnapshot = await  bd.collection(sala).get();

    for (var documento in querySnapshot.docs){
      patrimonios.add(documento.id);
    }
  }

  return patrimonios;
}

Future<DocumentReference<Map<String, dynamic>>?> encontrarPatrimonio(String nPatrimonio) async {
  FirebaseFirestore bd = FirebaseFirestore.instance;

 for (var sala in await listarSalas()){
    QuerySnapshot querySnapshot = await bd.collection(sala).get();

    for (var documento in querySnapshot.docs){
      if(documento.id == nPatrimonio){
        return bd.collection(sala).doc(nPatrimonio);
      }
    }
  } 

  return null;
}

Future<void> criarPatrimonio(String sala, Patrimonio informacoesPatrimonio) async {
  FirebaseFirestore bd = FirebaseFirestore.instance;

  bd.collection(sala).doc(informacoesPatrimonio.nPatrimonio).set(informacoesPatrimonio.paraMap());
}

Future<void> editarPatrimonio(String nPatOriginal, Patrimonio informacoesPatrimonio) async {
  
  // Encontrar documento original do patrimonio
  encontrarPatrimonio(nPatOriginal).then((documento){ 
    if(documento != null) {
      // Criar novo documento na mesma sala com o novo n de patrimonio
      criarPatrimonio(documento.parent.id, informacoesPatrimonio);
      
      // Se o novo n de patrimonio for diferente do original, apagar documento original que não foi substituído
      if(nPatOriginal != informacoesPatrimonio.nPatrimonio){
        documento.delete();
      }
    }
  });
}

Future<void> apagarPatrimonio(String nPatrimonio) async {
  encontrarPatrimonio(nPatrimonio).then((documento){ 
    if(documento != null) {documento.delete();}
  });
}

Future<void> criarSala(String nome) async {
  FirebaseFirestore bd = FirebaseFirestore.instance;
  // Criar documento listando a sala na coleção "salas"
  bd.collection('salas').doc(nome).set({});
}

Future<void> renomearSala(String nomeAntigo, String novoNome) async {
  criarSala(novoNome);

  // Iterar pelos documentos na coleção antiga copiando eles pra coleção nova
  for(var patrimonio in await listarPatrimoniosSala(nomeAntigo)){
    criarPatrimonio(novoNome, patrimonio);
  }

  apagarSala(nomeAntigo);

}

Future<void> apagarSala(String nome) async {
  FirebaseFirestore bd = FirebaseFirestore.instance;
  var sala = bd.collection(nome);
  
  // Deletar todos documentos na coleção da sala
  for(var patrimonio in await listarPatrimoniosSala(nome)){
    sala.doc(patrimonio.nPatrimonio).delete();
  }

  // Deletar documento listando a sala na coleção "salas"
  bd.collection('salas').doc(nome).delete();

}

Future<void> criarProcesso({required String tipo, required String descricao, required String sala, required bool deixarPendente}) async {
  FirebaseFirestore bd = FirebaseFirestore.instance;

  // E-mail do usuário atual
  var identificacaoUsuario = 'placeholder@teiacoltec.org';

  // Onde o processo deve ser criado
  String destino;
  if(deixarPendente){
    destino = 'processos_pendentes';
  } else {
    destino = 'processos_passados';
  }

  // Hora que o processo está sendo criado
  DateTime tempoAtual = DateTime.now();

  // Criar documento para o processo
  bd.collection(destino).doc('${tempoAtual.toIso8601String()} $identificacaoUsuario').set(
    {
      'data': tempoAtual.toString(),
      'responsavel': identificacaoUsuario,
      'tipo': tipo,
      'descricao': descricao,
      'sala': sala,
    }
  );
}

Future<bool> aprovarProcesso(QueryDocumentSnapshot<Map<String, dynamic>> processo, BuildContext context) async {
  FirebaseFirestore bd = FirebaseFirestore.instance;    
  String descricao = processo.data()['descricao'];


  switch(processo.data()['tipo']){
    case 'Movimentação de patrimônio':
    
      List<String> patrimoniosEscolhidos = descricao.substring(13, descricao.indexOf(' de ')).split(', ');
//    String salaOrigem = descricao.substring(descricao.indexOf(' de ') + 4, descricao.indexOf(' para '));
      String salaDestino = descricao.substring(descricao.indexOf(' para ') + 6, descricao.length);

      // Copiar documentos da sala de origem para a sala de destino      
      for (var nPatrimonio in patrimoniosEscolhidos){

        encontrarPatrimonio(nPatrimonio).then((documento){
          documento!.get().then((documentoSnapshot){
            if(documentoSnapshot.exists){      
              bd.collection(salaDestino).doc(nPatrimonio).set(documentoSnapshot.data()!);
              documento.delete();
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
}
