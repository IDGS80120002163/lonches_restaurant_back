class Venta {
  final int idEmpleado;
  final int idCliente;
  final int idComanda;
  final DateTime fecha;

  Venta({
    required this.idEmpleado,
    required this.idCliente,
    required this.idComanda,
    required this.fecha,
  });

  // Método para convertir un JSON a una instancia de Venta
  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      idEmpleado: json['idEmpleado'],
      idCliente: json['idCliente'],
      idComanda: json['idComanda'],
      fecha: DateTime.parse(json['fecha']),
    );
  }

  // Método para convertir una instancia de Venta a JSON
  Map<String, dynamic> toJson() {
    return {
      'idEmpleado': idEmpleado,
      'idCliente': idCliente,
      'idComanda': idComanda,
      'fecha': fecha.toIso8601String(),
    };
  }
}
