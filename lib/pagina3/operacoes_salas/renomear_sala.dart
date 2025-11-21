part of 'operacoes_salas.dart';

class ProcessoRenomearSala extends StatefulWidget{
  final String salaEscolhida;
  const ProcessoRenomearSala({required this.salaEscolhida});
  @override
  State<ProcessoRenomearSala> createState() => ProcessoRenomearSalaState();
}

class ProcessoRenomearSalaState extends State<ProcessoRenomearSala> {
  final _keyFormulario = GlobalKey<FormState>();

  List<TextEditingController> controladores = List.generate(1, (contagem) => TextEditingController());

  @override
  Widget build(BuildContext context) {

    controladores[0].text = widget.salaEscolhida;

    return Scaffold(
      appBar: AppBarPadrao(texto: 'Renomeando sala ${widget.salaEscolhida}'),

      body: RolagemVertical( child: Form(
        key: _keyFormulario,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),

            CampoTexto(nome: 'Novo nome', controlador: controladores[0], validacao: CampoTexto.checarVazio),

            BotaoConfirmar(funcao: (){
              // Validar formulário
              if(_keyFormulario.currentState!.validate()){
                // Fazer outras verificações antes de renomear
                listarSalas().then((listaDeSalas){
                  // Checar se sala original existe
                  if(!listaDeSalas.contains(widget.salaEscolhida)){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Sala não encontrada.'),));
                    return;
                  }
                  // Checar se já existe uma sala com o nome novo
                  if(listaDeSalas.contains(controladores[0].text)){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Já existe uma sala com esse nome.'),));
                    return;
                  }
                  // Se chegou até aqui, a sala pode ser renomeada.
                  renomearSala(widget.salaEscolhida, controladores[0].text);


                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Sala renomeada.'),));
                  
                  // Voltar à tela anterior
                  Navigator.pop(context);
                });
              }
            })
          ],
        )
      ))
    );
  }
}