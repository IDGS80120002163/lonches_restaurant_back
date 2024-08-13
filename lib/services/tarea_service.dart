import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurante/models/tarea.dart';

Future<List<Tarea>> fetchTareas() async {
  final response = await http.get(Uri.parse('http://localhost:5130/api/Tareas/ListaTareas'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((task) => Tarea.fromJson(task)).toList();
  } else {
    throw Exception('Error al cargar las tareas');
  }
}

Future<Tarea> agregarTarea(String nombre) async {
  final response = await http.post(
    Uri.parse('http://localhost:5130/api/Tareas/AgregarTarea'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, String>{
      'nombre': nombre,
    }),
  );

  if (response.statusCode == 200) {
    return Tarea.fromJson(json.decode(response.body));
  } else {
    throw Exception('Error al agregar la tarea');
  }
}

Future<Tarea> actualizarTarea(int id, String nombre) async {
  final response = await http.put(
    Uri.parse('http://localhost:5130/api/Tareas/ModificarTarea/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, String>{
      'nombre': nombre,
    }),
  );

  if (response.statusCode == 200) {
    return Tarea.fromJson(json.decode(response.body));
  } else {
    throw Exception('Error al actualizar la tarea');
  }
}

