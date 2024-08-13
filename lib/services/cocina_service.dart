import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:restaurante/models/pedido.dart';
import 'package:restaurante/models/pedido_detalles.dart';

class CocinaService {

  Future<List<Pedido>> obtenerPedidos() async {
    final url = Uri.parse('http://localhost:5112/api/Cocina/ListaPedidos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Pedido.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los pedidos');
    }
  }

  Future<List<Pedido_Detalles>> obtenerDetallesPedidos(int id_comanda) async {
    final url = Uri.parse('http://localhost:5112/api/Cocina/ListaPedidosDetallada/$id_comanda');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Pedido_Detalles.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los detalles de los pedidos');
    }
  }

  Future<void> cocinarPedido(int id_comanda, int id_empleado) async {
    final response = await http.put(
      Uri.parse('http://localhost:5112/api/Cocina/CocinarPedido/$id_comanda/$id_empleado'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al modificar el estatus de la Mesa');
    }
  }

  Future<void> entregarPedido(int id_comanda, int idMesa) async {
    final response = await http.put(
      Uri.parse('http://localhost:5112/api/Cocina/EntregarPedido/$id_comanda/$idMesa'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al modificar el estatus de la Mesa');
    }
  }

}
