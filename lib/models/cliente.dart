class Cliente{
  final int idCliente;
  final String nombre;

  Cliente({
    required this.idCliente,
    required this.nombre
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      idCliente: json['idCliente'] ?? 0,
      nombre: json['nombre'] ?? 'Sin nombre',
    );
  }
}