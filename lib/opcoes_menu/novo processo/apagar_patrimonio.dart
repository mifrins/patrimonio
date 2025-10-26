part of 'novo_processo.dart';

class _ApagarPatrimonio extends StatefulWidget{
  final String nPatrimonioInicial;
  final bool fecharAposUso;
  const _ApagarPatrimonio({this.nPatrimonioInicial = '', this.fecharAposUso = false});
  @override
  State<_ApagarPatrimonio> createState() => _ApagarPatrimonioState();
}

class _ApagarPatrimonioState extends State<_ApagarPatrimonio> {
  final _keyFormulario = GlobalKey<FormState>();

  List<TextEditingController> controladores = [TextEditingController()];
  @override
  void initState() {
    super.initState();
    controladores[0].text = widget.nPatrimonioInicial;
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyFormulario,
      child: Column(
        children: [
          _CampoTextoAutocomplete(
            nome: 'N° Patrimonio',
            controlador: controladores[0],
            listarPossibilidades: (listaPossibilidades) async {
              listaPossibilidades.addAll(await listarTodosPatrimonios());
            }
          ),
          
          _BotaoEnviar(funcao: (){
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
    );
  }
}