import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import '../../../backend/src/models/notificacion_dto.dart';

class NotificacionForm extends StatefulWidget {
  final Future<void> Function(NotificacionDto notificacion) onSubmit;

  const NotificacionForm({super.key, required this.onSubmit});

  @override
  State<NotificacionForm> createState() => _NotificacionFormState();
}

class _NotificacionFormState extends State<NotificacionForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloController;
  late final TextEditingController _mensajeController;
  late final TextEditingController _tipoController;
  late final TextEditingController _usuarioIdController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController();
    _mensajeController = TextEditingController();
    _tipoController = TextEditingController(text: 'info');
    _usuarioIdController = TextEditingController();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _mensajeController.dispose();
    _tipoController.dispose();
    _usuarioIdController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final notificacion = NotificacionDto(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: _tituloController.text,
        mensaje: _mensajeController.text,
        tipo: _tipoController.text.isNotEmpty ? _tipoController.text : 'info',
        usuarioId: _usuarioIdController.text.isNotEmpty ? _usuarioIdController.text : '',
        leida: false,
      );
      await widget.onSubmit(notificacion);
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.brandGreen),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nueva Notificación',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _tituloController,
                decoration: _inputDecoration('Título *'),
                validator: (v) => v == null || v.trim().isEmpty ? 'El título es requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mensajeController,
                decoration: _inputDecoration('Mensaje *'),
                maxLines: 3,
                validator: (v) => v == null || v.trim().isEmpty ? 'El mensaje es requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tipoController,
                decoration: _inputDecoration('Tipo (info, alerta, error, exito)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usuarioIdController,
                decoration: _inputDecoration('Usuario ID'),
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
                      child: const Text('Crear'),
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
