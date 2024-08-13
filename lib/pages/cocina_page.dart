import 'package:flutter/material.dart';
import 'package:restaurante/services/cocina_service.dart';
import 'package:restaurante/models/pedido.dart';
import 'package:restaurante/models/pedido_detalles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CocinaPage extends StatefulWidget {
  @override
  _CocinaPageState createState() => _CocinaPageState();
}

class _CocinaPageState extends State<CocinaPage> {
  late Future<List<Pedido>> futurePedidos;
  late CocinaService _cocinaService;

  int _idEmpleado = 0;

  @override
  void initState() {
    super.initState();
    _cargarIdEmpleado();
    _cocinaService = CocinaService();
    futurePedidos = _cocinaService.obtenerPedidos();
  }

  Future<List<Pedido_Detalles>> obtenerDetalles(int idComanda) async {
    return await _cocinaService.obtenerDetallesPedidos(idComanda);
  }

  Future<void> _cargarIdEmpleado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idEmpleado = prefs.getInt('id_empleado') ?? 0;
    });
  }

  void prepararComida(int idComanda) async {
    try {
      await _cocinaService.cocinarPedido(idComanda, _idEmpleado);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('El pedido ha comenzado a prepararse.'),
      ));
      setState(() {
        futurePedidos = _cocinaService.obtenerPedidos(); // Refrescar la lista de pedidos
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al comenzar la preparación.'),
      ));
    }
  }

  void terminarComida(int idComanda, int idMesa) async {
    try {
      await _cocinaService.entregarPedido(idComanda, idMesa);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('La preparación ha sido completada.'),
      ));
      setState(() {
        futurePedidos = _cocinaService.obtenerPedidos(); // Refrescar la lista de pedidos
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al completar la preparación.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cocina'),
      ),
      body: FutureBuilder<List<Pedido>>(
        future: futurePedidos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay pedidos disponibles.'));
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Número de contenedores por fila
                childAspectRatio: 3 / 2, // Proporción de aspecto de los contenedores
                crossAxisSpacing: 7, // Espacio horizontal entre los contenedores
                mainAxisSpacing: 7, // Espacio vertical entre los contenedores
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final pedido = snapshot.data![index];
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 8, 145, 155),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mesa: ${pedido.numMesa}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Cliente: ${pedido.nombreCliente}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Estatus: ${pedido.estatus}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      FutureBuilder<List<Pedido_Detalles>>(
                        future: obtenerDetalles(pedido.idComanda),
                        builder: (context, detallesSnapshot) {
                          if (detallesSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (detallesSnapshot.hasError) {
                            return Center(child: Text('Error: ${detallesSnapshot.error}'));
                          } else if (!detallesSnapshot.hasData || detallesSnapshot.data!.isEmpty) {
                            return Center(child: Text('No hay detalles para este pedido.'));
                          } else {
                            return Column(
                              children: [
                                ExpansionTile(
                                  title: Text(
                                    'Ver Detalles',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  children: detallesSnapshot.data!.map((detalle) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Text(
                                        'Producto: ${detalle.nombre_producto}, Cantidad: ${detalle.cantidad_pedida}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.kitchen),
                                      color: Colors.white,
                                      onPressed: () => prepararComida(pedido.idComanda),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.check_circle),
                                      color: Colors.white,
                                      onPressed: () => terminarComida(pedido.idComanda, pedido.idMesa),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
