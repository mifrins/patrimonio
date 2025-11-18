part of 'novo_processo.dart';

class ProcessoCatalogarPatrimonio extends StatefulWidget{
  @override
  State<ProcessoCatalogarPatrimonio> createState() => ProcessoCatalogarPatrimonioState();
}

class ProcessoCatalogarPatrimonioState extends State<ProcessoCatalogarPatrimonio> {
  final _keyFormulario = GlobalKey<FormState>();

  List<TextEditingController> controladores = List.generate(6, (contagem) => TextEditingController());
  List<List<bool>> checkboxes = List.generate(4, (contagem) => [false]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPadrao(texto: 'Catalogar patrimônio'),

      body: RolagemVertical( child: Form(
        key: _keyFormulario,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            _CampoTextoAutocomplete(
              nome: 'Sala',
              controlador: controladores[0],
              listarPossibilidades: (listaPossibilidades) async {
                listaPossibilidades.addAll(await listarSalas());
              },
              onSelected: (_){},
            ),
            _CampoTexto(nome: 'N° Patrimonio', controlador: controladores[1], validacao: _CampoTexto.checarVazio),
            _CampoTexto(nome: 'Descrição do Item', controlador: controladores[2], validacao: _CampoTexto.checarVazio),
            _CampoTexto(nome: 'TR', controlador: controladores[3], validacao: _CampoTexto.checarVazio),
            _CampoTexto(nome: 'Conservação', controlador: controladores[4], validacao: _CampoTexto.checarVazio),
            _CampoTexto(nome: 'Valor Bem', controlador: controladores[5], validacao: _CampoTexto.checarVazio),
            _CampoCheckBox(nome: 'OC', variavel: checkboxes[0]),
            _CampoCheckBox(nome: 'QB', variavel: checkboxes[1]),
            _CampoCheckBox(nome: 'NE', variavel: checkboxes[2]),
            _CampoCheckBox(nome: 'SP', variavel: checkboxes[3]),
            
            _BotaoConfirmar(funcao: (){
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
                        oc: checkboxes[0][0],
                        qb: checkboxes[1][0],
                        ne: checkboxes[2][0],
                        sp: checkboxes[3][0]
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
      ))
    );
  }
}