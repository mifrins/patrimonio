part of 'novo_processo.dart';

class ProcessoEditarPatrimonio extends StatefulWidget{
  final String nPatrimonioEscolhido;
  const ProcessoEditarPatrimonio({required this.nPatrimonioEscolhido});
  @override
  State<ProcessoEditarPatrimonio> createState() => ProcessoEditarPatrimonioState();
}

class ProcessoEditarPatrimonioState extends State<ProcessoEditarPatrimonio> {
  final _keyFormulario = GlobalKey<FormState>();

  List<TextEditingController> controladores = List.generate(6, (contagem) => TextEditingController());
  List<List<bool>> checkboxes = List.generate(4, (contagem) => [false]);

  Future<void> carregarDadosPatrimonio() async {
    encontrarPatrimonio(widget.nPatrimonioEscolhido).then((documento){
      if(documento != null){
        documento.get().then((documentoSnapshot){
          setState(() {
            Patrimonio dadosPatrimonio = Patrimonio.deMapa(documentoSnapshot.data()!);
            controladores[0].text = widget.nPatrimonioEscolhido;
            controladores[1].text = dadosPatrimonio.descricaoDoItem;
            controladores[2].text = dadosPatrimonio.tr;
            controladores[3].text = dadosPatrimonio.conservacao;
            controladores[4].text = dadosPatrimonio.valorBem.toString();
            checkboxes[0][0] = dadosPatrimonio.oc;
            checkboxes[1][0] = dadosPatrimonio.qb;
            checkboxes[2][0] = dadosPatrimonio.ne;
            checkboxes[3][0] = dadosPatrimonio.sp;
          });
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    carregarDadosPatrimonio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPadrao(texto: 'Patrimônio n°${widget.nPatrimonioEscolhido}'),

      body: RolagemVertical( child: Form(
        key: _keyFormulario,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            _CampoTexto(nome: 'N° do patrimônio', controlador: controladores[0], validacao: _CampoTexto.checarVazio),
            _CampoTexto(nome: 'Descrição do item', controlador: controladores[1], validacao: _CampoTexto.checarVazio),
            _CampoTexto(nome: 'TR', controlador: controladores[2], validacao: _CampoTexto.checarVazio),
            _CampoTexto(nome: 'Conservação', controlador: controladores[3], validacao: _CampoTexto.checarVazio),
            _CampoTexto(nome: 'Valor bem', controlador: controladores[4], validacao: _CampoTexto.checarVazio),
            _CampoCheckBox(nome: 'OC', variavel: checkboxes[0]),
            _CampoCheckBox(nome: 'QB', variavel: checkboxes[1]),
            _CampoCheckBox(nome: 'NE', variavel: checkboxes[2]),
            _CampoCheckBox(nome: 'SP', variavel: checkboxes[3]),

            _BotaoConfirmar(funcao: (){
              // Validar formulário
              if(_keyFormulario.currentState!.validate()){
                // Fazer outras verificações antes de criar
                listarTodosPatrimonios().then((listaDePatrimonios){
                  listarSalas().then((listaDeSalas){
                    // Checar se o valor digitado pode ser convertido
                    if(double.tryParse(controladores[4].text.replaceAll(',', '.')) == null){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Valor do bem inválido.'),));
                      return;
                    }
                    // Se chegou até aqui, o patrimônio pode ser editado.
                    editarPatrimonio(
                      widget.nPatrimonioEscolhido,
                      Patrimonio(
                        nPatrimonio: controladores[0].text,
                        descricaoDoItem: controladores[1].text,
                        tr: controladores[2].text,
                        conservacao: controladores[3].text,
                        valorBem: double.parse(controladores[4].text.replaceAll(',', '.')),
                        oc: checkboxes[0][0],
                        qb: checkboxes[1][0],
                        ne: checkboxes[2][0],
                        sp: checkboxes[3][0]
                      ) 
                    );

                    // Mostrar mensagem depois de editar o patrimonio
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Alterações salvas.'),));

                    // Fechar janela de edição do patrimonio
                    Navigator.pop(context);
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