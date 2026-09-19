import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import 'package:modulos/core/widgets/responsive_layout.dart';
import '../../../backend/src/models/producto_dto.dart';

class ProductoTable extends StatefulWidget {
  final List<ProductoDto> productos;
  final void Function(ProductoDto producto) onEdit;
  final void Function(ProductoDto producto) onDelete;

  const ProductoTable({
    super.key,
    required this.productos,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<ProductoTable> createState() => _ProductoTableState();
}

class _ProductoTableState extends State<ProductoTable> with PaginationMixin {
  @override
  Widget build(BuildContext context) {
    final items = pageItems(widget.productos);
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 700) return _buildMobileCards(items);
            return _buildDesktopTable(items);
          },
        ),
        buildPagination(widget.productos),
      ],
    );
  }

  Widget _buildMobileCards(List<ProductoDto> items) {
    return Column(
      children: items.map((p) => MobileCardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(p.nombre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () => widget.onEdit(p), color: AppColors.brandGreen, padding: EdgeInsets.zero, constraints: BoxConstraints(minWidth: 36, minHeight: 36)),
                    IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () => widget.onDelete(p), color: AppColors.negativeRed, padding: EdgeInsets.zero, constraints: BoxConstraints(minWidth: 36, minHeight: 36)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow('SKU', p.sku ?? '-'),
            _buildInfoRow('Precio', '\$${p.precioVenta.toStringAsFixed(2)}'),
            _buildInfoRow('Stock', p.stockActual.toString()),
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

  Widget _buildDesktopTable(List<ProductoDto> items) {
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
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
            ),
            child: const Row(children: [
              Expanded(flex: 3, child: Text('Nombre', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
              Expanded(flex: 2, child: Text('SKU', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
              Expanded(flex: 2, child: Text('Precio', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
              Expanded(flex: 1, child: Text('Stock', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
              SizedBox(width: 44),
            ]),
          ),
          ...items.map((p) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
            ),
            child: Row(children: [
              Expanded(flex: 3, child: Text(p.nombre, style: const TextStyle(color: AppColors.textPrimary))),
              Expanded(flex: 2, child: Text(p.sku ?? '-', style: const TextStyle(color: AppColors.textSecondary))),
              Expanded(flex: 2, child: Text('\$${p.precioVenta.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600))),
              Expanded(flex: 1, child: Text(p.stockActual.toString(), style: const TextStyle(color: AppColors.textSecondary))),
              Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () => widget.onEdit(p), color: AppColors.brandGreen, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                const SizedBox(width: 4),
                IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () => widget.onDelete(p), color: AppColors.negativeRed, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
              ]),
            ]),
          )),
        ],
      ),
    );
  }
}
