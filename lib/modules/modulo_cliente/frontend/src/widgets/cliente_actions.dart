import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import '../../../backend/src/models/cliente_dto.dart';

class ClienteActions {
  static void confirmarEliminar(BuildContext context, ClienteDto cliente, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Cliente'),
        content: Text('¿Eliminar a "${cliente.nombre}"?'),
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
