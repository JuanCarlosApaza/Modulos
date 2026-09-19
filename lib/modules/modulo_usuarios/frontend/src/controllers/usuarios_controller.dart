import 'package:flutter/material.dart';
import 'package:modulos/modules/modulo_usuarios/backend/src/datasources/usuario_datasource_impl.dart';
import 'package:modulos/modules/modulo_usuarios/backend/src/models/usuario_dto.dart';

class UsuariosController extends ChangeNotifier {
  final UsuarioDatasourceImpl _datasource;

  List<UsuarioDto> _usuarios = [];
  List<Map<String, String>> _roles = [];
  bool _isLoading = true;
  String? _error;

  List<UsuarioDto> get usuarios => _usuarios;
  List<Map<String, String>> get roles => _roles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  UsuariosController({UsuarioDatasourceImpl? datasource})
      : _datasource = datasource ?? UsuarioDatasourceImpl();

  Future<void> cargarDatos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final results = await Future.wait([_datasource.obtenerTodos(), _datasource.obtenerRoles()]);
      _usuarios = results[0] as List<UsuarioDto>;
      _roles = results[1] as List<Map<String, String>>;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> crearUsuario(UsuarioDto usuario) async {
    await _datasource.crear(usuario);
    await cargarDatos();
  }

  Future<void> actualizarUsuario(UsuarioDto usuario) async {
    await _datasource.actualizar(usuario);
    await cargarDatos();
  }

  Future<void> eliminarUsuario(String id) async {
    await _datasource.eliminar(id);
    await cargarDatos();
  }
}
