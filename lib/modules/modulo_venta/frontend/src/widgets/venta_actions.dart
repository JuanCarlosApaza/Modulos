import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import '../../../backend/src/models/venta_dto.dart';

class VentaActions {
  static void confirmarEliminar(BuildContext context, VentaDto venta, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Venta'),
        content: Text('¿Eliminar la venta ${venta.folio ?? venta.id}?'),
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
