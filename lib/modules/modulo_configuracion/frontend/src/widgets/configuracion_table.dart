import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import 'package:modulos/core/widgets/responsive_layout.dart';
import '../../../backend/src/models/configuracion_dto.dart';

class ConfiguracionTable extends StatefulWidget {
  final List<ConfiguracionDto> configuraciones;
  final void Function(ConfiguracionDto configuracion) onEdit;
  final void Function(ConfiguracionDto configuracion) onDelete;

  const ConfiguracionTable({
    super.key,
    required this.configuraciones,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<ConfiguracionTable> createState() => _ConfiguracionTableState();
}

class _ConfiguracionTableState extends State<ConfiguracionTable> with PaginationMixin {
  @override
  Widget build(BuildContext context) {
    final items = pageItems(widget.configuraciones);
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 700) return _buildMobileCards(items);
            return _buildDesktopTable(items);
          },
        ),
        buildPagination(widget.configuraciones),
      ],
    );
  }

  Widget _buildMobileCards(List<ConfiguracionDto> items) {
    return Column(
      children: items.map((c) => MobileCardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(c.clave, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () => widget.onEdit(c), color: AppColors.brandGreen, padding: EdgeInsets.zero, constraints: BoxConstraints(minWidth: 36, minHeight: 36)),
                    IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () => widget.onDelete(c), color: AppColors.negativeRed, padding: EdgeInsets.zero, constraints: BoxConstraints(minWidth: 36, minHeight: 36)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Valor', c.valor),
            if (c.descripcion != null) _buildInfoRow('Descripción', c.descripcion!),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: _badgeColor(c.categoria).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
              child: Text(c.categoria, style: TextStyle(color: _badgeColor(c.categoria), fontSize: 12, fontWeight: FontWeight.w600)),
            ),
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

  static Color _badgeColor(String categoria) {
    switch (categoria) {
      case 'texto': return Colors.blue;
      case 'numero': return Colors.orange;
      case 'booleano': return Colors.purple;
      case 'fecha': return Colors.teal;
      case 'json': return Colors.red;
      default: return AppColors.textSecondary;
    }
  }

  Widget _buildDesktopTable(List<ConfiguracionDto> items) {
    return Container(
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
          child: const Row(children: [
            Expanded(flex: 3, child: Text('Clave', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 3, child: Text('Valor', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 4, child: Text('Descripción', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 2, child: Text('Tipo', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            SizedBox(width: 76),
          ]),
        ),
        ...items.map((c) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
            child: Row(children: [
            Expanded(flex: 3, child: Text(c.clave, style: const TextStyle(color: AppColors.textPrimary))),
            Expanded(flex: 3, child: Text(c.valor, style: const TextStyle(color: AppColors.textSecondary))),
            Expanded(flex: 4, child: Text(c.descripcion ?? '-', style: const TextStyle(color: AppColors.textSecondary))),
            Expanded(flex: 2, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: _badgeColor(c.categoria).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
              child: Text(c.categoria, style: TextStyle(color: _badgeColor(c.categoria), fontSize: 12, fontWeight: FontWeight.w600)),
            )),
            SizedBox(width: 76, child: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () => widget.onEdit(c), color: AppColors.brandGreen),
              IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () => widget.onDelete(c), color: AppColors.negativeRed),
            ])),
          ]),
        )),
      ]),
    );
  }
}
