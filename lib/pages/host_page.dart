import 'package:flutter/material.dart';
import 'package:restaurante/models/mesa.dart';
import 'package:restaurante/services/host_service.dart';

class HostPage extends StatefulWidget {
  const HostPage({super.key});

  @override
  _HostPageState createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  late Future<List<Mesa>> futureMesas;
  late HostService _hostService;
  final TextEditingController _nombreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _hostService = HostService(); // Crear una instancia del servicio
    futureMesas = _hostService.fetchMesas(); // Llamar al método desde la instancia del servicio
  }

  Future<void> _mostrarDialogoAsignarMesa(int idMesa) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Usuario debe tocar un botón para cerrar el diálogo
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Asignar Mesa'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Ingrese el nombre del cliente:'),
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(hintText: 'Nombre del cliente'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Asignar'),
              onPressed: () async {
                final String nombre = _nombreController.text;
                try {
                  final Mesa mesa = await _hostService.asignarMesa(nombre, idMesa, 2);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mesa asignada exitosamente')),
                  );
                  Navigator.of(context).pop(); // Cerrar el diálogo
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al asignar la mesa: $e')),
                  );
                }
                setState(() {
                  futureMesas = _hostService.fetchMesas();//refrescar las mesas
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _cambiarEstatusPedido(int idMesa) async {
    try {
      await _hostService.modificarMesa(idMesa, 3); // Cambiar el estatus a 3 (Pedido)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mesa modificada exitosamente')),
      );
      setState(() {
        futureMesas = _hostService.fetchMesas(); // Refrescar la lista de mesas
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al modificar la mesa: $e')),
      );
    }
  }

  Future<void> _cambiarEstatusComiendo(int idMesa) async {
    try {
      await _hostService.modificarMesa(idMesa, 4); // Cambiar el estatus a 4 (Comiendo)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mesa modificada exitosamente')),
      );
      setState(() {
        futureMesas = _hostService.fetchMesas(); // Refrescar la lista de mesas
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al modificar la mesa: $e')),
      );
    }
  }

  Future<void> _cambiarEstatusLimpieza(int idMesa) async {
    try {
      await _hostService.modificarMesa(idMesa, 5); //Cambiar el estatus a 5 (Limpieza)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mesa modificada exitosamente')),
      );
      setState(() {
        futureMesas = _hostService.fetchMesas(); //Refrescar la lista de mesas
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al modificar la mesa: $e')),
      );
    }
  }

  Future<void> _cambiarEstatusLibre(int idMesa) async {
    try {
      await _hostService.modificarMesa(idMesa, 1); // Cambiar el estatus a 1 (Libre)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mesa modificada exitosamente')),
      );
      setState(() {
        futureMesas = _hostService.fetchMesas(); // Refrescar la lista de mesas
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
        title: const Text('Lista de Mesas'),
      ),
      body: FutureBuilder<List<Mesa>>(
        future: futureMesas,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              //Esto lo vi en internet y chatgpt me enseño a usarlo
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
                    color: Color.fromARGB(255, 8, 145, 155),
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
                            icon: const Icon(Icons.person_add, color: Colors.white),
                            onPressed: () {
                              _mostrarDialogoAsignarMesa(mesa.idMesa);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.list, color: Colors.white),
                            onPressed: () {
                              _cambiarEstatusPedido(mesa.idMesa); //Modificar mesa con estatus 3 (Pedido)
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.local_dining, color: Colors.white),
                            onPressed: () {
                              _cambiarEstatusComiendo(mesa.idMesa); //Modificar mesa con estatus 4 (Comiendo)
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.cleaning_services, color: Colors.white),
                            onPressed: () {
                              _cambiarEstatusLimpieza(mesa.idMesa); //Modificar mesa con estatus 5 (Limpieza)
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                            onPressed: () {
                              _cambiarEstatusLibre(mesa.idMesa); //Modificar mesa con estatus 1 (Libre)
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
