class Tarea {
  final int id;
  final String nombre;

  Tarea({required this.id, required this.nombre});

  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      id: json['idTarea'] ?? 0,
      nombre: json['nombre'] ?? 'Sin nombre',
    );
  }
}
