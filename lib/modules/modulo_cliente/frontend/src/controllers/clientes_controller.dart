import 'package:flutter/material.dart';
import '../../../backend/src/datasources/cliente_datasource_impl.dart';
import '../../../backend/src/models/cliente_dto.dart';

class ClientesController extends ChangeNotifier {
  final ClienteDatasourceImpl _datasource;

  List<ClienteDto> _clientes = [];
  bool _isLoading = true;
  String? _error;

  List<ClienteDto> get clientes => _clientes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ClientesController({ClienteDatasourceImpl? datasource})
      : _datasource = datasource ?? ClienteDatasourceImpl();

  Future<void> cargarClientes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _clientes = await _datasource.obtenerTodos();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> crearCliente(ClienteDto cliente) async {
    await _datasource.crear(cliente);
    await cargarClientes();
  }

  Future<void> actualizarCliente(ClienteDto cliente) async {
    await _datasource.actualizar(cliente);
    await cargarClientes();
  }

  Future<void> eliminarCliente(String id) async {
    await _datasource.eliminar(id);
    await cargarClientes();
  }
}
