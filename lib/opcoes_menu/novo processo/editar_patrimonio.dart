part of 'novo_processo.dart';

class ProcessoEditarPatrimonio extends StatefulWidget{
  final String nPatrimonioInicial;
  final bool fecharAposUso;
  const ProcessoEditarPatrimonio({this.nPatrimonioInicial = '', this.fecharAposUso = false});
  @override
  State<ProcessoEditarPatrimonio> createState() => ProcessoEditarPatrimonioState();
}

class ProcessoEditarPatrimonioState extends State<ProcessoEditarPatrimonio> {
  final _keyFormulario = GlobalKey<FormState>();

  List<TextEditingController> controladores = List.generate(6, (contagem) => TextEditingController());
  List<List<bool>> checkboxes = List.generate(4, (contagem) => [false]);

  Future<void> carregarDadosPatrimonio() async {
    encontrarPatrimonio(controladores[0].text).then((documento){
      if(documento != null){
        documento.get().then((documentoSnapshot){
          setState(() {
            Patrimonio dadosPatrimonio = Patrimonio.deMapa(documentoSnapshot.data()!);
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
    if(widget.nPatrimonioInicial != ''){
      controladores[0].text = widget.nPatrimonioInicial;
      carregarDadosPatrimonio();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPadrao(texto: 'Editar patrimônio'),

      body: RolagemVertical( child: Form(
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
            _CampoTexto(nome: 'Descrição do Item', controlador: controladores[1], validacao: _CampoTexto.checarVazio),
            _CampoTexto(nome: 'TR', controlador: controladores[2], validacao: _CampoTexto.checarVazio),
            _CampoTexto(nome: 'Conservação', controlador: controladores[3], validacao: _CampoTexto.checarVazio),
            _CampoTexto(nome: 'Valor Bem', controlador: controladores[4], validacao: _CampoTexto.checarVazio),
            _CampoCheckBox(nome: 'OC', variavel: checkboxes[0]),
            _CampoCheckBox(nome: 'QB', variavel: checkboxes[1]),
            _CampoCheckBox(nome: 'NE', variavel: checkboxes[2]),
            _CampoCheckBox(nome: 'SP', variavel: checkboxes[3]),

            _BotaoEnviar(funcao: (){
              // Validar formulário
              if(_keyFormulario.currentState!.validate()){
                // Fazer outras verificações antes de criar
                listarTodosPatrimonios().then((listaDePatrimonios){
                  // Checar se o patrimônio existe
                  if(!listaDePatrimonios.contains(controladores[0].text)){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Patrimônio não encontrado.'),));
                      return;
                  }
                  listarSalas().then((listaDeSalas){
                    // Checar se o valor digitado pode ser convertido
                    if(double.tryParse(controladores[4].text.replaceAll(',', '.')) == null){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Valor do bem inválido.'),));
                      return;
                    }
                    // Se chegou até aqui, o patrimônio pode ser editado.
                    editarPatrimonio(
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

                    if(widget.fecharAposUso){
                      Navigator.pop(context);
                    }
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