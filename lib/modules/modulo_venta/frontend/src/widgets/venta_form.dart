import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import '../../../backend/src/models/venta_dto.dart';

class VentaForm extends StatefulWidget {
  final Future<void> Function(VentaDto venta) onSubmit;

  const VentaForm({super.key, required this.onSubmit});

  @override
  State<VentaForm> createState() => _VentaFormState();
}

class _VentaFormState extends State<VentaForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _clienteIdController;
  late final TextEditingController _usuarioIdController;
  late final TextEditingController _subtotalController;
  late final TextEditingController _descuentoController;
  late final TextEditingController _totalController;
  late final TextEditingController _notasController;
  String _metodoPago = 'efectivo';
  String _estado = 'completada';

  @override
  void initState() {
    super.initState();
    _clienteIdController = TextEditingController();
    _usuarioIdController = TextEditingController();
    _subtotalController = TextEditingController();
    _descuentoController = TextEditingController(text: '0');
    _totalController = TextEditingController();
    _notasController = TextEditingController();
  }

  @override
  void dispose() {
    _clienteIdController.dispose();
    _usuarioIdController.dispose();
    _subtotalController.dispose();
    _descuentoController.dispose();
    _totalController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final venta = VentaDto(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        clienteId: _clienteIdController.text.isNotEmpty ? _clienteIdController.text : null,
        usuarioId: _usuarioIdController.text,
        subtotal: double.tryParse(_subtotalController.text) ?? 0,
        descuento: double.tryParse(_descuentoController.text) ?? 0,
        total: double.tryParse(_totalController.text) ?? 0,
        metodoPago: _metodoPago,
        estado: _estado,
        notas: _notasController.text.isNotEmpty ? _notasController.text : null,
      );
      await widget.onSubmit(venta);
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
                'Nueva Venta',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _clienteIdController,
                decoration: _inputDecoration('Cliente ID'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usuarioIdController,
                decoration: _inputDecoration('Usuario ID *'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _subtotalController,
                      decoration: _inputDecoration('Subtotal *'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _descuentoController,
                      decoration: _inputDecoration('Descuento'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _totalController,
                decoration: _inputDecoration('Total *'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _metodoPago,
                decoration: _inputDecoration('Método de Pago'),
                items: const [
                  DropdownMenuItem(value: 'efectivo', child: Text('Efectivo')),
                  DropdownMenuItem(value: 'tarjeta', child: Text('Tarjeta')),
                  DropdownMenuItem(value: 'transferencia', child: Text('Transferencia')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _metodoPago = v);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _estado,
                decoration: _inputDecoration('Estado'),
                items: const [
                  DropdownMenuItem(value: 'completada', child: Text('Completada')),
                  DropdownMenuItem(value: 'pendiente', child: Text('Pendiente')),
                  DropdownMenuItem(value: 'cancelada', child: Text('Cancelada')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _estado = v);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notasController,
                decoration: _inputDecoration('Notas'),
                maxLines: 2,
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
