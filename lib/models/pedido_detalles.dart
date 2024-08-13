class Pedido_Detalles{
  final int id_comanda;
  final String num_mesa;
  final int id_producto;
  final String nombre_producto;
  final int cantidad_pedida;
  final String observaciones;
  final double precio_unitario;

  Pedido_Detalles({
    required this.id_comanda,
    required this.num_mesa,
    required this.id_producto,
    required this.nombre_producto,
    required this.cantidad_pedida,
    required this.observaciones,
    required this.precio_unitario
  });

  factory Pedido_Detalles.fromJson(Map<String, dynamic> json) {
    return Pedido_Detalles(
      id_comanda: json['id_comanda'] ?? 0,
      num_mesa: json['num_mesa'] ?? 'Desconocido',
      id_producto: json['id_producto'] ?? 0,
      nombre_producto: json['nombre_producto'] ?? 'Sin número',
      cantidad_pedida: json['cantidad_pedida'] ?? 0,
      observaciones: json['observaciones'] ?? 'Sin observaciones',
      precio_unitario: json['precio_unitario'] ?? 0,
    );
  }
}