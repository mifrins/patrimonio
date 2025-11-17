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

  await bd.collection(sala).doc(informacoesPatrimonio.nPatrimonio).set(informacoesPatrimonio.paraMap());
}

Future<void> editarPatrimonio(Patrimonio informacoesPatrimonio) async {
  encontrarPatrimonio(informacoesPatrimonio.nPatrimonio).then((documento){ 
    if(documento != null) {documento.set(informacoesPatrimonio.paraMap());}
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

