import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import 'package:modulos/core/widgets/responsive_layout.dart';

class ReportesScreen extends StatefulWidget {
  final int selectedNav;
  final ValueChanged<int> onNavSelect;
  const ReportesScreen({super.key, required this.selectedNav, required this.onNavSelect});
  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  String _tipoReporte = 'ventas';

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(selectedNav: widget.selectedNav, onNavSelect: widget.onNavSelect, title: 'Reportes',
      contentBuilder: (context, constraints) => _buildContent());
  }

  Widget _buildContent() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      PageHeader(title: 'Reportes y Análisis', buttonLabel: 'Exportar', onButtonPressed: () {}, buttonIcon: Icons.download),
      const SizedBox(height: 16),
      Wrap(spacing: 8, runSpacing: 8, children: [
        _chip('Ventas', 'ventas'), _chip('Productos', 'productos'), _chip('Resumen', 'resumen'),
      ]),
      const SizedBox(height: 16),
      Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
        child: Center(child: Text(
          _tipoReporte == 'ventas' ? 'Reporte de Ventas - Conectar a API'
          : _tipoReporte == 'productos' ? 'Productos Más Vendidos - Conectar a API'
          : 'Resumen del Dashboard - Conectar a API',
          style: const TextStyle(color: AppColors.textSecondary)))),
    ]);
  }

  Widget _chip(String label, String valor) {
    final sel = _tipoReporte == valor;
    return FilterChip(label: Text(label), selected: sel, onSelected: (_) => setState(() => _tipoReporte = valor),
      selectedColor: AppColors.brandGreen, checkmarkColor: Colors.white,
      labelStyle: TextStyle(color: sel ? Colors.white : AppColors.textSecondary, fontWeight: sel ? FontWeight.w600 : FontWeight.normal));
  }
}
