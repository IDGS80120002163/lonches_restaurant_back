import 'package:restaurante/models/mesa.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LimpiezaService {
  Future<List<Mesa>> fetchMesasAsignadas(int id_empleado) async {
    final response =
        await http.get(Uri.parse('http://localhost:5112/api/Limpieza/ListaMesas/$id_empleado'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => Mesa.fromJson(task)).toList();
    } else {
      throw Exception('Error al cargar las Mesas');
    }
  }

  Future<void> limpiarMesa(int idMesa) async {
    final response = await http.put(
      Uri.parse('http://localhost:5112/api/Limpieza/LimpiarMesa/$idMesa'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al modificar el estatus de la Mesa');
    }
  }
}
