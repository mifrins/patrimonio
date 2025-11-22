class Processo {
  DateTime data;
  String responsavel;
  String tipo;
  String descricao;
  String sala;

  Processo({
    required this.data,
    required this.responsavel,
    required this.tipo,
    required this.descricao,
    required this.sala,
  });

  Map<String, dynamic> paraMap() {
    return {
      'data': data.toIso8601String(),
      'responsavel': responsavel,
      'tipo': tipo,
      'descricao': descricao,
      'sala': sala,
    };
  }

  factory Processo.deMap(Map<String, dynamic> mapa) {
    return Processo(
      data: DateTime.parse(mapa['data']),
      responsavel: mapa['responsavel'],
      tipo: mapa['tipo'],
      descricao: mapa['descricao'],
      sala: mapa['sala'],
    );
  }
}