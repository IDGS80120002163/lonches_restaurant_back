class Empleado {
  final int idEmpleado;
  final String nombre;
  final String apePaterno;
  final String apeMaterno;
  final String email;
  final int numRol;
  final String rol;

  Empleado({
    required this.idEmpleado,
    required this.nombre,
    required this.apePaterno,
    required this.apeMaterno,
    required this.email,
    required this.numRol,
    required this.rol,
  });

  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      idEmpleado: json['idEmpleado'],
      nombre: json['nombre'],
      apePaterno: json['apePaterno'],
      apeMaterno: json['apeMaterno'],
      email: json['email'],
      numRol: json['num_Rol'],  // Nota: Asegúrate de que esto coincide con el JSON devuelto
      rol: json['rol'],
    );
  }
}
