import 'package:restaurante/models/mesa.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HostService {
  Future<List<Mesa>> fetchMesas() async {
    final response =
        await http.get(Uri.parse('http://localhost:5112/api/Host/ListaMesas'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => Mesa.fromJson(task)).toList();
    } else {
      throw Exception('Error al cargar las Mesas');
    }
  }

  Future<Mesa> asignarMesa(String nombre, int id_mesa, int estatus) async {
    final response = await http.post(
      Uri.parse(
          'http://localhost:5112/api/Host/AsignarMesa/$id_mesa/$estatus'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        'nombre': nombre,
      }),
    );

    if (response.statusCode == 200) {
      return (Mesa.fromJson(json.decode(response.body)));
    } else {
      throw Exception('Error al asignar la Mesa');
    }
  }

  Future<void> modificarMesa(int idMesa, int estatus) async {
    final response = await http.put(
      Uri.parse('http://localhost:5112/api/Host/ModificarMesa/$idMesa/$estatus'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al modificar el estatus de la Mesa');
    }
  }
  
}
