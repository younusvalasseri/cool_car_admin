import 'package:cool_car_admin/Widgets/app_colors.dart';
import 'package:flutter/material.dart';
import '../Main/admin_profile_page.dart';
import '../Main/settings_page.dart';
import '../Main/support_page.dart';
import '../views/active_users_page.dart';
import '../views/trip_history_page.dart';
import '../views/cool_car_revenue.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.black),
              child: Center(
                child: Text(
                  "Admin Panel",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _buildMenuItem(
              title: "User Management",
              context: context,
              page: const ActiveUsersPage(),
            ),
            _buildMenuItem(
              title: "Rental History",
              context: context,
              page: const TripHistoryPage(),
            ),
            _buildMenuItem(
              title: "Reports",
              context: context,
              page: const CoolCarRevenuePage(),
            ),
            _buildMenuItem(
              title: "Settings",
              context: context,
              page: const SettingsPage(),
            ),
            _buildMenuItem(
              title: "Support",
              context: context,
              page: const SupportPage(),
            ),
            _buildMenuItem(
              title: "Admin Profile Page",
              context: context,
              page: const AdminProfilePage(),
            ),
          ],
        ),
      ),
    );
  }

  /// **🔹 Menu Item Builder with Navigation**
  Widget _buildMenuItem({
    required String title,
    required BuildContext context,
    required Widget page,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: AppColors.white, fontSize: 18),
      ),
      onTap: () {
        Navigator.pop(context); // ✅ Closes the sidebar
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}
