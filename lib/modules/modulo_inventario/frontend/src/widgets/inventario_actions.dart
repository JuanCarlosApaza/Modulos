import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import '../../../backend/src/models/inventario_dto.dart';

class InventarioActions {
  static void confirmarEliminar(BuildContext context, InventarioDto item, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Inventario'),
        content: Text('¿Eliminar el registro de "${item.productoNombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: const Text('Eliminar', style: TextStyle(color: AppColors.negativeRed)),
          ),
        ],
      ),
    );
  }
}
