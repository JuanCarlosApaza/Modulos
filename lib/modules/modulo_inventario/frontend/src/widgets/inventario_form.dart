import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import '../../../backend/src/models/inventario_dto.dart';

/// Form for registering a new inventory movement.
class InventarioMovimientoForm extends StatefulWidget {
  final Future<void> Function({
    required String productoId,
    required String tipo,
    required int cantidad,
    String? descripcion,
    required String usuarioId,
  }) onSubmit;

  const InventarioMovimientoForm({super.key, required this.onSubmit});

  @override
  State<InventarioMovimientoForm> createState() => _InventarioMovimientoFormState();
}

class _InventarioMovimientoFormState extends State<InventarioMovimientoForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _productoIdController;
  late final TextEditingController _cantidadController;
  late final TextEditingController _motivoController;
  late final TextEditingController _referenciaController;
  String _tipoSeleccionado = 'entrada';

  @override
  void initState() {
    super.initState();
    _productoIdController = TextEditingController();
    _cantidadController = TextEditingController();
    _motivoController = TextEditingController();
    _referenciaController = TextEditingController();
  }

  @override
  void dispose() {
    _productoIdController.dispose();
    _cantidadController.dispose();
    _motivoController.dispose();
    _referenciaController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await widget.onSubmit(
        productoId: _productoIdController.text,
        tipo: _tipoSeleccionado,
        cantidad: int.parse(_cantidadController.text),
        descripcion: _motivoController.text.isNotEmpty ? _motivoController.text : null,
        usuarioId: _referenciaController.text.isNotEmpty ? _referenciaController.text : 'sistema',
      );
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
                'Registrar Movimiento',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _productoIdController,
                decoration: _inputDecoration('Producto ID *'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _tipoSeleccionado,
                decoration: _inputDecoration('Tipo *'),
                dropdownColor: AppColors.cardBg,
                items: const [
                  DropdownMenuItem(value: 'entrada', child: Text('Entrada')),
                  DropdownMenuItem(value: 'salida', child: Text('Salida')),
                  DropdownMenuItem(value: 'ajuste', child: Text('Ajuste')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _tipoSeleccionado = v);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cantidadController,
                decoration: _inputDecoration('Cantidad *'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  if (int.tryParse(v) == null || int.parse(v) <= 0) return 'Ingrese un número positivo';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _motivoController,
                decoration: _inputDecoration('Motivo'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _referenciaController,
                decoration: _inputDecoration('Referencia / Usuario ID'),
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
                      child: const Text('Registrar'),
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

/// Form for editing inventory settings (stock min/max, ubicación).
class InventarioEditForm extends StatefulWidget {
  final InventarioDto existente;
  final Future<void> Function(InventarioDto item) onSubmit;

  const InventarioEditForm({super.key, required this.existente, required this.onSubmit});

  @override
  State<InventarioEditForm> createState() => _InventarioEditFormState();
}

class _InventarioEditFormState extends State<InventarioEditForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _stockMinimoController;
  late final TextEditingController _stockMaximoController;
  late final TextEditingController _ubicacionController;

  @override
  void initState() {
    super.initState();
    _stockMinimoController = TextEditingController(text: widget.existente.stockMinimo.toString());
    _stockMaximoController = TextEditingController(text: widget.existente.stockMaximo.toString());
    _ubicacionController = TextEditingController(text: widget.existente.ubicacion);
  }

  @override
  void dispose() {
    _stockMinimoController.dispose();
    _stockMaximoController.dispose();
    _ubicacionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final actualizado = InventarioDto(
        id: widget.existente.id,
        productoId: widget.existente.productoId,
        productoNombre: widget.existente.productoNombre,
        stockActual: widget.existente.stockActual,
        stockMinimo: int.parse(_stockMinimoController.text),
        stockMaximo: int.parse(_stockMaximoController.text),
        ubicacion: _ubicacionController.text,
        activo: widget.existente.activo,
        createdAt: widget.existente.createdAt,
        updatedAt: widget.existente.updatedAt,
      );
      await widget.onSubmit(actualizado);
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
                'Editar Inventario — ${widget.existente.productoNombre}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _stockMinimoController,
                decoration: _inputDecoration('Stock Mínimo *'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  if (int.tryParse(v) == null) return 'Ingrese un número';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stockMaximoController,
                decoration: _inputDecoration('Stock Máximo *'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  if (int.tryParse(v) == null) return 'Ingrese un número';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ubicacionController,
                decoration: _inputDecoration('Ubicación *'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
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
                      child: const Text('Actualizar'),
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
