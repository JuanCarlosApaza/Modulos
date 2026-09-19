import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import 'package:modulos/modules/modulo_cliente/backend/src/models/cliente_dto.dart';

class ClienteForm extends StatefulWidget {
  final ClienteDto? existente;
  final Future<void> Function(ClienteDto cliente) onSubmit;

  const ClienteForm({super.key, this.existente, required this.onSubmit});

  @override
  State<ClienteForm> createState() => _ClienteFormState();
}

class _ClienteFormState extends State<ClienteForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _emailController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _rfcController;
  late final TextEditingController _direccionController;
  late final TextEditingController _notasController;

  bool get _esEdicion => widget.existente != null;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.existente?.nombre ?? '');
    _emailController = TextEditingController(text: widget.existente?.email ?? '');
    _telefonoController = TextEditingController(text: widget.existente?.telefono ?? '');
    _rfcController = TextEditingController(text: widget.existente?.rfc ?? '');
    _direccionController = TextEditingController(text: widget.existente?.direccion ?? '');
    _notasController = TextEditingController(text: widget.existente?.notas ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _rfcController.dispose();
    _direccionController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final cliente = ClienteDto(
        id: _esEdicion ? widget.existente!.id : '',
        nombre: _nombreController.text,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        telefono: _telefonoController.text.isNotEmpty ? _telefonoController.text : null,
        rfc: _rfcController.text.isNotEmpty ? _rfcController.text : null,
        direccion: _direccionController.text.isNotEmpty ? _direccionController.text : null,
        notas: _notasController.text.isNotEmpty ? _notasController.text : null,
        activo: true,
      );
      await widget.onSubmit(cliente);
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
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_esEdicion ? 'Editar Cliente' : 'Nuevo Cliente',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nombreController,
                decoration: _inputDecoration('Nombre *'),
                textCapitalization: TextCapitalization.words,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'El nombre es requerido';
                  if (v.trim().length < 2) return 'Mínimo 2 caracteres';
                  if (v.trim().length > 150) return 'Máximo 150 caracteres';
                  if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$').hasMatch(v.trim())) return 'Solo letras y espacios';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration('Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  if (v.trim().length > 255) return 'Máximo 255 caracteres';
                  if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$').hasMatch(v.trim())) return 'Formato de email inválido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _telefonoController,
                decoration: _inputDecoration('Teléfono'),
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  if (v.trim().length > 30) return 'Máximo 30 caracteres';
                  if (!RegExp(r'^[\d\s\-\(\)\+]+$').hasMatch(v.trim())) return 'Solo números, espacios, guiones, paréntesis y +';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _rfcController,
                decoration: _inputDecoration('RFC'),
                textCapitalization: TextCapitalization.characters,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  if (v.trim().length < 12 || v.trim().length > 13) return 'El RFC debe tener 12 o 13 caracteres';
                  if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(v.trim())) return 'Solo caracteres alfanuméricos';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _direccionController,
                decoration: _inputDecoration('Dirección'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  if (v.trim().length > 500) return 'Máximo 500 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notasController,
                decoration: _inputDecoration('Notas'),
                maxLines: 2,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  if (v.trim().length > 1000) return 'Máximo 1000 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.cardBorder),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancelar', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(_esEdicion ? 'Actualizar' : 'Crear'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
