import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patrimonio/classes/patrimonio.dart';

Future<List<String>> listarSalas() async{
  List<String> salas = [];

  // Pegar referência do banco de dados
  FirebaseFirestore bd = FirebaseFirestore.instance;

  // Obter todos documentos na coleção "salas", e usar elas por meio da variável querySnapshot
  QuerySnapshot querySnapshot = await  bd.collection('salas').get();

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
    patrimonios.add(Patrimonio.deMapa(documento.data() as Map<String, dynamic>));
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
    QuerySnapshot querySnapshot = await  bd.collection(sala).get();

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
      if(nPatOriginal != informacoesPatrimonio){
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
  FirebaseFirestore bd = FirebaseFirestore.instance;
  
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