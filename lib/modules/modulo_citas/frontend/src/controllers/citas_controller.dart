import 'package:flutter/material.dart';
import '../../../backend/src/datasources/cita_datasource_impl.dart';
import '../../../backend/src/models/cita_dto.dart';

class CitasController extends ChangeNotifier {
  final CitaDatasourceImpl _datasource;

  List<CitaDto> _citas = [];
  bool _isLoading = true;
  String? _error;
  String _filtroEstado = 'todas';

  List<CitaDto> get citas => _citas;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get filtroEstado => _filtroEstado;

  List<CitaDto> get citasFiltradas {
    if (_filtroEstado == 'todas') return _citas;
    return _citas.where((c) => c.estado == _filtroEstado).toList();
  }

  CitasController({CitaDatasourceImpl? datasource})
      : _datasource = datasource ?? CitaDatasourceImpl();

  void setFiltroEstado(String filtro) {
    _filtroEstado = filtro;
    notifyListeners();
  }

  Future<void> cargarCitas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _citas = await _datasource.obtenerTodos();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> crearCita(CitaDto cita) async {
    await _datasource.crear(cita);
    await cargarCitas();
  }

  Future<void> actualizarCita(CitaDto cita) async {
    await _datasource.actualizar(cita);
    await cargarCitas();
  }

  Future<void> eliminarCita(String id) async {
    await _datasource.eliminar(id);
    await cargarCitas();
  }
}
