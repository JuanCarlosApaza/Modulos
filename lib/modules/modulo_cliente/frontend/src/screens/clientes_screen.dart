import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import 'package:modulos/core/widgets/responsive_layout.dart';
import '../controllers/clientes_controller.dart';
import '../widgets/cliente_form.dart';
import '../widgets/cliente_table.dart';
import '../widgets/cliente_actions.dart';

class ClientesScreen extends StatefulWidget {
  final int selectedNav;
  final ValueChanged<int> onNavSelect;
  const ClientesScreen({super.key, required this.selectedNav, required this.onNavSelect});
  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final _controller = ClientesController();
  @override
  void initState() { super.initState(); _controller.addListener(() => setState(() {})); _controller.cargarClientes(); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  void _abrirFormulario({dynamic existente}) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => ClienteForm(existente: existente, onSubmit: (cliente) async {
        if (existente != null) { await _controller.actualizarCliente(cliente); } else { await _controller.crearCliente(cliente); }
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(existente != null ? 'Cliente actualizado' : 'Cliente creado')));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(selectedNav: widget.selectedNav, onNavSelect: widget.onNavSelect, title: 'Clientes',
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
        ElevatedButton(onPressed: _controller.cargarClientes, child: const Text('Reintentar')),
      ]));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      PageHeader(title: 'Gestión de Clientes', count: _controller.clientes.length, buttonLabel: 'Nuevo Cliente', onButtonPressed: () => _abrirFormulario()),
      const SizedBox(height: 20),
      if (_controller.clientes.isEmpty)
        Container(padding: const EdgeInsets.all(40), decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
          child: const Center(child: Text('No hay clientes', style: TextStyle(color: AppColors.textSecondary))))
      else
        ClienteTable(clientes: _controller.clientes,
          onEdit: (c) => _abrirFormulario(existente: c),
          onDelete: (c) => ClienteActions.confirmarEliminar(context, c, () async {
            try { await _controller.eliminarCliente(c.id); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cliente eliminado'))); }
            catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.negativeRed)); }
          })),
    ]);
  }
}
