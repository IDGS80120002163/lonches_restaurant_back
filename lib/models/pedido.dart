class Pedido {
  final int idMesa;
  final int idCliente;
  final String nombreCliente;
  final String numMesa;
  final int idComanda;
  final int numEstatus;
  final String estatus;

  Pedido({
    required this.idMesa,
    required this.idCliente,
    required this.nombreCliente,
    required this.numMesa,
    required this.idComanda,
    required this.numEstatus,
    required this.estatus,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      idCliente: json['id_cliente'] ?? 0,
      idMesa: json['id_mesa'] ?? 0,
      nombreCliente: json['nombre_cliente'] ?? 'Desconocido',
      numMesa: json['num_mesa'] ?? 'Sin número',
      idComanda: json['id_comanda'] ?? 0,
      numEstatus: json['num_estatus'] ?? 0,
      estatus: json['estatus'] ?? 'Desconocido',
    );
  }
}
