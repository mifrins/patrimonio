import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patrimonio/patrimonio.dart';

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

void criarSala(){
  // Criar documento listando a sala na coleção "salas"

  // Criar uma coleção para os patrimônios da sala
}

Future<void> criarPatrimonio(String sala, Patrimonio informacoesPatrimonio) async {
  FirebaseFirestore bd = FirebaseFirestore.instance;

  await bd.collection(sala).doc(informacoesPatrimonio.nPatrimonio).set(informacoesPatrimonio.paraMap());

}