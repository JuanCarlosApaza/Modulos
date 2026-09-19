import 'package:flutter/material.dart';
import '../../../backend/src/datasources/venta_datasource_impl.dart';
import '../../../backend/src/models/venta_dto.dart';

class VentasController extends ChangeNotifier {
  final VentaDatasourceImpl _datasource;

  List<VentaDto> _ventas = [];
  bool _isLoading = true;
  String? _error;

  List<VentaDto> get ventas => _ventas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  VentasController({VentaDatasourceImpl? datasource})
      : _datasource = datasource ?? VentaDatasourceImpl();

  Future<void> cargarVentas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _ventas = await _datasource.obtenerTodos();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> crearVenta(VentaDto venta) async {
    await _datasource.crear(venta);
    await cargarVentas();
  }

  Future<void> eliminarVenta(String id) async {
    await _datasource.eliminar(id);
    await cargarVentas();
  }
}
