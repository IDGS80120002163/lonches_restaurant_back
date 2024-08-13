import 'package:flutter/material.dart';
import 'package:restaurante/models/comanda.dart';
import 'package:restaurante/services/mesero_service.dart';
import 'package:restaurante/models/cliente.dart';
import 'package:restaurante/models/mesa.dart';
import 'package:restaurante/models/producto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeseroPage extends StatefulWidget {
  @override
  _MeseroPageState createState() => _MeseroPageState();
}

class _MeseroPageState extends State<MeseroPage> {
  final MeseroService _meseroService = MeseroService();

  List<Mesa> _mesas = [];
  List<Cliente> _clientes = [];
  List<Producto> _productos = [];
  List<Producto> _comanda = [];
  double _totalPrecio = 0.0;

  Mesa? _mesaSeleccionada;
  Cliente? _clienteSeleccionado;
  int _idEmpleado = 0;

  @override
  void initState() {
    super.initState();
    _cargarIdEmpleado();
    _fetchProductos();
  }

  Future<void> _cargarIdEmpleado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idEmpleado = prefs.getInt('id_empleado') ?? 0; //Obtener el id_empleado
    });
    _fetchMesas(); //Cargar las mesas después de obtener el id_empleado
  }

  void _fetchMesas() async {
    try {
      List<Mesa> mesas = await _meseroService.fetchMesasAsignadas(_idEmpleado);
      setState(() {
        _mesas = mesas;
      });
    } catch (e) {
      print('Error al cargar mesas: $e');
    }
  }

  void _fetchClientes(int idMesa) async {
    try {
      List<Cliente> clientes =
          await _meseroService.fetchClientesAsignados(idMesa, _idEmpleado);
      setState(() {
        _clientes = clientes;
      });
    } catch (e) {
      print('Error al cargar clientes: $e');
    }
  }

  void _fetchProductos() async {
    try {
      List<Producto> productos = await _meseroService.fetchProductos();
      setState(() {
        _productos = productos;
      });
    } catch (e) {
      print('Error al cargar productos: $e');
    }
  }

  void _agregarAlCarrito(Producto producto) {
    setState(() {
      _comanda.add(producto);
      _totalPrecio += producto.precio;
    });
  }

  void _removerDelCarrito(Producto producto) {
    setState(() {
      _comanda.remove(producto);
      _totalPrecio -= producto.precio;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mesero')),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 8, 145, 155), // Color del recángulo
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<Mesa>(
                  hint: Text('Selecciona una mesa'),
                  value: _mesaSeleccionada,
                  onChanged: (Mesa? newValue) {
                    setState(() {
                      _mesaSeleccionada = newValue;
                      _fetchClientes(newValue!.idMesa);
                    });
                  },
                  items: _mesas.map<DropdownMenuItem<Mesa>>((Mesa mesa) {
                    return DropdownMenuItem<Mesa>(
                      value: mesa,
                      child: Text(mesa.numMesa),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.0),
                DropdownButton<Cliente>(
                  hint: Text('Selecciona un cliente'),
                  value: _clienteSeleccionado,
                  onChanged: (Cliente? newValue) {
                    setState(() {
                      _clienteSeleccionado = newValue;
                    });
                  },
                  items: _clientes
                      .map<DropdownMenuItem<Cliente>>((Cliente cliente) {
                    return DropdownMenuItem<Cliente>(
                      value: cliente,
                      child: Text(cliente.nombre),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _productos.length,
                    itemBuilder: (context, i) {
                      Producto producto = _productos[i];
                      return ListTile(
                        title: Text(producto.nombre),
                        subtitle:
                            Text('\$${producto.precio.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: Icon(Icons.add_shopping_cart),
                          onPressed: () => _agregarAlCarrito(producto),
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                Text(
                  'Comanda:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _comanda.length,
                    itemBuilder: (context, i) {
                      Producto producto = _comanda[i];
                      return ListTile(
                        title: Text(producto.nombre),
                        subtitle:
                            Text('\$${producto.precio.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_shopping_cart),
                          onPressed: () => _removerDelCarrito(producto),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Total: \$${_totalPrecio.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_clienteSeleccionado != null &&
                        _mesaSeleccionada != null &&
                        _comanda.isNotEmpty) {
                      // Crear la producción
                      final produccion = Produccion(
                        idEmpleado: _idEmpleado,
                        fecha: DateTime.now(),
                      );

                      // Crear la comanda con los detalles y la producción
                      final comanda = Comanda(
                        idCliente: _clienteSeleccionado!.idCliente,
                        idMesa: _mesaSeleccionada!.idMesa,
                        estatus: 1,
                        idEmpleado: _idEmpleado,
                        detallesComanda: _comanda
                            .map((producto) => ComandaDetalle(
                                  idProducto: producto.idProducto,
                                  cantidadPedida:
                                      1, // Puedes cambiar esto según lo necesites
                                  precioUnitario: producto.precio,
                                  observaciones:
                                      "", // Puedes agregar un campo para observaciones
                                ))
                            .toList(),
                        producciones: [produccion], //Añadir la producción
                      );

                      try {
                        //Llamar al servicio para ordenar la comida
                        final respuesta = await MeseroService()
                            .ordenarComida(comanda, _mesaSeleccionada!.idMesa);
                        print('Orden registrada: $respuesta');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('La comida fue pedida.'),
                        ));
                      } catch (e) {
                        print('Error al registrar la orden: $e');
                      }
                    } else {
                      print(
                          'Debe seleccionar un cliente, una mesa y agregar productos a la comanda.');
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant_menu),
                      SizedBox(width: 8.0),
                      Text('Registrar Orden'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      //backgroundColor: Color.fromARGB(255, 215, 167, 255), // Fondo azul
    );
  }
}
