part of 'novo_processo.dart';

class _EditarPatrimonio extends StatefulWidget{
  final String nPatrimonioInicial;
  final bool fecharAposUso;
  const _EditarPatrimonio({this.nPatrimonioInicial = '', this.fecharAposUso = false});
  @override
  State<_EditarPatrimonio> createState() => _EditarPatrimonioState();
}

class _EditarPatrimonioState extends State<_EditarPatrimonio> {
  final _keyFormulario = GlobalKey<FormState>();

  List<TextEditingController> controladores = List.generate(6, (contagem) => TextEditingController());
  List<bool> checkboxes = List.generate(4, (contagem) => false);

  Future<void> carregarDados() async {
    encontrarPatrimonio(controladores[0].text).then((documento){
      if(documento != null){
        documento.get().then((documentoSnapshot){
          Patrimonio dadosPatrimonio = Patrimonio.deMapa(documentoSnapshot.data()!);
          controladores[1].text = dadosPatrimonio.descricaoDoItem;
          controladores[2].text = dadosPatrimonio.tr;
          controladores[3].text = dadosPatrimonio.conservacao;
          controladores[4].text = dadosPatrimonio.valorBem.toString();
          checkboxes[0] = dadosPatrimonio.oc;
          checkboxes[1] = dadosPatrimonio.qb;
          checkboxes[2] = dadosPatrimonio.ne;
          checkboxes[3] = dadosPatrimonio.sp;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controladores[0].text = widget.nPatrimonioInicial;
    carregarDados();
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
          _CampoTexto(nome: 'Descrição do Item', controlador: controladores[1], validacao: _CampoTexto.checarVazio),
          _CampoTexto(nome: 'TR', controlador: controladores[2], validacao: _CampoTexto.checarVazio),
          _CampoTexto(nome: 'Conservação', controlador: controladores[3], validacao: _CampoTexto.checarVazio),
          _CampoTexto(nome: 'Valor Bem', controlador: controladores[4], validacao: _CampoTexto.checarVazio),
          _CampoCheckBox(nome: 'OC', setter: ((valorAtual) => checkboxes[0] = valorAtual)),
          _CampoCheckBox(nome: 'QB', setter: ((valorAtual) => checkboxes[1] = valorAtual)),
          _CampoCheckBox(nome: 'NE', setter: ((valorAtual) => checkboxes[2] = valorAtual)),
          _CampoCheckBox(nome: 'SP', setter: ((valorAtual) => checkboxes[3] = valorAtual)),
          
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
                  // Criar documento para o patrimonio
                  editarPatrimonio(
                    Patrimonio(
                      nPatrimonio: controladores[0].text,
                      descricaoDoItem: controladores[1].text,
                      tr: controladores[2].text,
                      conservacao: controladores[3].text,
                      valorBem: double.parse(controladores[4].text.replaceAll(',', '.')),
                      oc: checkboxes[0],
                      qb: checkboxes[1],
                      ne: checkboxes[2],
                      sp: checkboxes[3]
                    ) 
                  );

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