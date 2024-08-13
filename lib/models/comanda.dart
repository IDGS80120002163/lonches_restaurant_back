class Comanda {
  final int idCliente;
  final int idMesa;
  final int estatus;
  final int idEmpleado;
  final List<ComandaDetalle> detallesComanda;
  final List<Produccion> producciones;

  Comanda({
    required this.idCliente,
    required this.idMesa,
    required this.estatus,
    required this.idEmpleado,
    this.detallesComanda = const [],
    this.producciones = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'idCliente': idCliente,
      'idMesa': idMesa,
      'estatus': estatus,
      'idEmpleado': idEmpleado,
      'detallesComanda': detallesComanda.map((detalle) => detalle.toJson()).toList(),
      'producciones': producciones.map((produccion) => produccion.toJson()).toList(),
    };
  }
}

class ComandaDetalle {
  final int idProducto;
  final int cantidadPedida;
  final double precioUnitario;
  final String observaciones;

  ComandaDetalle({
    required this.idProducto,
    required this.cantidadPedida,
    required this.precioUnitario,
    required this.observaciones,
  });

  Map<String, dynamic> toJson() {
    return {
      'idProducto': idProducto,
      'cantidadPedida': cantidadPedida,
      'precioUnitario': precioUnitario,
      'observaciones': observaciones,
    };
  }
}

class Produccion {
  final int idEmpleado;
  final DateTime fecha;

  Produccion({
    required this.idEmpleado,
    required this.fecha,
  });

  Map<String, dynamic> toJson() {
    return {
      'idEmpleado': idEmpleado,
      'fecha': fecha.toIso8601String(),
    };
  }
}
