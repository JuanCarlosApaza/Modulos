import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import '../../../backend/src/models/cita_dto.dart';

class CitaActions {
  static void confirmarEliminar(BuildContext context, CitaDto cita, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Cita'),
        content: Text('¿Eliminar "${cita.titulo}"?'),
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
