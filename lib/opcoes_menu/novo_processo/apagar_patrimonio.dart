part of 'novo_processo.dart';

class ProcessoApagarPatrimonio extends StatefulWidget{
  final String nPatrimonioInicial;
  final bool fecharAposUso;
  const ProcessoApagarPatrimonio({this.nPatrimonioInicial = '', this.fecharAposUso = false});
  @override
  State<ProcessoApagarPatrimonio> createState() => ProcessoApagarPatrimonioState();
}

class ProcessoApagarPatrimonioState extends State<ProcessoApagarPatrimonio> {
  final _keyFormulario = GlobalKey<FormState>();

  List<TextEditingController> controladores = [TextEditingController()];
  @override
  void initState() {
    super.initState();
    controladores[0].text = widget.nPatrimonioInicial;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPadrao(texto: 'Apagar patrimônio'),

      body: RolagemVertical( child: Form(
        key: _keyFormulario,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CampoTextoAutocomplete(
              nome: 'N° Patrimonio',
              controlador: controladores[0],
              listarPossibilidades: (listaPossibilidades) async {
                listaPossibilidades.addAll(await listarTodosPatrimonios());
              },
              onSelected: (_){},
            ),
            
            _BotaoConfirmar(funcao: (){
              // Validar formulário
              if(_keyFormulario.currentState!.validate()){
                // Fazer outras verificações antes de criar
                listarTodosPatrimonios().then((listaDePatrimonios){
                  // Checar se o patrimônio está catalogado
                  if(!listaDePatrimonios.contains(controladores[0].text)){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Patrimônio não existe.'),));
                      return;
                  }
                  apagarPatrimonio(controladores[0].text);
      
                  // Apagar numero do patrimonio fornecido
                  controladores[0].clear();

                  // Mostrar mensagem depois de apagar patrimonio
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Patrimônio apagado.'),));
                  
                  if(widget.fecharAposUso){
                    Navigator.pop(context);
                  }
                });
              }
            })
          ],
        )
      ))
    );
  }
}