import 'package:flutter/material.dart';
import '../../../backend/src/datasources/notificacion_datasource_impl.dart';
import '../../../backend/src/models/notificacion_dto.dart';

class NotificacionesController extends ChangeNotifier {
  final NotificacionDatasourceImpl _datasource;

  List<NotificacionDto> _notificaciones = [];
  bool _isLoading = true;
  String? _error;
  String _filtroTipo = 'todas';

  List<NotificacionDto> get notificaciones => _notificaciones;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get filtroTipo => _filtroTipo;

  List<NotificacionDto> get notificacionesFiltradas {
    switch (_filtroTipo) {
      case 'info':
        return _notificaciones.where((n) => n.tipo.toLowerCase() == 'info').toList();
      case 'alerta':
        return _notificaciones
            .where((n) => n.tipo.toLowerCase() == 'alerta' || n.tipo.toLowerCase() == 'alertas')
            .toList();
      case 'no-leidas':
        return _notificaciones.where((n) => !n.leida).toList();
      default:
        return _notificaciones;
    }
  }

  NotificacionesController({NotificacionDatasourceImpl? datasource})
      : _datasource = datasource ?? NotificacionDatasourceImpl();

  void setFiltroTipo(String filtro) {
    _filtroTipo = filtro;
    notifyListeners();
  }

  Future<void> cargarNotificaciones() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _notificaciones = await _datasource.obtenerTodas();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> crearNotificacion(NotificacionDto notificacion) async {
    await _datasource.crear(notificacion);
    await cargarNotificaciones();
  }

  Future<void> marcarComoLeida(NotificacionDto notificacion) async {
    if (notificacion.leida) return;
    await _datasource.marcarComoLeida(notificacion.id);
    await cargarNotificaciones();
  }

  Future<void> marcarTodasComoLeidas() async {
    await _datasource.marcarTodasComoLeidas();
    await cargarNotificaciones();
  }

  Future<void> eliminarNotificacion(String id) async {
    await _datasource.eliminar(id);
    await cargarNotificaciones();
  }
}
