import 'package:flutter/material.dart';
import 'package:restaurante/services/caja_service.dart';
import 'package:restaurante/services/cocina_service.dart';
import 'package:restaurante/models/pedido.dart';
import 'package:restaurante/models/pedido_detalles.dart';
import 'package:restaurante/models/venta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CajaPage extends StatefulWidget {
  @override
  _CajaPageState createState() => _CajaPageState();
}

class _CajaPageState extends State<CajaPage> {
  late Future<List<Pedido>> futurePedidos;
  late CocinaService _cocinaService;
  late CajaService _cajaService;
  double _totalPrecio = 0.0;

  int _idEmpleado = 0;

  @override
  void initState() {
    super.initState();
    _cargarIdEmpleado();
    _cocinaService = CocinaService();
    _cajaService = CajaService();
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

  void venderPedido(int id_cliente, int idComanda, int idMesa) async {
    try {
      final venta = Venta(
        idEmpleado: _idEmpleado,
        idCliente: id_cliente,
        idComanda: idComanda,
        fecha: DateTime.now(),
      );

      final respuesta = await _cajaService.venderProducto(venta, idMesa);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Venta completada: $respuesta'),
      ));
      setState(() {
        futurePedidos = _cocinaService.obtenerPedidos(); // Refrescar la lista de pedidos
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al completar la venta.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caja'),
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
                crossAxisCount: 3,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 7,
                mainAxisSpacing: 7,
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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
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
                          Expanded(
                            child: FutureBuilder<List<Pedido_Detalles>>(
                              future: obtenerDetalles(pedido.idComanda),
                              builder: (context, detallesSnapshot) {
                                if (detallesSnapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (detallesSnapshot.hasError) {
                                  return Center(child: Text('Error: ${detallesSnapshot.error}'));
                                } else if (!detallesSnapshot.hasData || detallesSnapshot.data!.isEmpty) {
                                  return Center(child: Text('No hay detalles para este pedido.'));
                                } else {
                                  _totalPrecio = detallesSnapshot.data!.fold(0.0, (sum, detalle) {
                                    return sum + detalle.precio_unitario * detalle.cantidad_pedida;
                                  });

                                  return Column(
                                    children: [
                                      Expanded(
                                        child: ListView(
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
                                                    'Producto: ${detalle.nombre_producto}, Cantidad: ${detalle.cantidad_pedida}, Precio: ${detalle.precio_unitario * detalle.cantidad_pedida}',
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.shopping_cart),
                                            color: Colors.white,
                                            onPressed: () => venderPedido(pedido.idCliente, pedido.idComanda, pedido.idMesa),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Total: \$$_totalPrecio',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
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
