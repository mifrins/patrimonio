part of 'novo_processo.dart';

class CampoTexto extends StatelessWidget{
  final String nome;
  final TextEditingController controlador;
  final String? Function(String?)? validacao;
  const CampoTexto({super.key, required this.nome, required this.controlador, required this.validacao});

  static String? checarVazio(String? texto){
    if(texto == ''){
       return 'Campo deve ser preenchido.';
    }
    return null;
  }

  static String? checarNPatrimonio(String? texto){
    if(texto == ''){
       return 'Campo deve ser preenchido.';
    }
    return null;
  }

/*   static String? checarSalaExistente(String? texto){

    if(texto == ''){
       return 'Campo deve ser preenchido.';
    }

    if(listarSalas().then((listaDeSalas){
      if(listaDeSalas.contains(texto)){
        return true;
      }else{
        return false;
      }
    })){
      return 'Sala não existente.';
    }
  
    return null;
  } */


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 30,
      height: 75,
      child:
        TextFormField(
          decoration: InputDecoration(
            labelText: nome,
            filled: true,
          ),
          controller: controlador,
          validator: validacao,
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
      onPressed: funcao,
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all<Size>(Size(90, 60)),
      ),
      child: Text("Enviar"),
    );
  }
}

