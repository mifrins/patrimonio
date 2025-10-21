part of 'novo_processo.dart';

class _CatalogarPatrimonio extends StatefulWidget{
  @override
  State<_CatalogarPatrimonio> createState() => _CatalogarPatrimonioState();
}

class _CatalogarPatrimonioState extends State<_CatalogarPatrimonio> {
  final _keyFormulario = GlobalKey<FormState>();

  List<TextEditingController> controladores = List.generate(6, (contagem) => TextEditingController());
  List<bool> checkboxes = List.generate(4, (contagem) => false);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyFormulario,
      child: Column(
        children: [
          CampoTexto(nome: 'Sala', controlador: controladores[0], validacao: CampoTexto.checarVazio),
          CampoTexto(nome: 'N° Patrimonio', controlador: controladores[1], validacao: CampoTexto.checarVazio),
          CampoTexto(nome: 'Descrição do Item', controlador: controladores[2], validacao: CampoTexto.checarVazio),
          CampoTexto(nome: 'TR', controlador: controladores[3], validacao: CampoTexto.checarVazio),
          CampoTexto(nome: 'Conservação', controlador: controladores[4], validacao: CampoTexto.checarVazio),
          CampoTexto(nome: 'Valor Bem', controlador: controladores[5], validacao: CampoTexto.checarVazio),
          CampoCheckBox(nome: 'OC', setter: ((valorAtual) => checkboxes[0] = valorAtual)),
          CampoCheckBox(nome: 'QB', setter: ((valorAtual) => checkboxes[1] = valorAtual)),
          CampoCheckBox(nome: 'NE', setter: ((valorAtual) => checkboxes[2] = valorAtual)),
          CampoCheckBox(nome: 'SP', setter: ((valorAtual) => checkboxes[3] = valorAtual)),
          
          BotaoEnviar(funcao: (){
            // Validar formulário
            if(_keyFormulario.currentState!.validate()){
              // Fazer outras verificações antes de criar
              listarTodosPatrimonios().then((listaDePatrimonios){
                // Checar se o patrimônio já foi catalogado
                if(listaDePatrimonios.contains(controladores[1].text)){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Patrimônio já foi catalogado.'),));
                    return;
                }
                listarSalas().then((listaDeSalas){
                  // Checar se sala existe
                  if(!listaDeSalas.contains(controladores[0].text)){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Sala não existente.'),));
                    return;
                  }
                  // Checar se o nome é de alguma coleção parte do sistema
                  if(controladores[0].text == 'salas' || controladores[0].text == 'processos'){
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
                  criarPatrimonio(
                    controladores[0].text,
                    Patrimonio(
                      nPatrimonio: controladores[1].text,
                      descricaoDoItem: controladores[2].text,
                      tr: controladores[3].text,
                      conservacao: controladores[4].text,
                      valorBem: double.parse(controladores[5].text.replaceAll(',', '.')),
                      oc: checkboxes[0],
                      qb: checkboxes[1],
                      ne: checkboxes[2],
                      sp: checkboxes[3]
                    ) 
                  );

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