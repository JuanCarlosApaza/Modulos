import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import '../../../backend/src/models/configuracion_dto.dart';

class ConfiguracionForm extends StatefulWidget {
  final ConfiguracionDto? existente;
  final Future<void> Function(ConfiguracionDto configuracion) onSubmit;

  const ConfiguracionForm({super.key, this.existente, required this.onSubmit});

  @override
  State<ConfiguracionForm> createState() => _ConfiguracionFormState();
}

class _ConfiguracionFormState extends State<ConfiguracionForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _claveController;
  late final TextEditingController _valorController;
  late final TextEditingController _descripcionController;
  late String _categoriaSeleccionada;

  static const List<String> _categorias = ['texto', 'numero', 'booleano', 'fecha', 'json'];

  bool get _esEdicion => widget.existente != null;

  @override
  void initState() {
    super.initState();
    _claveController = TextEditingController(text: widget.existente?.clave ?? '');
    _valorController = TextEditingController(text: widget.existente?.valor ?? '');
    _descripcionController = TextEditingController(text: widget.existente?.descripcion ?? '');
    _categoriaSeleccionada = widget.existente?.categoria ?? _categorias.first;
  }

  @override
  void dispose() {
    _claveController.dispose();
    _valorController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final configuracion = ConfiguracionDto(
        id: _esEdicion
            ? widget.existente!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        clave: _claveController.text,
        valor: _valorController.text,
        descripcion: _descripcionController.text.isNotEmpty ? _descripcionController.text : null,
        categoria: _categoriaSeleccionada,
      );
      await widget.onSubmit(configuracion);
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
              Text(
                _esEdicion ? 'Editar Configuración' : 'Nueva Configuración',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _claveController,
                decoration: _inputDecoration('Clave *'),
                validator: (v) => v == null || v.trim().isEmpty ? 'La clave es requerida' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _valorController,
                decoration: _inputDecoration('Valor *'),
                validator: (v) => v == null || v.trim().isEmpty ? 'El valor es requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descripcionController,
                decoration: _inputDecoration('Descripción'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _categoriaSeleccionada,
                decoration: _inputDecoration('Categoría'),
                items: _categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _categoriaSeleccionada = v);
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
