import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import 'package:modulos/core/widgets/responsive_layout.dart';
import '../controllers/notificaciones_controller.dart';
import '../widgets/notificacion_form.dart';
import '../widgets/notificacion_table.dart';
import '../widgets/notificacion_actions.dart';

class NotificacionesScreen extends StatefulWidget {
  final int selectedNav;
  final ValueChanged<int> onNavSelect;
  const NotificacionesScreen({super.key, required this.selectedNav, required this.onNavSelect});
  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  final _controller = NotificacionesController();
  @override
  void initState() { super.initState(); _controller.addListener(() => setState(() {})); _controller.cargarNotificaciones(); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  void _abrirFormulario() {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => NotificacionForm(onSubmit: (notificacion) async {
        await _controller.crearNotificacion(notificacion);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notificación creada')));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(selectedNav: widget.selectedNav, onNavSelect: widget.onNavSelect, title: 'Notificaciones',
      contentBuilder: (context, constraints) => _buildContent());
  }

  Widget _buildContent() {
    if (_controller.isLoading) return const Center(child: CircularProgressIndicator());
    if (_controller.error != null) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.error_outline, size: 48, color: AppColors.negativeRed),
        const SizedBox(height: 16),
        Text('Error: ${_controller.error}', style: const TextStyle(color: AppColors.textPrimary)),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: _controller.cargarNotificaciones, child: const Text('Reintentar')),
      ]));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      PageHeader(title: 'Gestión de Notificaciones', count: _controller.notificaciones.length, buttonLabel: 'Nueva Notificación', onButtonPressed: _abrirFormulario),
      const SizedBox(height: 16),
      Wrap(spacing: 8, runSpacing: 8, children: [
        _chip('Todas', 'todas'), _chip('Info', 'info'), _chip('Alertas', 'alerta'), _chip('No leídas', 'no-leidas'),
      ]),
      const SizedBox(height: 16),
      if (_controller.notificacionesFiltradas.isEmpty)
        Container(padding: const EdgeInsets.all(40), decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
          child: const Center(child: Text('No hay notificaciones', style: TextStyle(color: AppColors.textSecondary))))
      else
        NotificacionTable(notificaciones: _controller.notificacionesFiltradas,
          onMarcarLeida: (n) async { await _controller.marcarComoLeida(n); },
          onDelete: (n) => NotificacionActions.confirmarEliminar(context, n, () async {
            try { await _controller.eliminarNotificacion(n.id); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notificación eliminada'))); }
            catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.negativeRed)); }
          })),
    ]);
  }

  Widget _chip(String label, String valor) {
    final sel = _controller.filtroTipo == valor;
    return FilterChip(label: Text(label), selected: sel, onSelected: (_) => _controller.setFiltroTipo(valor),
      selectedColor: AppColors.brandGreen, checkmarkColor: Colors.white,
      labelStyle: TextStyle(color: sel ? Colors.white : AppColors.textSecondary, fontWeight: sel ? FontWeight.w600 : FontWeight.normal));
  }
}
