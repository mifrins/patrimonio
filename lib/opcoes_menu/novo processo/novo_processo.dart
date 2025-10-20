import 'package:flutter/material.dart';
import 'package:patrimonio/patrimonio.dart';
import '../operacoes_banco_de_dados.dart';
import 'formulario.dart';


class _CampoTexto extends StatelessWidget{
  final String nome;
  final TextEditingController controlador;
  const _CampoTexto({super.key, required this.nome, required this.controlador});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 30,
      height: 60,
      child:
        TextField(
          decoration: InputDecoration(
            labelText: nome,
            filled: true,
          ),
          controller: controlador,
        )
    );
  }
}

class _CampoCheckBox extends StatefulWidget{
  final String nome;
  final Function(bool) setter;
  const _CampoCheckBox({required this.nome, required this.setter});

  @override
  State<_CampoCheckBox> createState() => _CampoCheckBoxState();
}

class _CampoCheckBoxState extends State<_CampoCheckBox> {
  bool confirmado = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 60,
      height: 50,
      child: Row(
        children: [
          Text(widget.nome),
          Checkbox(
            checkColor: Colors.white,
            value: confirmado,
            onChanged: (bool? value) {
              setState(() {
                confirmado = value!;
                widget.setter(confirmado);
              });
            },
          ),
        ],
      )
    );
  }
}

class _BotaoEnviar extends StatelessWidget{
  final void Function() funcao;
  const _BotaoEnviar({super.key, required this.funcao});
  
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      child: Text("Enviar"),
      onPressed: funcao,
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all<Size>(Size(90, 60)),
      ),
    );
  }
}

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
          _CampoTexto(nome: 'Sala', controlador: controladores[0]),
          _CampoTexto(nome: 'N° Patrimonio', controlador: controladores[1]),
          _CampoTexto(nome: 'Descrição do Item', controlador: controladores[2]),
          _CampoTexto(nome: 'TR', controlador: controladores[3]),
          _CampoTexto(nome: 'Conservação', controlador: controladores[4]),
          _CampoTexto(nome: 'Valor Bem', controlador: controladores[5]),
          _CampoCheckBox(nome: 'OC', setter: ((valorAtual) => checkboxes[0] = valorAtual)),
          _CampoCheckBox(nome: 'QB', setter: ((valorAtual) => checkboxes[1] = valorAtual)),
          _CampoCheckBox(nome: 'NE', setter: ((valorAtual) => checkboxes[2] = valorAtual)),
          _CampoCheckBox(nome: 'SP', setter: ((valorAtual) => checkboxes[3] = valorAtual)),
          
          _BotaoEnviar(funcao: (){
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
          })
        ],
      )
    );
  }
}


class NovoProcesso extends StatefulWidget {
  final String tipoDeProcesso;

  const NovoProcesso ({super.key, this.tipoDeProcesso = 'Catalogar patrimônio', valorExtraSelecionado});

  @override
  State<NovoProcesso> createState() => NovoProcessoState();
}

class NovoProcessoState extends State<NovoProcesso> {

  // Tipos de processo possíveis
  final List<String> tiposDeProcesso = [
    'Catalogar patrimônio',
    'Editar patrimônio',
    'Apagar patrimônio',
    'Adicionar sala',
    'Editar sala',
    'Apagar sala'
  ];
  
  // Tipo de processo selecionado atualmente
  String? tipoDeProcesso;
  // Conteúdo do formulário para realizar o processo em si
  Widget formulario = Text("Selecione um processo.");

  //Puxar o tipo de processo selecionado no construtor para ser usado aqui
  @override
  void initState() {
    super.initState();
    tipoDeProcesso = widget.tipoDeProcesso;
  }

  
  @override
  Widget build(BuildContext context) {

    // Atribuir valor ao widget de formulário dependendo do tipo de processo escolhido
    switch (tipoDeProcesso){
      case 'Catalogar patrimônio':
        formulario = _CatalogarPatrimonio();
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text('Patrimônio Coltec', style: TextStyle(color:Colors.black),),
          backgroundColor: const Color(0xFF018B7B),
      ),

      body:  Expanded(child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(child: Column(children: [
          SizedBox(height: 7),   

            Row(
              children: [
                SizedBox(width: 20,),
                Text("Tipo de Processo: ", style: TextStyle(fontSize: 17)),

                DropdownButton<String>(
                  value: tipoDeProcesso,
                  // Converter a lista de tipos de processo (List<String>) para List<DropdownMenuItem>
                  items: tiposDeProcesso.map((String tipo){
                    return DropdownMenuItem<String>(
                      value: tipo,
                      child: Text(tipo)
                    );
                  }).toList(),
                  // Quando o valor for alterado, atualizar a página
                  onChanged: (String? processoEscolhido){
                    setState(() {
                      tipoDeProcesso = processoEscolhido;
                    });
                  }
                )
              ]

          ),
          SizedBox(height: 7),   
          formulario
        ]))
      ))
    );
  }
}
