import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'sidebar.dart';
import 'dashboard_top_bar.dart';

/// Layout responsive compartido para todas las screens.
/// Maneja desktop (sidebar inline), tablet y mobile (drawer + bottom nav).
class ResponsiveLayout extends StatelessWidget {
  final int selectedNav;
  final ValueChanged<int> onNavSelect;
  final String title;
  final Widget Function(BuildContext context, BoxConstraints constraints) contentBuilder;
  final Widget? floatingActionButton;

  const ResponsiveLayout({
    super.key,
    required this.selectedNav,
    required this.onNavSelect,
    required this.title,
    required this.contentBuilder,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      drawer: FullDrawer(selectedIndex: selectedNav, onSelect: (i) {
        onNavSelect(i);
        Navigator.pop(context);
      }),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1100;

          if (isDesktop) {
            return Row(
              children: [
                Sidebar(selectedIndex: selectedNav, onSelect: onNavSelect),
                Expanded(child: _buildContent(context, constraints, showMenuButton: false)),
              ],
            );
          }

          return _buildContent(context, constraints, showMenuButton: true);
        },
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 1100) return const SizedBox.shrink();
          return MobileBottomNav(
            selectedIndex: selectedNav,
            onSelect: onNavSelect,
            onMoreTap: () => Scaffold.of(context).openDrawer(),
          );
        },
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildContent(BuildContext context, BoxConstraints constraints, {required bool showMenuButton}) {
    final isMobile = constraints.maxWidth < 700;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardTopBar(
              title: title,
              showMenuButton: showMenuButton,
              onMenuTap: () => Scaffold.of(context).openDrawer(),
            ),
            const SizedBox(height: 22),
            contentBuilder(context, constraints),
          ],
        ),
      ),
    );
  }
}

/// Header de página responsive: título + botón de acción.
/// En mobile se apila verticalmente, en desktop va en fila.
class PageHeader extends StatelessWidget {
  final String title;
  final int count;
  final String buttonLabel;
  final VoidCallback? onButtonPressed;
  final IconData? buttonIcon;

  const PageHeader({
    super.key,
    required this.title,
    this.count = 0,
    required this.buttonLabel,
    this.onButtonPressed,
    this.buttonIcon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 500;
        final titleText = count > 0 ? '$title ($count)' : title;

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(titleText,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              if (onButtonPressed != null)
                ElevatedButton.icon(
                  onPressed: onButtonPressed,
                  icon: Icon(buttonIcon, size: 18),
                  label: Text(buttonLabel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(titleText,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  overflow: TextOverflow.ellipsis),
            ),
            if (onButtonPressed != null) ...[
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: onButtonPressed,
                icon: Icon(buttonIcon, size: 18),
                label: Text(buttonLabel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Contenedor reutilizable para cards en mobile.
class MobileCardContainer extends StatelessWidget {
  final Widget child;
  const MobileCardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: child,
    );
  }
}

/// Controles de paginación reutilizables.
class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(Icons.chevron_left, currentPage > 1 ? currentPage - 1 : null),
          const SizedBox(width: 8),
          ...List.generate(totalPages, (i) {
            final page = i + 1;
            final isSelected = page == currentPage;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: GestureDetector(
                onTap: () => onPageChanged(page),
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.brandGreen : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected ? null : Border.all(color: AppColors.cardBorder),
                  ),
                  child: Text(
                    '$page',
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(width: 8),
          _buildButton(Icons.chevron_right, currentPage < totalPages ? currentPage + 1 : null),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, int? page) {
    return GestureDetector(
      onTap: page != null ? () => onPageChanged(page) : null,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: page != null ? AppColors.cardBg : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Icon(icon, size: 20, color: page != null ? AppColors.textSecondary : AppColors.cardBorder),
      ),
    );
  }
}

/// Mixin que agrega paginación a cualquier State con lista.
mixin PaginationMixin<T extends StatefulWidget> on State<T> {
  int _currentPage = 1;
  int _itemsPerPage = 10;

  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;

  int pageCount<T>(List<T> list) => (list.length / _itemsPerPage).ceil();
  List<T> pageItems<T>(List<T> list) {
    final start = (_currentPage - 1) * _itemsPerPage;
    final end = (start + _itemsPerPage).clamp(0, list.length);
    return list.sublist(start, end);
  }

  void goToPage(int page) => setState(() => _currentPage = page);

  /// Reset page to 1 when list changes (call after cargarDatos, etc.)
  void resetPage() => _currentPage = 1;

  Widget buildPagination<T>(List<T> list) {
    final pages = pageCount(list);
    return PaginationControls(
      currentPage: _currentPage,
      totalPages: pages,
      onPageChanged: goToPage,
    );
  }
}

/// Wrapper responsive para tablas: scroll horizontal si el contenido excede el ancho.
class ResponsiveTableWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveTableWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: child,
    );
  }
}
