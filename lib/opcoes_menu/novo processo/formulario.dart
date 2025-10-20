import 'package:flutter/material.dart';


class CampoTexto extends StatelessWidget{
  final String nome;
  final TextEditingController controlador;
  const CampoTexto({super.key, required this.nome, required this.controlador});

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

class CampoCheckBox extends StatefulWidget{
  final String nome;
  final Function(bool) setter;
  const CampoCheckBox({required this.nome, required this.setter});

  @override
  State<CampoCheckBox> createState() => _CampoCheckBoxState();
}

class _CampoCheckBoxState extends State<CampoCheckBox> {
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

class BotaoEnviar extends StatelessWidget{
  final void Function() funcao;
  const BotaoEnviar({super.key, required this.funcao});
  
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