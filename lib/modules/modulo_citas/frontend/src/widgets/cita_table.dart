import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import 'package:modulos/core/widgets/responsive_layout.dart';
import '../../../backend/src/models/cita_dto.dart';

class CitaTable extends StatefulWidget {
  final List<CitaDto> citas;
  final void Function(CitaDto cita) onEdit;
  final void Function(CitaDto cita) onDelete;

  const CitaTable({
    super.key,
    required this.citas,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<CitaTable> createState() => _CitaTableState();
}

class _CitaTableState extends State<CitaTable> with PaginationMixin {
  @override
  Widget build(BuildContext context) {
    final items = pageItems(widget.citas);
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 700) return _buildMobileCards(items);
            return _buildDesktopTable(items);
          },
        ),
        buildPagination(widget.citas),
      ],
    );
  }

  Widget _buildMobileCards(List<CitaDto> items) {
    return Column(
      children: items.map((c) => MobileCardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(c.titulo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () => widget.onEdit(c), color: AppColors.brandGreen, padding: EdgeInsets.zero, constraints: BoxConstraints(minWidth: 36, minHeight: 36)),
                    IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () => widget.onDelete(c), color: AppColors.negativeRed, padding: EdgeInsets.zero, constraints: BoxConstraints(minWidth: 36, minHeight: 36)),
                  ],
                ),
              ],
            ),
            if (c.descripcion != null) ...[
              const SizedBox(height: 4),
              Text(c.descripcion!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
            const SizedBox(height: 8),
            _buildInfoRow('Fecha', '${c.fechaInicio.day}/${c.fechaInicio.month}/${c.fechaInicio.year}'),
            _buildInfoRow('Horario',
              '${c.fechaInicio.hour.toString().padLeft(2, '0')}:${c.fechaInicio.minute.toString().padLeft(2, '0')} - '
              '${c.fechaFin.hour.toString().padLeft(2, '0')}:${c.fechaFin.minute.toString().padLeft(2, '0')}'),
            const SizedBox(height: 6),
            _buildEstadoBadge(c.estado),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          Expanded(child: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13))),
        ],
      ),
    );
  }

  static Widget _buildEstadoBadge(String estado) {
    Color color;
    String texto;
    switch (estado) {
      case 'confirmada':
        color = AppColors.brandGreen;
        texto = 'Confirmada';
        break;
      case 'completada':
        color = AppColors.infoBlue;
        texto = 'Completada';
        break;
      case 'cancelada':
        color = AppColors.negativeRed;
        texto = 'Cancelada';
        break;
      default:
        color = AppColors.warningOrange;
        texto = 'Pendiente';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
      child: Text(texto, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildDesktopTable(List<CitaDto> items) {
    return Container(
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
          child: const Row(children: [
            Expanded(flex: 3, child: Text('Título', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 2, child: Text('Fecha', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 2, child: Text('Horario', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 2, child: Text('Estado', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            SizedBox(width: 44),
          ]),
        ),
        ...items.map((c) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
          child: Row(children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.titulo, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                  if (c.descripcion != null)
                    Text(c.descripcion!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            Expanded(flex: 2, child: Text('${c.fechaInicio.day}/${c.fechaInicio.month}/${c.fechaInicio.year}', style: const TextStyle(color: AppColors.textSecondary))),
            Expanded(flex: 2, child: Text(
              '${c.fechaInicio.hour.toString().padLeft(2, '0')}:${c.fechaInicio.minute.toString().padLeft(2, '0')} - ${c.fechaFin.hour.toString().padLeft(2, '0')}:${c.fechaFin.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(color: AppColors.textSecondary),
            )),
            Expanded(flex: 2, child: _buildEstadoBadge(c.estado)),
            Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () => widget.onEdit(c), color: AppColors.brandGreen, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
              const SizedBox(width: 4),
              IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () => widget.onDelete(c), color: AppColors.negativeRed, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
            ]),
          ]),
        )),
      ]),
    );
  }
}
