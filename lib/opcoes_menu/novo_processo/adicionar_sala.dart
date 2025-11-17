part of 'novo_processo.dart';

class _AdicionarSala extends StatefulWidget{
  @override
  State<_AdicionarSala> createState() => _AdicionarSalaState();
}

class _AdicionarSalaState extends State<_AdicionarSala> {
  final _keyFormulario = GlobalKey<FormState>();

  List<TextEditingController> controladores = List.generate(1, (contagem) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyFormulario,
      child: Column(
        children: [
          _CampoTexto(nome: 'Nome', controlador: controladores[0], validacao: _CampoTexto.checarVazio),
          
          _BotaoConfirmar(funcao: (){
            // Validar formulário
            if(_keyFormulario.currentState!.validate()){
              // Fazer outras verificações antes de criar
              listarTodosPatrimonios().then((listaDePatrimonios){
                listarSalas().then((listaDeSalas){
                  // Checar se sala existe
                  if(!listaDeSalas.contains(controladores[0].text)){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Sala não existente.'),));
                    return;
                  }
                  // Checar se o valor digitado pode ser convertido
                  if(double.tryParse(controladores[5].text.replaceAll(',', '.')) == null){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Valor do bem inválido.'),));
                    return;
                  }
                  // Se chegou até aqui, o patrimônio pode ser catalogado.
                  // Criar documento para o patrimonio
/*                   criarPatrimonio(
                    controladores[0].text,
                    Patrimonio(
                      nPatrimonio: controladores[1].text,
                      descricaoDoItem: controladores[2].text,
                      tr: controladores[3].text,
                      conservacao: controladores[4].text,
                      valorBem: double.parse(controladores[5].text.replaceAll(',', '.')),
                      oc: checkboxes[0][0],
                      qb: checkboxes[1][0],
                      ne: checkboxes[2][0],
                      sp: checkboxes[3][0]
                    )
                  ); */

                  // Apagar numero do patrimonio fornecido
                  controladores[1].clear();

                  // Mostrar mensagem depois de criar um patrimonio
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Patrimônio catalogado.'),));
                });
              });
            }
          })
        ],
      )
    );
  }
}