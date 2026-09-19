import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import '../../../backend/src/models/producto_dto.dart';

class ProductoForm extends StatefulWidget {
  final ProductoDto? existente;
  final Future<void> Function(ProductoDto producto) onSubmit;

  const ProductoForm({super.key, this.existente, required this.onSubmit});

  @override
  State<ProductoForm> createState() => _ProductoFormState();
}

class _ProductoFormState extends State<ProductoForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _skuController;
  late final TextEditingController _precioCompraController;
  late final TextEditingController _precioVentaController;
  late final TextEditingController _unidadMedidaController;
  late final TextEditingController _categoriaIdController;

  bool get _esEdicion => widget.existente != null;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.existente?.nombre ?? '');
    _descripcionController = TextEditingController(text: widget.existente?.descripcion ?? '');
    _skuController = TextEditingController(text: widget.existente?.sku ?? '');
    _precioCompraController = TextEditingController(
      text: widget.existente != null ? widget.existente!.precioCompra.toString() : '',
    );
    _precioVentaController = TextEditingController(
      text: widget.existente != null ? widget.existente!.precioVenta.toString() : '',
    );
    _unidadMedidaController = TextEditingController(text: widget.existente?.unidadMedida ?? 'pieza');
    _categoriaIdController = TextEditingController(text: widget.existente?.categoriaId ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _skuController.dispose();
    _precioCompraController.dispose();
    _precioVentaController.dispose();
    _unidadMedidaController.dispose();
    _categoriaIdController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final producto = ProductoDto(
        id: _esEdicion
            ? widget.existente!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: _nombreController.text,
        descripcion: _descripcionController.text.isNotEmpty ? _descripcionController.text : null,
        sku: _skuController.text.isNotEmpty ? _skuController.text : null,
        precioCompra: double.tryParse(_precioCompraController.text) ?? 0,
        precioVenta: double.tryParse(_precioVentaController.text) ?? 0,
        unidadMedida: _unidadMedidaController.text.isNotEmpty ? _unidadMedidaController.text : 'pieza',
        categoriaId: _categoriaIdController.text.isNotEmpty ? _categoriaIdController.text : null,
        stockActual: widget.existente?.stockActual ?? 0,
        stockMinimo: widget.existente?.stockMinimo ?? 0,
        activo: true,
      );
      await widget.onSubmit(producto);
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
                _esEdicion ? 'Editar Producto' : 'Nuevo Producto',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nombreController,
                decoration: _inputDecoration('Nombre *'),
                textCapitalization: TextCapitalization.words,
                validator: (v) => v == null || v.trim().isEmpty ? 'El nombre es requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descripcionController,
                decoration: _inputDecoration('Descripción'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _skuController,
                decoration: _inputDecoration('SKU'),
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _precioCompraController,
                      decoration: _inputDecoration('Precio Compra *'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _precioVentaController,
                      decoration: _inputDecoration('Precio Venta *'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _unidadMedidaController,
                decoration: _inputDecoration('Unidad de Medida'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoriaIdController,
                decoration: _inputDecoration('Categoría ID'),
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
