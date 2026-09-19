import 'package:flutter/material.dart';
import '../../../backend/src/datasources/producto_datasource_impl.dart';
import '../../../backend/src/models/producto_dto.dart';

class ProductosController extends ChangeNotifier {
  final ProductoDatasourceImpl _datasource;

  List<ProductoDto> _productos = [];
  bool _isLoading = true;
  String? _error;

  List<ProductoDto> get productos => _productos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ProductosController({ProductoDatasourceImpl? datasource})
      : _datasource = datasource ?? ProductoDatasourceImpl();

  Future<void> cargarProductos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _productos = await _datasource.obtenerTodos();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> crearProducto(ProductoDto producto) async {
    await _datasource.crear(producto);
    await cargarProductos();
  }

  Future<void> actualizarProducto(ProductoDto producto) async {
    await _datasource.actualizar(producto);
    await cargarProductos();
  }

  Future<void> eliminarProducto(String id) async {
    await _datasource.eliminar(id);
    await cargarProductos();
  }
}
