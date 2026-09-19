import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import 'package:modulos/core/widgets/responsive_layout.dart';
import '../controllers/usuarios_controller.dart';
import '../widgets/usuario_form.dart';
import '../widgets/usuario_table.dart';

class UsuariosScreen extends StatefulWidget {
  final int selectedNav;
  final ValueChanged<int> onNavSelect;
  const UsuariosScreen({super.key, required this.selectedNav, required this.onNavSelect});
  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final _controller = UsuariosController();
  @override
  void initState() { super.initState(); _controller.addListener(() => setState(() {})); _controller.cargarDatos(); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  void _abrirFormulario({dynamic existente}) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => UsuarioForm(existente: existente, roles: _controller.roles, onSubmit: (usuario) async {
        if (existente != null) { await _controller.actualizarUsuario(usuario); } else { await _controller.crearUsuario(usuario); }
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(existente != null ? 'Usuario actualizado' : 'Usuario creado')));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(selectedNav: widget.selectedNav, onNavSelect: widget.onNavSelect, title: 'Usuarios',
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
        ElevatedButton(onPressed: _controller.cargarDatos, child: const Text('Reintentar')),
      ]));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      PageHeader(title: 'Gestión de Usuarios', count: _controller.usuarios.length, buttonLabel: 'Nuevo Usuario', onButtonPressed: () => _abrirFormulario()),
      const SizedBox(height: 20),
      if (_controller.usuarios.isEmpty)
        Container(padding: const EdgeInsets.all(40), decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
          child: const Center(child: Text('No hay usuarios', style: TextStyle(color: AppColors.textSecondary))))
      else
          UsuarioTable(usuarios: _controller.usuarios,
            onEdit: (u) => _abrirFormulario(existente: u),
            onDelete: (u) async {
              try { await _controller.eliminarUsuario(u.id); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario eliminado'))); }
              catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.negativeRed)); }
            }),
    ]);
  }
}
