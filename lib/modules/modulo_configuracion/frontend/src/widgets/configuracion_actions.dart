import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import '../../../backend/src/models/configuracion_dto.dart';

class ConfiguracionActions {
  static void confirmarEliminar(BuildContext context, ConfiguracionDto configuracion, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Configuración'),
        content: Text('¿Eliminar la configuración "${configuracion.clave}"?'),
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
