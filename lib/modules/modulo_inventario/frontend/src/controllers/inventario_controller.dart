import 'package:flutter/material.dart';
import '../../../backend/src/datasources/inventario_datasource_impl.dart';
import '../../../backend/src/models/inventario_dto.dart';

class InventarioController extends ChangeNotifier {
  final InventarioDatasourceImpl _datasource;

  List<InventarioDto> _inventarioItems = [];
  List<InventarioDto> _stockBajoItems = [];
  List<MovimientoInventarioDto> _movimientos = [];
  bool _isLoading = true;
  String? _error;
  String _filtroVista = 'stock';

  List<InventarioDto> get inventarioItems => _inventarioItems;
  List<InventarioDto> get stockBajoItems => _stockBajoItems;
  List<MovimientoInventarioDto> get movimientos => _movimientos;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get filtroVista => _filtroVista;

  InventarioController({InventarioDatasourceImpl? datasource})
      : _datasource = datasource ?? InventarioDatasourceImpl();

  void setFiltroVista(String filtro) {
    _filtroVista = filtro;
    notifyListeners();
  }

  Future<void> cargarDatos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      if (_filtroVista == 'stock') {
        _inventarioItems = await _datasource.obtenerTodos();
      } else if (_filtroVista == 'bajo') {
        _stockBajoItems = await _datasource.obtenerStockBajo();
      } else {
        _movimientos = await _datasource.obtenerTodosMovimientos();
      }
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> actualizarInventario(InventarioDto item) async {
    await _datasource.actualizar(item);
    await cargarDatos();
  }

  Future<void> eliminarInventario(String id) async {
    await _datasource.eliminar(id);
    await cargarDatos();
  }

  Future<void> registrarMovimiento({
    required String productoId,
    required String tipo,
    required int cantidad,
    String? descripcion,
    required String usuarioId,
  }) async {
    await _datasource.registrarMovimiento(
      productoId: productoId,
      tipo: tipo,
      cantidad: cantidad,
      descripcion: descripcion,
      usuarioId: usuarioId,
    );
    await cargarDatos();
  }
}
