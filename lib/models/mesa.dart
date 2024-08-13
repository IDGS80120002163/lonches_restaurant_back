class Mesa {
  final int idMesa;
  final String numMesa;
  final int num_estatus;
  final String estatus;

  Mesa({
    required this.idMesa,
    required this.numMesa,
    required this.num_estatus,
    required this.estatus,
  });

  factory Mesa.fromJson(Map<String, dynamic> json) {
    return Mesa(
      idMesa: json['idMesa'] ?? 0,
      numMesa: json['numMesa'] ?? 'Sin número',
      num_estatus: json['num_estatus'] ?? 0,
      estatus: json['estatus'] ?? 'Desconocido',
    );
  }
}
