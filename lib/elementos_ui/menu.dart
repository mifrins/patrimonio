import 'package:flutter/material.dart';

class OpcaoMenu extends StatelessWidget{
  final String texto;
  final VoidCallback rotaConstrutorPagina;
  const OpcaoMenu(this.texto, this.rotaConstrutorPagina);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: rotaConstrutorPagina,
          style: ButtonStyle(
            fixedSize: WidgetStateProperty.all<Size>(Size(MediaQuery.sizeOf(context).width - 40, 80)),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          ),
          child: Text(texto, style: TextStyle( fontSize: 20)),
        ),
        SizedBox(height: 7),   
      ]
    );
  }
}