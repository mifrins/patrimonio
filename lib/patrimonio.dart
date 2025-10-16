class Patrimonio {
  // informacoes do patrimonio
  String nPatrimonio;
  String descricaoDoItem;
  String tr;
  String conservacao;
  double valorBem;
  bool oc;
  bool qb;
  bool ne;
  bool sp;
  
  // descricao incluida no qrcode 
  String descricaoQr;

  // construtor da classe
  Patrimonio({
    required this.nPatrimonio, 
    required this.descricaoDoItem,
    required this.tr,
    required this.conservacao,
    required this.valorBem,
    required this.oc,
    required this.qb,
    required this.ne,
    required this.sp,
    this.descricaoQr = "",
  });

  Map<String, dynamic> paraMap(){
    return {
      'nPatrimonio': nPatrimonio,
      'descricaoDoItem': descricaoDoItem,
      'tr': tr,
      'conservacao': conservacao,
      'valorBem': valorBem,
      'oc': oc,
      'qb': qb,
      'ne': ne,
      'sp': sp,
    };
  }
}