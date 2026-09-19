import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import 'package:modulos/core/widgets/responsive_layout.dart';
import '../../../backend/src/models/venta_dto.dart';

class VentaTable extends StatefulWidget {
  final List<VentaDto> ventas;
  final void Function(VentaDto venta) onDelete;

  const VentaTable({
    super.key,
    required this.ventas,
    required this.onDelete,
  });

  @override
  State<VentaTable> createState() => _VentaTableState();
}

class _VentaTableState extends State<VentaTable> with PaginationMixin {
  @override
  Widget build(BuildContext context) {
    final items = pageItems(widget.ventas);
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 700) return _buildMobileCards(items);
            return _buildDesktopTable(items);
          },
        ),
        buildPagination(widget.ventas),
      ],
    );
  }

  Widget _buildMobileCards(List<VentaDto> items) {
    return Column(
      children: items.map((v) {
        final isCompletada = v.estado == 'completada';
        return MobileCardContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Folio: ${v.folio ?? '-'}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () => widget.onDelete(v), color: AppColors.negativeRed, padding: EdgeInsets.zero, constraints: BoxConstraints(minWidth: 36, minHeight: 36)),
                ],
              ),
              const SizedBox(height: 8),
              _buildInfoRow('Cliente', v.clienteId ?? '-'),
              _buildInfoRow('Total', '\$${v.total.toStringAsFixed(2)}'),
              _buildInfoRow('Fecha', v.createdAt?.toString().substring(0, 10) ?? '-'),
              const SizedBox(height: 6),
              Chip(
                label: Text(v.estado, style: const TextStyle(fontSize: 12)),
                backgroundColor: isCompletada ? AppColors.positiveGreen.withValues(alpha: 0.1) : AppColors.negativeRed.withValues(alpha: 0.1),
                side: BorderSide.none,
              ),
            ],
          ),
        );
      }).toList(),
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

  Widget _buildDesktopTable(List<VentaDto> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
            child: const Row(children: [
              Expanded(flex: 1, child: Text('Folio', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
              Expanded(flex: 3, child: Text('Cliente', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
              Expanded(flex: 2, child: Text('Total', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
              Expanded(flex: 2, child: Text('Fecha', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
              Expanded(flex: 2, child: Text('Estado', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
              SizedBox(width: 56),
            ]),
          ),
          ...items.map((v) {
            final isCompletada = v.estado == 'completada';
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
              child: Row(children: [
                Expanded(flex: 1, child: Text(v.folio?.toString() ?? '-', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600))),
                Expanded(flex: 3, child: Text(v.clienteId ?? '-', style: const TextStyle(color: AppColors.textPrimary))),
                Expanded(flex: 2, child: Text('\$${v.total.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600))),
                Expanded(flex: 2, child: Text(v.createdAt?.toString().substring(0, 10) ?? '-', style: const TextStyle(color: AppColors.textSecondary))),
                Expanded(
                  flex: 2,
                  child: Chip(
                    label: Text(v.estado, style: const TextStyle(fontSize: 12)),
                    backgroundColor: isCompletada ? AppColors.positiveGreen.withValues(alpha: 0.1) : AppColors.negativeRed.withValues(alpha: 0.1),
                    side: BorderSide.none,
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () => widget.onDelete(v), color: AppColors.negativeRed),
                ),
              ]),
            );
          }),
        ],
      ),
    );
  }
}
