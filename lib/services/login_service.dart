import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaurante/pages/cocina_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurante/models/usuario.dart';
import 'package:restaurante/pages/empleado_page.dart';
import 'package:restaurante/pages/caja_page.dart';
import 'package:restaurante/pages/host_page.dart';
import 'package:restaurante/pages/limpieza_page.dart';
import 'package:restaurante/pages/mesero_page.dart';

class LoginService {
  Future<Empleado?> login(BuildContext context, String email, String contrasenia) async {
    // Codificar el email y la contraseña
    final encodedEmail = Uri.encodeComponent(email);
    final encodedContrasenia = Uri.encodeComponent(contrasenia);

    final url = Uri.parse('http://localhost:5112/api/Login/Login/$encodedEmail&$encodedContrasenia');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final empleado = Empleado.fromJson(jsonData);

      // Guardar id_empleado y num_rol en almacenamiento local
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('id_empleado', empleado.idEmpleado);
      await prefs.setInt('num_rol', empleado.numRol);

      // Navegar según el num_rol
      if (empleado.numRol == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmpleadosPage()),
        );
      } else 
      if (empleado.numRol == 2){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HostPage()),
        );
      } else 
      if (empleado.numRol == 3){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MeseroPage()),
        );
      } else 
      if (empleado.numRol == 4){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CocinaPage()),
        );
      } else 
      if (empleado.numRol == 5){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LimpiezaPage()),
        );
      } else 
      if (empleado.numRol == 6){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CajaPage()),
        );
      }

      return empleado;
    } else {
      return null;
    }
  }
}
