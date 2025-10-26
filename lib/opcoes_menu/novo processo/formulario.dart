part of 'novo_processo.dart';

class _CampoTexto extends StatelessWidget{
  final String nome;
  final TextEditingController controlador;
  final String? Function(String?)? validacao;
  const _CampoTexto({super.key, required this.nome, required this.controlador, required this.validacao});

  static String? checarVazio(String? texto){
    if(texto == ''){
       return 'Campo deve ser preenchido.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}

class _CampoTextoAutocomplete extends StatefulWidget{
  final String nome;
  final TextEditingController controlador;
  final Future<void> Function(List<String>) listarPossibilidades; 
  const _CampoTextoAutocomplete({super.key, required this.nome, required this.controlador, required this.listarPossibilidades});

  @override
  State<_CampoTextoAutocomplete> createState() => _CampoTextoAutocompleteState();
}

class _CampoTextoAutocompleteState extends State<_CampoTextoAutocomplete> {
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
                  ('${widget.nome}   '),
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
            )
          )
        ],),
        SizedBox(height:30)
    ]);
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
      onPressed: funcao,
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all<Size>(Size(90, 60)),
      ),
      child: Text("Enviar"),
    );
  }
}

