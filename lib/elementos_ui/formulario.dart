import 'package:flutter/material.dart';


class CampoTexto extends StatelessWidget{
  final String nome;
  final TextEditingController controlador;
  final String? Function(String?)? validacao;
  const CampoTexto({required this.nome, required this.controlador, required this.validacao});

  static String? checarVazio(String? texto){
    if(texto == ''){
       return 'Campo deve ser preenchido.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 15),
        SizedBox(
          width: MediaQuery.sizeOf(context).width - 30,
          height: 75,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: nome,
              filled: true,
            ),
            controller: controlador,
            validator: validacao,
          )
        ),
      ],
    );
  }
}

class CampoTextoAutocomplete extends StatefulWidget{
  final String nome;
  final TextEditingController controlador;
  final Future<void> Function(List<String>) listarPossibilidades;
  final void Function(String) onSelected;
  const CampoTextoAutocomplete({required this.nome, required this.controlador, required this.listarPossibilidades, required this.onSelected});

  @override
  State<CampoTextoAutocomplete> createState() => CampoTextoAutocompleteState();
}

class CampoTextoAutocompleteState extends State<CampoTextoAutocomplete> {
  List<String> possibilidades = [];

   @override
  void initState() {
    super.initState();
    widget.listarPossibilidades(possibilidades);
  } 

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          SizedBox(
            width: (MediaQuery.sizeOf(context).width - 30)*0.3,
            height: 43,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children:[
                SizedBox(height: 13),            
                Text(
                  ('${widget.nome}  '),
                  style: TextStyle(
                    fontSize: 19,
                  )
                ),
              ]
            )
          ),
          SizedBox(
            width: (MediaQuery.sizeOf(context).width - 30)*0.7,
            height: 43,
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return possibilidades.where((String option) {
                  return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              textEditingController: widget.controlador,
              focusNode: FocusNode(),
              onSelected: widget.onSelected
            )
          )
        ],),
        SizedBox(height:30)
    ]);
  }
}

class CampoCheckBox extends StatefulWidget{
  final String nome;
  final List<bool> variavel;
  const CampoCheckBox({required this.nome, required this.variavel});

  @override
  State<CampoCheckBox> createState() => CampoCheckBoxState();
}

class CampoCheckBoxState extends State<CampoCheckBox> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 60,
      height: 50,
      child: Row(
        children: [
          SizedBox(width: 15),
          Checkbox(
            checkColor: Colors.white,
            value: widget.variavel[0],
            onChanged: (bool? value) {
              setState(() {
                widget.variavel[0] = value!;
              });
            },
          ),
          Text(widget.nome),          
        ],
      )
    );
  }
}

class BotaoConfirmar extends StatelessWidget{
  final void Function() funcao;
  const BotaoConfirmar({required this.funcao});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 50),
        FilledButton(
          onPressed: funcao,
          style: ButtonStyle(
            fixedSize: WidgetStateProperty.all<Size>(Size(120, 60)),
          ),
          child: Text("Confirmar"),
        ),
      ],
    );
  }
}

