import 'package:flutter/material.dart';
import '../screens/clientes_screen.dart';

class ClienteRoutes {
  static const String listar = '/clientes';

  static Map<String, WidgetBuilder> get routes {
    return {
      listar: (context) => ClientesScreen(
        selectedNav: 3,
        onNavSelect: (index) {},
      ),
    };
  }
}
