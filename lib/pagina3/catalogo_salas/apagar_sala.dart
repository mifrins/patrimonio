part of 'operacoes_salas.dart';

class ProcessoApagarSala extends StatefulWidget{
  final String salaEscolhida;
  const ProcessoApagarSala({required this.salaEscolhida});
  @override
  State<ProcessoApagarSala> createState() => ProcessoApagarSalaState();
}

class ProcessoApagarSalaState extends State<ProcessoApagarSala> {
  final _keyFormulario = GlobalKey<FormState>();

  List<TextEditingController> controladores = List.generate(1, (contagem) => TextEditingController());

  @override
  Widget build(BuildContext context) {

    controladores[0].text = widget.salaEscolhida;

    return Scaffold(
      appBar: AppBarPadrao(texto: 'Apagar sala'),

      body: RolagemVertical( child: Form(
        key: _keyFormulario,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),

            CampoTextoAutocomplete(
              nome: 'Sala',
              controlador: controladores[0],
              listarPossibilidades: (listaPossibilidades) async {
                listaPossibilidades.addAll(await listarSalas());
              },
              onSelected: (_){},
            ),

            BotaoConfirmar(funcao: (){
              // Validar formulário
              if(_keyFormulario.currentState!.validate()){
                // Fazer outras verificações antes de criar
                listarSalas().then((listaDeSalas){
                  // Checar se sala existe
                  if(!listaDeSalas.contains(controladores[0].text)){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Sala não existe.'),));
                    return;
                  }

                  // Se chegou até aqui, a sala pode ser apagada.
                  criarProcesso(
                    tipo: 'Sala deletada',
                    descricao: controladores[0].text,
                    sala: controladores[0].text,
                    deixarPendente: false,
                  );

                  apagarSala(controladores[0].text);

                  controladores[0].clear();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Sala apagada.'),));

                });
              }
            })
          ],
        )
      ))
    );
  }
}