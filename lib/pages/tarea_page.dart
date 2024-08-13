import 'package:flutter/material.dart';
import 'package:restaurante/services/tarea_service.dart';
import 'package:restaurante/models/tarea.dart';

class TareasPage extends StatefulWidget {
  const TareasPage({super.key});

  @override
  _TareasPageState createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  late Future<List<Tarea>> futureTareas;
  final TextEditingController _nombreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureTareas = fetchTareas();
  }

  void _agregarTarea() async {
    if (_nombreController.text.isNotEmpty) {
      try {
        await agregarTarea(_nombreController.text);
        setState(() {
          futureTareas = fetchTareas(); // Actualizar la lista de tareas
        });
        _nombreController.clear(); // Limpiar el campo del formulario
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void _actualizarTarea(int id, String nombreActual) async {
    _nombreController.text = nombreActual; // Pre-fill the current name

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Actualizar Tarea'),
          content: TextField(
            controller: _nombreController,
            decoration:
                const InputDecoration(labelText: 'Nuevo nombre de la tarea'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (_nombreController.text.isNotEmpty) {
                  try {
                    await actualizarTarea(id, _nombreController.text);
                    _nombreController.clear(); // Clear the form field

                    // Update UI before closing the dialog
                    setState(() {
                      futureTareas = fetchTareas(); // Refetch tasks
                    });

                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error: $e');
                  }
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tareas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre de la tarea',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _agregarTarea,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: FutureBuilder<List<Tarea>>(
                future: futureTareas,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Nombre')),
                        DataColumn(
                            label: Text(
                                'Acciones')), // Nueva columna para acciones
                      ],
                      rows: snapshot.data!.map((tarea) {
                        return DataRow(cells: [
                          DataCell(Text(tarea.id.toString())),
                          DataCell(Text(tarea.nombre.toString())),
                          DataCell(Row(
                            // Celdas para los botones de acción
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _actualizarTarea(tarea.id, tarea.nombre);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Funcionalidad de eliminar aquí
                                },
                              ),
                            ],
                          )),
                        ]);
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
