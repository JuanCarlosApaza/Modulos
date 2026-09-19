import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NavItem {
  final IconData icon;
  final String label;
  const NavItem(this.icon, this.label);
}

const List<NavItem> navItems = [
  NavItem(Icons.grid_view_rounded, 'Dashboard'),
  NavItem(Icons.people_rounded, 'Usuarios'),
  NavItem(Icons.inventory_2_rounded, 'Productos'),
  NavItem(Icons.groups_rounded, 'Clientes'),
  NavItem(Icons.shopping_cart_rounded, 'Ventas'),
  NavItem(Icons.calendar_month_rounded, 'Citas'),
  NavItem(Icons.warehouse_rounded, 'Inventario'),
  NavItem(Icons.analytics_rounded, 'Reportes'),
  NavItem(Icons.notifications_rounded, 'Notificaciones'),
  NavItem(Icons.settings_rounded, 'Configuración'),
];

/// Items principales para el bottom nav (máximo 5)
const List<NavItem> bottomNavItems = [
  NavItem(Icons.grid_view_rounded, 'Inicio'),
  NavItem(Icons.groups_rounded, 'Clientes'),
  NavItem(Icons.shopping_cart_rounded, 'Ventas'),
  NavItem(Icons.inventory_2_rounded, 'Productos'),
  NavItem(Icons.menu_rounded, 'Más'),
];

/// Mapeo de bottom nav index a screen index
const Map<int, int> bottomNavToScreen = {
  0: 0, // Dashboard
  1: 3, // Clientes
  2: 4, // Ventas
  3: 2, // Productos
};

/// Vertical sidebar shown on desktop layouts.
class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const Sidebar({super.key, required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: AppColors.sidebarBg,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.brandGreen,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.eco_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'AeuxGlobal',
                style: TextStyle(
                  color: AppColors.textOnDark,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'NAVIGATION',
              style: TextStyle(
                color: AppColors.textOnDarkMuted,
                fontSize: 11,
                letterSpacing: 1.1,
              ),
            ),
          ),
          ...List.generate(navItems.length, (i) {
            final item = navItems[i];
            final selected = i == selectedIndex;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onSelect(i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.brandGreen : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          size: 19,
                          color: selected ? Colors.white : AppColors.textOnDarkMuted,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item.label,
                          style: TextStyle(
                            color: selected ? Colors.white : AppColors.textOnDarkMuted,
                            fontSize: 14,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          const Divider(color: Color(0xFF1B4437), height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.brandGreen,
                child: Text('AW', style: TextStyle(color: Colors.white, fontSize: 13)),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Alex Williamson',
                        style: TextStyle(color: AppColors.textOnDark, fontSize: 13, fontWeight: FontWeight.w600)),
                    Text('#dela-1974',
                        style: TextStyle(color: AppColors.textOnDarkMuted, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Bottom navigation bar - máximo 5 items, el último abre el drawer
class MobileBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback? onMoreTap;

  const MobileBottomNav({super.key, required this.selectedIndex, required this.onSelect, this.onMoreTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex.clamp(0, bottomNavItems.length - 1),
      onTap: (index) {
        if (index == bottomNavItems.length - 1) {
          onMoreTap?.call();
        } else {
          final screenIndex = bottomNavToScreen[index];
          if (screenIndex != null) onSelect(screenIndex);
        }
      },
      backgroundColor: AppColors.sidebarBg,
      selectedItemColor: AppColors.brandGreen,
      unselectedItemColor: AppColors.textOnDarkMuted,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      items: bottomNavItems
          .map((item) => BottomNavigationBarItem(icon: Icon(item.icon), label: item.label))
          .toList(),
    );
  }
}

/// Drawer completo con todos los módulos (para mobile)
class FullDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const FullDrawer({super.key, required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.sidebarBg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.brandGreen,
                    child: Text('AW', style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AeuxGlobal', style: TextStyle(color: AppColors.textOnDark, fontSize: 16, fontWeight: FontWeight.w700)),
                      Text('Panel de Control', style: TextStyle(color: AppColors.textOnDarkMuted, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF1B4437), height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                itemCount: navItems.length,
                itemBuilder: (context, i) {
                  final item = navItems[i];
                  final selected = i == selectedIndex;
                  return ListTile(
                    leading: Icon(item.icon, color: selected ? AppColors.brandGreen : AppColors.textOnDarkMuted, size: 22),
                    title: Text(item.label, style: TextStyle(
                      color: selected ? AppColors.brandGreen : AppColors.textOnDark,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    )),
                    selected: selected,
                    selectedTileColor: AppColors.brandGreen.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onTap: () {
                      onSelect(i);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
