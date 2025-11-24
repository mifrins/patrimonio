part of 'novo_processo.dart';

class _MoverPatrimonios extends StatefulWidget{
  const _MoverPatrimonios();
  @override
  State<_MoverPatrimonios> createState() => _MoverPatrimoniosState();
}

class _MoverPatrimoniosState extends State<_MoverPatrimonios> {
  final _keyFormulario = GlobalKey<FormState>();

  TextEditingController salaOriginalControlador = TextEditingController();
  TextEditingController salaDestinoControlador = TextEditingController();

  List<CampoCheckBox> checkboxesPatrimonios = [];
  List<String> nPatrimionioCheckboxes = [];
  List<List<bool>> valoresCheckboxes = [];

  void carregarPatrimonios(){
    listarPatrimoniosSala(salaOriginalControlador.text).then((patrimoniosNaSala){
      setState(() {
        checkboxesPatrimonios.clear();
        for(var contagem = 0; contagem < patrimoniosNaSala.length; contagem++){
          nPatrimionioCheckboxes.add(patrimoniosNaSala[contagem].nPatrimonio);          
          valoresCheckboxes.add([false]);
          checkboxesPatrimonios.add(
            CampoCheckBox(nome: nPatrimionioCheckboxes[contagem], variavel: valoresCheckboxes[contagem])
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPadrao(texto: 'Mover patrimônios'),

      body: RolagemVertical( child: Form(
        key: _keyFormulario,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CampoTextoAutocomplete(
              nome: 'Sala de origem',
              controlador: salaOriginalControlador,
              listarPossibilidades: (listaPossibilidades) async {
                listaPossibilidades.addAll(await listarSalas());
              },
              onSelected: (_){
                carregarPatrimonios();
              },
            ),
            ...checkboxesPatrimonios,
            CampoTextoAutocomplete(
              nome: 'Sala de destino',
              controlador: salaDestinoControlador,
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
                  if(!listaDeSalas.contains(salaOriginalControlador.text)){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Sala de origem não existe'),));
                    return;
                  }
                  if(!listaDeSalas.contains(salaDestinoControlador.text)){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Sala de destino não existe'),));
                    return;
                  }
                  if(salaOriginalControlador.text ==  salaDestinoControlador.text){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Sala de origem e destino não podem ser as mesmas'),));
                    return;
                  }
                  List<String> patrimoniosSelecionados = [];
                  for(var contagem = 0; contagem < checkboxesPatrimonios.length; contagem++){
                    if(valoresCheckboxes[contagem][0]){
                      patrimoniosSelecionados.add(nPatrimionioCheckboxes[contagem]);
                    }
                  }
                  if(patrimoniosSelecionados.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Selecione no mínimo 1 patrimônio'),));
                    return;
                  }
                  criarProcesso(
                    tipo: 'Movimentação de patrimônio',
                    descricao: 'Movimentando ${patrimoniosSelecionados.join(', ')} de ${salaOriginalControlador.text} para ${salaDestinoControlador.text}',
                    sala: salaDestinoControlador.text,
                    deixarPendente: true
                  );

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Processo aberto.'),));
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