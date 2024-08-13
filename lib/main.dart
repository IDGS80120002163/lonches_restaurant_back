import 'package:flutter/material.dart';
import 'package:restaurante/services/login_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
    );
  }
}

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contraseniaController = TextEditingController();
  final LoginService loginService = LoginService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 215, 167, 255),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo and text "Lonches Restaurant"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.orange,
                  child: Icon(
                    Icons.food_bank,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Lonches Restaurant',
                  style: TextStyle(
                    fontSize: 24,
                    color: const Color.fromARGB(255, 6, 112, 126),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            // Input field "Email"
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 6, 112, 126),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 15),
            // Input field "Contraseña"
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 6, 112, 126),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: contraseniaController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 30),
            // Submit button
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final contrasenia = contraseniaController.text;

                final usuario = await loginService.login(context, email, contrasenia);

                if (usuario == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al iniciar sesión')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                child: Text('Iniciar sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
