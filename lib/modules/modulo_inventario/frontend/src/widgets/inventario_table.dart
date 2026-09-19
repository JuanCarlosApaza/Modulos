import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import 'package:modulos/core/widgets/responsive_layout.dart';
import '../../../backend/src/models/inventario_dto.dart';

class InventarioTable extends StatefulWidget {
  final String tipo;
  final List<InventarioDto> inventarioItems;
  final List<InventarioDto> stockBajoItems;
  final List<MovimientoInventarioDto> movimientos;
  final void Function(InventarioDto item) onEdit;
  final void Function(InventarioDto item) onDelete;

  const InventarioTable({
    super.key,
    required this.tipo,
    required this.inventarioItems,
    required this.stockBajoItems,
    required this.movimientos,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<InventarioTable> createState() => _InventarioTableState();
}

class _InventarioTableState extends State<InventarioTable> with PaginationMixin {
  List get _currentList {
    switch (widget.tipo) {
      case 'stock': return widget.inventarioItems;
      case 'bajo': return widget.stockBajoItems;
      case 'movimientos': return widget.movimientos;
      default: return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = pageItems(_currentList);
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 700) return _buildMobile(items);
            return _buildDesktop(items);
          },
        ),
        buildPagination(_currentList),
      ],
    );
  }

  // ──────────────── Mobile Cards ────────────────

  Widget _buildMobile(List items) {
    switch (widget.tipo) {
      case 'stock': return _buildMobileStock(items.cast<InventarioDto>());
      case 'bajo': return _buildMobileStockBajo(items.cast<InventarioDto>());
      case 'movimientos': return _buildMobileMovimientos(items.cast<MovimientoInventarioDto>());
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildMobileStock(List<InventarioDto> items) {
    if (items.isEmpty) return _emptyState('No hay registros de inventario');
    return Column(
      children: items.map((item) => MobileCardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(item.productoNombre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () => widget.onEdit(item), color: AppColors.brandGreen, padding: EdgeInsets.zero, constraints: BoxConstraints(minWidth: 36, minHeight: 36)),
                    IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () => widget.onDelete(item), color: AppColors.negativeRed, padding: EdgeInsets.zero, constraints: BoxConstraints(minWidth: 36, minHeight: 36)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Stock', '${item.stockActual}'),
            _buildInfoRow('Mínimo', '${item.stockMinimo}'),
            _buildInfoRow('Máximo', '${item.stockMaximo}'),
            _buildInfoRow('Ubicación', item.ubicacion),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildMobileStockBajo(List<InventarioDto> items) {
    if (items.isEmpty) return _emptyState('No hay productos con stock bajo');
    return Column(
      children: items.map((item) => MobileCardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.productoNombre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            _buildInfoRow('Stock Actual', '${item.stockActual}'),
            _buildInfoRow('Stock Mínimo', '${item.stockMinimo}'),
            _buildInfoRow('Ubicación', item.ubicacion),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildMobileMovimientos(List<MovimientoInventarioDto> items) {
    if (items.isEmpty) return _emptyState('No hay movimientos registrados');
    return Column(
      children: items.map((m) => MobileCardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(m.productoId, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: _tipoColor(m.tipo).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                  child: Text(m.tipo[0].toUpperCase() + m.tipo.substring(1), style: TextStyle(color: _tipoColor(m.tipo), fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Cantidad', '${m.cantidad}'),
            if (m.descripcion != null) _buildInfoRow('Descripción', m.descripcion!),
            _buildInfoRow('Fecha', m.createdAt != null ? '${m.createdAt!.day.toString().padLeft(2, '0')}/${m.createdAt!.month.toString().padLeft(2, '0')}/${m.createdAt!.year}' : '-'),
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

  // ──────────────── Desktop Tables ────────────────

  Widget _buildDesktop(List items) {
    switch (widget.tipo) {
      case 'stock': return _buildTablaInventario(items.cast<InventarioDto>());
      case 'bajo': return _buildTablaStockBajo(items.cast<InventarioDto>());
      case 'movimientos': return _buildTablaMovimientos(items.cast<MovimientoInventarioDto>());
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildTablaInventario(List<InventarioDto> items) {
    if (items.isEmpty) return _emptyState('No hay registros de inventario');
    return Container(
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
          child: const Row(children: [
            Expanded(flex: 2, child: Text('Producto', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 1, child: Text('Stock', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 1, child: Text('Mín', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 1, child: Text('Máx', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 2, child: Text('Ubicación', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            SizedBox(width: 44),
          ]),
        ),
        ...items.map((item) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
          child: Row(children: [
            Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.productoNombre, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(item.productoId, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ])),
            Expanded(flex: 1, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: item.stockActual <= item.stockMinimo ? AppColors.negativeRed.withValues(alpha: 0.15) : AppColors.brandGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('${item.stockActual}', style: TextStyle(color: item.stockActual <= item.stockMinimo ? AppColors.negativeRed : AppColors.brandGreen, fontWeight: FontWeight.w600)),
            )),
            Expanded(flex: 1, child: Text('${item.stockMinimo}', style: const TextStyle(color: AppColors.textSecondary))),
            Expanded(flex: 1, child: Text('${item.stockMaximo}', style: const TextStyle(color: AppColors.textSecondary))),
            Expanded(flex: 2, child: Text(item.ubicacion, style: const TextStyle(color: AppColors.textSecondary))),
            Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () => widget.onEdit(item), color: AppColors.brandGreen, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
              const SizedBox(width: 4),
              IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () => widget.onDelete(item), color: AppColors.negativeRed, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
            ]),
          ]),
        )),
      ]),
    );
  }

  Widget _buildTablaStockBajo(List<InventarioDto> items) {
    if (items.isEmpty) return _emptyState('No hay productos con stock bajo');
    return Container(
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
          child: const Row(children: [
            Expanded(flex: 3, child: Text('Producto', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 2, child: Text('Stock Actual', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 2, child: Text('Stock Mínimo', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 2, child: Text('Ubicación', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            SizedBox(width: 44),
          ]),
        ),
        ...items.map((item) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
          child: Row(children: [
            Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.productoNombre, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(item.productoId, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ])),
            Expanded(flex: 2, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppColors.negativeRed.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
              child: Text('${item.stockActual}', style: const TextStyle(color: AppColors.negativeRed, fontWeight: FontWeight.w600)),
            )),
            Expanded(flex: 2, child: Text('${item.stockMinimo}', style: const TextStyle(color: AppColors.textSecondary))),
            Expanded(flex: 2, child: Text(item.ubicacion, style: const TextStyle(color: AppColors.textSecondary))),
            Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () => widget.onEdit(item), color: AppColors.brandGreen, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
              const SizedBox(width: 4),
              IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () => widget.onDelete(item), color: AppColors.negativeRed, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
            ]),
          ]),
        )),
      ]),
    );
  }

  Widget _buildTablaMovimientos(List<MovimientoInventarioDto> items) {
    if (items.isEmpty) return _emptyState('No hay movimientos registrados');
    return Container(
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
          child: const Row(children: [
            Expanded(flex: 2, child: Text('Producto ID', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 1, child: Text('Tipo', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 1, child: Text('Cantidad', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 2, child: Text('Descripción', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 2, child: Text('Fecha', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
          ]),
        ),
        ...items.map((m) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
          child: Row(children: [
            Expanded(flex: 2, child: Text(m.productoId, style: const TextStyle(color: AppColors.textPrimary))),
            Expanded(flex: 1, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: _tipoColor(m.tipo).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
              child: Text(m.tipo[0].toUpperCase() + m.tipo.substring(1), style: TextStyle(color: _tipoColor(m.tipo), fontWeight: FontWeight.w600, fontSize: 13)),
            )),
            Expanded(flex: 1, child: Text('${m.cantidad}', style: const TextStyle(color: AppColors.textPrimary))),
            Expanded(flex: 2, child: Text(m.descripcion ?? '-', style: const TextStyle(color: AppColors.textSecondary))),
            Expanded(flex: 2, child: Text(
              m.createdAt != null ? '${m.createdAt!.day.toString().padLeft(2, '0')}/${m.createdAt!.month.toString().padLeft(2, '0')}/${m.createdAt!.year}' : '-',
              style: const TextStyle(color: AppColors.textSecondary),
            )),
          ]),
        )),
      ]),
    );
  }

  // ──────────────── Helpers ────────────────

  static Color _tipoColor(String tipo) {
    switch (tipo) {
      case 'entrada': return AppColors.brandGreen;
      case 'salida': return AppColors.negativeRed;
      case 'ajuste': return Colors.amber.shade700;
      default: return AppColors.textSecondary;
    }
  }

  Widget _emptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
      child: Center(child: Text(message, style: const TextStyle(color: AppColors.textSecondary))),
    );
  }
}
