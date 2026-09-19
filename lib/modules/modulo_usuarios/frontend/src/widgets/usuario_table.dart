import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import 'package:modulos/core/widgets/responsive_layout.dart';
import 'package:modulos/modules/modulo_usuarios/backend/src/models/usuario_dto.dart';

class UsuarioTable extends StatefulWidget {
  final List<UsuarioDto> usuarios;
  final void Function(UsuarioDto usuario) onEdit;
  final void Function(UsuarioDto usuario) onDelete;

  const UsuarioTable({super.key, required this.usuarios, required this.onEdit, required this.onDelete});

  @override
  State<UsuarioTable> createState() => _UsuarioTableState();
}

class _UsuarioTableState extends State<UsuarioTable> with PaginationMixin {
  @override
  Widget build(BuildContext context) {
    final items = pageItems(widget.usuarios);
    return ClipRect(
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 700) return _buildMobileCards(items);
              return _buildDesktopTable(items);
            },
          ),
          buildPagination(widget.usuarios),
        ],
      ),
    );
  }

  Widget _buildMobileCards(List<UsuarioDto> items) {
    return Column(
      children: items.map((u) => MobileCardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(u.nombre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () => widget.onEdit(u), color: AppColors.brandGreen, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                    IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () => widget.onDelete(u), color: AppColors.negativeRed, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Email', u.email),
            _buildInfoRow('Rol', u.rolId),
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

  Widget _buildDesktopTable(List<UsuarioDto> items) {
    return Container(
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
          child: const Row(children: [
            Expanded(flex: 3, child: Text('Nombre', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 3, child: Text('Email', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            Expanded(flex: 2, child: Text('Rol', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
            SizedBox(width: 44),
          ])),
        ...items.map((u) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
            child: Row(children: [
              Expanded(flex: 3, child: Text(u.nombre, style: const TextStyle(color: AppColors.textPrimary))),
              Expanded(flex: 3, child: Text(u.email, style: const TextStyle(color: AppColors.textSecondary))),
              Expanded(flex: 2, child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.brandGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(u.rolId, style: const TextStyle(color: AppColors.brandGreen, fontSize: 12, fontWeight: FontWeight.w600)))),
              Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () => widget.onEdit(u), color: AppColors.brandGreen, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                const SizedBox(width: 4),
                IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () => widget.onDelete(u), color: AppColors.negativeRed, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
              ]),
            ]))),
      ]),
    );
  }
}
