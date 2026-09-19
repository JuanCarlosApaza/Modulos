import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'modules/modulo_dashboard/frontend/screens/dashboard_screen.dart';
import 'modules/modulo_usuarios/frontend/src/screens/usuarios_screen.dart';
import 'modules/modulo_producto/frontend/src/screens/productos_screen.dart';
import 'modules/modulo_cliente/frontend/src/screens/clientes_screen.dart';
import 'modules/modulo_venta/frontend/src/screens/ventas_screen.dart';
import 'modules/modulo_citas/frontend/src/screens/citas_screen.dart';
import 'modules/modulo_inventario/frontend/src/screens/inventario_screen.dart';
import 'modules/modulo_reportes/frontend/screens/reportes_screen.dart';
import 'modules/modulo_notificaciones/frontend/src/screens/notificaciones_screen.dart';
import 'modules/modulo_configuracion/frontend/src/screens/configuracion_screen.dart';

void main() {
  runApp(const AeuxDashboardApp());
}

class AeuxDashboardApp extends StatelessWidget {
  const AeuxDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AeuxGlobal Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.pageBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.brandGreen,
          primary: AppColors.brandGreen,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onSelect(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        return DashboardScreen(selectedNav: _selectedIndex, onNavSelect: _onSelect);
      case 1:
        return UsuariosScreen(selectedNav: _selectedIndex, onNavSelect: _onSelect);
      case 2:
        return ProductosScreen(selectedNav: _selectedIndex, onNavSelect: _onSelect);
      case 3:
        return ClientesScreen(selectedNav: _selectedIndex, onNavSelect: _onSelect);
      case 4:
        return VentasScreen(selectedNav: _selectedIndex, onNavSelect: _onSelect);
      case 5:
        return CitasScreen(selectedNav: _selectedIndex, onNavSelect: _onSelect);
      case 6:
        return InventarioScreen(selectedNav: _selectedIndex, onNavSelect: _onSelect);
      case 7:
        return ReportesScreen(selectedNav: _selectedIndex, onNavSelect: _onSelect);
      case 8:
        return NotificacionesScreen(selectedNav: _selectedIndex, onNavSelect: _onSelect);
      case 9:
        return ConfiguracionScreen(selectedNav: _selectedIndex, onNavSelect: _onSelect);
      default:
        return DashboardScreen(selectedNav: _selectedIndex, onNavSelect: _onSelect);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildScreen();
  }
}
