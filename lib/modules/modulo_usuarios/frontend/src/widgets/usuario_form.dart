import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import 'package:modulos/modules/modulo_usuarios/backend/src/models/usuario_dto.dart';

class UsuarioForm extends StatefulWidget {
  final UsuarioDto? existente;
  final List<Map<String, String>> roles;
  final Future<void> Function(UsuarioDto usuario) onSubmit;

  const UsuarioForm({super.key, this.existente, required this.roles, required this.onSubmit});

  @override
  State<UsuarioForm> createState() => _UsuarioFormState();
}

class _UsuarioFormState extends State<UsuarioForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _telefonoController;
  String? _rolSeleccionado;

  bool get _esEdicion => widget.existente != null;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.existente?.nombre ?? '');
    _emailController = TextEditingController(text: widget.existente?.email ?? '');
    _passwordController = TextEditingController();
    _telefonoController = TextEditingController(text: widget.existente?.telefono ?? '');
    _rolSeleccionado = widget.existente?.rolId;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final usuario = UsuarioDto(
        id: _esEdicion ? widget.existente!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: _nombreController.text,
        email: _emailController.text,
        passwordHash: _passwordController.text.isNotEmpty ? _passwordController.text : widget.existente?.passwordHash,
        telefono: _telefonoController.text.isNotEmpty ? _telefonoController.text : null,
        rolId: _rolSeleccionado!,
        activo: widget.existente?.activo ?? true,
      );
      await widget.onSubmit(usuario);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.negativeRed),
        );
      }
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.cardBorder)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.brandGreen)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_esEdicion ? 'Editar Usuario' : 'Nuevo Usuario',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 20),
              TextFormField(controller: _nombreController, decoration: _inputDecoration('Nombre *'),
                  validator: (v) => v == null || v.isEmpty ? 'Requerido' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _emailController, decoration: _inputDecoration('Email *'),
                  keyboardType: TextInputType.emailAddress, validator: (v) => v == null || v.isEmpty ? 'Requerido' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _passwordController,
                  decoration: _inputDecoration(_esEdicion ? 'Password (dejar vacío para no cambiar)' : 'Password *'),
                  obscureText: true, validator: (v) => (!_esEdicion && (v == null || v.isEmpty)) ? 'Requerido' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _telefonoController, decoration: _inputDecoration('Teléfono'), keyboardType: TextInputType.phone),
              const SizedBox(height: 12),
              StatefulBuilder(
                builder: (context, setSheetState) => DropdownButtonFormField<String>(
                  value: _rolSeleccionado,
                  decoration: _inputDecoration('Rol *'),
                  items: widget.roles.map((r) => DropdownMenuItem(value: r['id'], child: Text(r['nombre']!))).toList(),
                  onChanged: (v) => setSheetState(() => _rolSeleccionado = v),
                  validator: (v) => v == null || v.isEmpty ? 'Selecciona un rol' : null,
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.cardBorder),
                        padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text('Cancelar', style: TextStyle(color: AppColors.textSecondary)))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.brandGreen, foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Text(_esEdicion ? 'Actualizar' : 'Crear'))),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
