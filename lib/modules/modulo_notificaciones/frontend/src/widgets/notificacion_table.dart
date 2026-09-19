import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import 'package:modulos/core/widgets/responsive_layout.dart';
import '../../../backend/src/models/notificacion_dto.dart';

class NotificacionTable extends StatefulWidget {
  final List<NotificacionDto> notificaciones;
  final void Function(NotificacionDto notificacion) onMarcarLeida;
  final void Function(NotificacionDto notificacion) onDelete;

  const NotificacionTable({
    super.key,
    required this.notificaciones,
    required this.onMarcarLeida,
    required this.onDelete,
  });

  @override
  State<NotificacionTable> createState() => _NotificacionTableState();
}

class _NotificacionTableState extends State<NotificacionTable> with PaginationMixin {
  @override
  Widget build(BuildContext context) {
    final items = pageItems(widget.notificaciones);
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 700) return _buildMobileCards(items);
            return _buildDesktopTable(items);
          },
        ),
        buildPagination(widget.notificaciones),
      ],
    );
  }

  Widget _buildMobileCards(List<NotificacionDto> items) {
    return Column(
      children: items.map((n) => MobileCardContainer(
        child: InkWell(
          onTap: () => widget.onMarcarLeida(n),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(n.titulo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!n.leida)
                        IconButton(icon: const Icon(Icons.mark_email_read, size: 18), onPressed: () => widget.onMarcarLeida(n), color: AppColors.brandGreen, padding: EdgeInsets.zero, constraints: BoxConstraints(minWidth: 36, minHeight: 36), tooltip: 'Marcar como leída'),
                      IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () => widget.onDelete(n), color: AppColors.negativeRed, padding: EdgeInsets.zero, constraints: BoxConstraints(minWidth: 36, minHeight: 36)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(n.mensaje.length > 80 ? '${n.mensaje.substring(0, 80)}...' : n.mensaje, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 8),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: _tipoColor(n.tipo).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text(n.tipo, style: TextStyle(color: _tipoColor(n.tipo), fontWeight: FontWeight.w600, fontSize: 12)),
                ),
                const SizedBox(width: 8),
                Icon(n.leida ? Icons.mark_email_read : Icons.mark_email_unread, size: 18, color: n.leida ? AppColors.positiveGreen : AppColors.warningOrange),
                const SizedBox(width: 8),
                Text(n.createdAt != null ? '${n.createdAt!.day}/${n.createdAt!.month}/${n.createdAt!.year}' : '-', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ]),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildDesktopTable(List<NotificacionDto> items) {
    return Container(
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
          child: const Row(children: [
            Expanded(flex: 2, child: Text('Título', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 3, child: Text('Mensaje', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 1, child: Text('Tipo', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 1, child: Text('Leída', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 1, child: Text('Fecha', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            SizedBox(width: 44),
          ]),
        ),
        ...items.map((n) => Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => widget.onMarcarLeida(n),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
              child: Row(children: [
                Expanded(flex: 2, child: Text(n.titulo, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500))),
                Expanded(flex: 3, child: Text(n.mensaje.length > 60 ? '${n.mensaje.substring(0, 60)}...' : n.mensaje, style: const TextStyle(color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)),
                Expanded(flex: 1, child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: _tipoColor(n.tipo).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text(n.tipo, style: TextStyle(color: _tipoColor(n.tipo), fontWeight: FontWeight.w600, fontSize: 12), textAlign: TextAlign.center),
                )),
                Expanded(flex: 1, child: Icon(n.leida ? Icons.mark_email_read : Icons.mark_email_unread, size: 20, color: n.leida ? AppColors.positiveGreen : AppColors.warningOrange)),
                Expanded(flex: 1, child: Text(n.createdAt != null ? '${n.createdAt!.day}/${n.createdAt!.month}/${n.createdAt!.year}' : '-', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  if (!n.leida) IconButton(icon: const Icon(Icons.mark_email_read, size: 18), onPressed: () => widget.onMarcarLeida(n), color: AppColors.brandGreen, padding: EdgeInsets.zero, constraints: const BoxConstraints(), tooltip: 'Marcar como leída'),
                  const SizedBox(width: 4),
                  IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () => widget.onDelete(n), color: AppColors.negativeRed, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                ]),
              ]),
            ),
          ),
        )),
      ]),
    );
  }

  static Color _tipoColor(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'info': return AppColors.infoBlue;
      case 'alerta': case 'alertas': return AppColors.warningOrange;
      case 'error': return AppColors.negativeRed;
      case 'exito': return AppColors.positiveGreen;
      default: return AppColors.textSecondary;
    }
  }
}
