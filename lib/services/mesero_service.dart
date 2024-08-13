import 'package:http/http.dart' as http;
import 'package:restaurante/models/cliente.dart';
import 'package:restaurante/models/comanda.dart';
import 'package:restaurante/models/mesa.dart';
import 'package:restaurante/models/producto.dart';
import 'dart:convert';

class MeseroService {
  Future<List<Mesa>> fetchMesasAsignadas(int id_empleado) async {
    final response = await http.get(
        Uri.parse('http://localhost:5112/api/Mesero/ListaMesas/$id_empleado'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => Mesa.fromJson(task)).toList();
    } else {
      throw Exception('Error al cargar las Mesas');
    }
  }

  Future<List<Cliente>> fetchClientesAsignados(
      int idMesa, int id_empleado) async {
    final response = await http.get(Uri.parse(
        'http://localhost:5112/api/Mesero/ObtenerCliente/$idMesa/$id_empleado'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => Cliente.fromJson(task)).toList();
    } else {
      throw Exception('Error al cargar los clientes');
    }
  }

  Future<List<Producto>> fetchProductos() async {
    final response = await http
        .get(Uri.parse('http://localhost:5112/api/Mesero/ListaProductos'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => Producto.fromJson(task)).toList();
    } else {
      throw Exception('Error al cargar los productos');
    }
  }

  Future<String> ordenarComida(Comanda comanda, int idMesa) async {
    final url =
        Uri.parse('http://localhost:5112/api/Mesero/OrdenarComida?idMesa=$idMesa');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(comanda);
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al ordenar la comida');
    }
  }
}
