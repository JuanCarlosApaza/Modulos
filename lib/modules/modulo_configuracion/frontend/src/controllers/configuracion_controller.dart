import 'package:flutter/material.dart';
import '../../../backend/src/datasources/configuracion_datasource_impl.dart';
import '../../../backend/src/models/configuracion_dto.dart';

class ConfiguracionController extends ChangeNotifier {
  final ConfiguracionDatasourceImpl _datasource;

  List<ConfiguracionDto> _configuraciones = [];
  bool _isLoading = true;
  String? _error;

  List<ConfiguracionDto> get configuraciones => _configuraciones;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ConfiguracionController({ConfiguracionDatasourceImpl? datasource})
      : _datasource = datasource ?? ConfiguracionDatasourceImpl();

  Future<void> cargarConfiguraciones() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _configuraciones = await _datasource.obtenerTodas();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> crearConfiguracion(ConfiguracionDto configuracion) async {
    await _datasource.crear(configuracion);
    await cargarConfiguraciones();
  }

  Future<void> actualizarConfiguracion(ConfiguracionDto configuracion) async {
    await _datasource.actualizar(configuracion);
    await cargarConfiguraciones();
  }

  Future<void> eliminarConfiguracion(String id) async {
    await _datasource.eliminar(id);
    await cargarConfiguraciones();
  }
}
