import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import 'package:modulos/core/widgets/responsive_layout.dart';
import 'package:modulos/modules/modulo_cliente/backend/src/models/cliente_dto.dart';

class ClienteTable extends StatefulWidget {
  final List<ClienteDto> clientes;
  final void Function(ClienteDto cliente) onEdit;
  final void Function(ClienteDto cliente) onDelete;

  const ClienteTable({super.key, required this.clientes, required this.onEdit, required this.onDelete});

  @override
  State<ClienteTable> createState() => _ClienteTableState();
}

class _ClienteTableState extends State<ClienteTable> with PaginationMixin {
  @override
  Widget build(BuildContext context) {
    final items = pageItems(widget.clientes);
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 700) return _buildMobileCards(items);
            return _buildDesktopTable(items);
          },
        ),
        buildPagination(widget.clientes),
      ],
    );
  }

  Widget _buildMobileCards(List<ClienteDto> items) {
    return Column(
      children: items.map((c) => MobileCardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(c.nombre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis)),
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
            _buildInfoRow('Email', c.email ?? '-'),
            _buildInfoRow('Teléfono', c.telefono ?? '-'),
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

  Widget _buildDesktopTable(List<ClienteDto> items) {
    return Container(
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
          child: const Row(children: [
            Expanded(flex: 3, child: Text('Nombre', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 13))),
            Expanded(flex: 3, child: Text('Email', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 13))),
            Expanded(flex: 2, child: Text('Teléfono', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 13))),
            Expanded(flex: 2, child: Text('RFC', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 13))),
            SizedBox(width: 76),
          ]),
        ),
        ...items.map((c) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
          child: Row(children: [
            Expanded(flex: 3, child: Text(c.nombre, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis)),
            Expanded(flex: 3, child: Text(c.email ?? '-', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
            Expanded(flex: 2, child: Text(c.telefono ?? '-', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
            Expanded(flex: 2, child: Text(c.rfc ?? '-', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
            SizedBox(
              width: 76,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () => widget.onEdit(c), color: AppColors.brandGreen, padding: EdgeInsets.zero, constraints: BoxConstraints(minWidth: 36, minHeight: 36)),
                const SizedBox(width: 4),
                IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () => widget.onDelete(c), color: AppColors.negativeRed, padding: EdgeInsets.zero, constraints: BoxConstraints(minWidth: 36, minHeight: 36)),
              ]),
            ),
          ]),
        )),
      ]),
    );
  }
}
