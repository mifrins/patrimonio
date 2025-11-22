part of 'operacoes_salas.dart';

class ProcessoAdicionarSala extends StatefulWidget{
  @override
  State<ProcessoAdicionarSala> createState() => ProcessoAdicionarSalaState();
}

class ProcessoAdicionarSalaState extends State<ProcessoAdicionarSala> {
  final _keyFormulario = GlobalKey<FormState>();

  List<TextEditingController> controladores = List.generate(1, (contagem) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPadrao(texto: 'Adicionar sala'),

      body: RolagemVertical( child: Form(
        key: _keyFormulario,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),

            CampoTexto(nome: 'Nome da sala', controlador: controladores[0], validacao: CampoTexto.checarVazio),
            
            BotaoConfirmar(funcao: (){
              // Validar formulário
              if(_keyFormulario.currentState!.validate()){
                // Fazer outras verificações antes de criar
                listarSalas().then((listaDeSalas){
                  // Checar se sala já existe
                  if(listaDeSalas.contains(controladores[0].text)){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Sala já existe.'),));
                    return;
                  }
                  
                  FirebaseFirestore.instance.collection(controladores[0].text).get().then((querySnapshot){
                    // Checar se há uma coleção com o mesmo nome da sala a ser criada
                    if(querySnapshot.docs.isNotEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Nome da sala é inválido.'),));
                      return;
                    }

                    // Se chegou até aqui, a sala pode ser criada.
                    criarProcesso(
                      tipo: 'Sala criada',
                      descricao: controladores[0].text,
                      sala: controladores[0].text,
                      deixarPendente: false,
                    );
                    criarSala(controladores[0].text);

                    controladores[0].clear();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Sala criada.'),));
                  });
                });
              }
            })
          ],
        )
      ))
    );
  }
}