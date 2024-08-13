import 'package:flutter/material.dart';
import 'package:restaurante/models/mesa.dart';
import 'package:restaurante/services/limpieza_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LimpiezaPage extends StatefulWidget {
  const LimpiezaPage({super.key});

  @override
  _LimpiezaPageState createState() => _LimpiezaPageState();
}

class _LimpiezaPageState extends State<LimpiezaPage> {
  late Future<List<Mesa>> futureMesas;
  late LimpiezaService _limpiezaService;

  @override
  void initState() {
    super.initState();
    _limpiezaService = LimpiezaService();
    futureMesas = _cargarMesas();
  }

  Future<List<Mesa>> _cargarMesas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idEmpleado = prefs.getInt('id_empleado') ?? 0;
    return _limpiezaService.fetchMesasAsignadas(idEmpleado);
  }

  Future<void> _cambiarEstatusLimpieza(int idMesa) async {
    try {
      await _limpiezaService.limpiarMesa(idMesa); // Cambiar el estatus a 5 (Limpieza)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mesa modificada exitosamente')),
      );
      setState(() {
        futureMesas = _cargarMesas(); // Refrescar la lista de mesas
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al modificar la mesa: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesas de Limpieza'),
      ),
      body: FutureBuilder<List<Mesa>>(
        future: futureMesas,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, // Número de contenedores por fila
                childAspectRatio: 3 / 2, // Proporción de aspecto de los contenedores
                crossAxisSpacing: 8.0, // Espacio horizontal entre los contenedores
                mainAxisSpacing: 8.0, // Espacio vertical entre los contenedores
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final mesa = snapshot.data![index];
                return Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 89, 8, 155), // Fondo actualizado
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Mesa ${mesa.numMesa}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Estatus: ${mesa.estatus}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                            onPressed: () {
                              _cambiarEstatusLimpieza(mesa.idMesa); // Cambia el estatus de la mesa
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
