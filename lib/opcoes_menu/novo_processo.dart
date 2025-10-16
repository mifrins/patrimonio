import 'package:flutter/material.dart';
import 'operacoes_banco_de_dados.dart';


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
  const _CampoCheckBox({super.key, required this.nome});

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
              });
            },
          ),
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
  
  // Processo selecionado
  String? tipoDeProcesso;

  //Puxar o tipo de processo selecionado no construtor widget para ser usado nessa classe
  @override
  void initState() {
    super.initState();
    tipoDeProcesso = widget.tipoDeProcesso;
  }

  
  @override
  Widget build(BuildContext context) {
    
    // Declarar lista com os widgets que compõem a tela com o primeiro elemento (dropdown com os tipos de processo)
    List<Widget> elementosPagina = [
      Center(child: 
        DropdownButton<String>(
          value: tipoDeProcesso,
          // Converter a lista de tipos de processo de String para DropdownMenuItem
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
      )
    ];
    // Lista com os controladores de texto
    List<TextEditingController> controladores = [];

    // Popular lista dos widgets dependendo do tipo de processo escolhido
    switch (tipoDeProcesso){
      case 'Catalogar patrimônio':
        controladores = List.generate(6, (contagem) => TextEditingController());
        elementosPagina.add(_CampoTexto(nome: 'Sala', controlador: controladores[0]));
        elementosPagina.add(_CampoTexto(nome: 'N° Patrimonio', controlador: controladores[1]));
        elementosPagina.add(_CampoTexto(nome: 'Descrição do Item', controlador: controladores[2]));
        elementosPagina.add(_CampoTexto(nome: 'TR', controlador: controladores[3]));
        elementosPagina.add(_CampoTexto(nome: 'Conservação', controlador: controladores[4]));
        elementosPagina.add(_CampoTexto(nome: 'Valor Bem', controlador: controladores[5]));
        elementosPagina.add(_CampoCheckBox(nome: 'OC'));
        elementosPagina.add(_CampoCheckBox(nome: 'QB'));
        elementosPagina.add(_CampoCheckBox(nome: 'NE'));
        elementosPagina.add(_CampoCheckBox(nome: 'SP'));
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text('Patrimônio Coltec', style: TextStyle(color:Colors.black),),
          backgroundColor: const Color(0xFF018B7B),
      ),

      body: Column(
        children: elementosPagina
/*         children: [
          DropdownButton<String>(
            value: tipoDeProcesso,
            // Converter a lista de tipos de processo de String para DropdownMenuItem
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
          ),
          _CampoTexto(nome: 'aaaaa', controlador: TextEditingController()),
          _CampoCheckBox(nome: 'nome')
        ] */
      )
    );
  }
}
