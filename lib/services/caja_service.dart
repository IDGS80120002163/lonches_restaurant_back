import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurante/models/venta.dart';

class CajaService{
  Future<String> venderProducto(Venta venta, int idMesa) async {
    final url =
        Uri.parse('http://localhost:5112/api/Caja/VenderPedido/$idMesa');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(venta);
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al ordenar la comida');
    }
  }
}