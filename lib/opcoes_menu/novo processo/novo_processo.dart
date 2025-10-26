library;

import 'package:flutter/material.dart';
import 'package:patrimonio/patrimonio.dart';
import '../operacoes_banco_de_dados.dart';

part 'formulario.dart';
part 'catalogar_patrimonio.dart';
part 'editar_patrimonio.dart';
part 'apagar_patrimonio.dart';



class NovoProcesso extends StatefulWidget {
  final String tipoDeProcesso;
  final String valorExtraSelecionado;
  final bool fecharAposUso;

  const NovoProcesso ({super.key, this.tipoDeProcesso = 'Catalogar patrimônio', this.valorExtraSelecionado = '', this.fecharAposUso = false});

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
  String? valorExtraSelecionado;
  bool? fecharAposUso;
  // Conteúdo do formulário para realizar o processo em si
  Widget formulario = Text("Selecione um processo.");

  //Puxar o tipo de processo e o valor selecionado no construtor para ser usado aqui
  @override
  void initState() {
    super.initState();
    tipoDeProcesso = widget.tipoDeProcesso;
    valorExtraSelecionado = widget.valorExtraSelecionado;
    fecharAposUso = widget.fecharAposUso;
  }

  
  @override
  Widget build(BuildContext context) {

    // Atribuir valor ao widget de formulário dependendo do tipo de processo escolhido
    switch (tipoDeProcesso){
      case 'Catalogar patrimônio':
        formulario = _CatalogarPatrimonio();
      case 'Apagar patrimônio':
        formulario = _ApagarPatrimonio(nPatrimonioInicial: valorExtraSelecionado!, fecharAposUso:fecharAposUso!);
      case 'Editar patrimônio':
        formulario = _EditarPatrimonio(nPatrimonioInicial: valorExtraSelecionado!, fecharAposUso:fecharAposUso!);
      default:
        formulario = Text('Escolha um processo.');
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text('Patrimônio Coltec', style: TextStyle(color:Colors.black),),
          backgroundColor: const Color(0xFF018B7B),
      ),

      // Configurar página para ter rolagem sem uma barra lateral
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
