class Producto{
  final int idProducto;
  final String nombre;
  final double precio;
  final int estatus;

  Producto({
    required this.idProducto,
    required this.nombre,
    required this.precio,
    required this.estatus
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['idProducto'] ?? 0,
      nombre: json['nombre'] ?? 'Sin nombre',
      precio: json['precio'] ?? 0,
      estatus: json['estatus'] ?? 0,
    );
  }
}