import 'package:flutter/material.dart';

import '../providers/auth_helper.dart';

class CoolCarAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? customTitle;
  final bool showIcons;
  const CoolCarAppBar({super.key, this.customTitle, this.showIcons = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(customTitle ?? 'CoolCar Admin'),
      centerTitle: true,
      backgroundColor: Colors.black, // 🔹 Consistent AppBar Background
      elevation: 0,
      foregroundColor: Colors.white, // 🔹 Text and Icons in White
      actions:
          showIcons
              ? [
                TextButton(
                  onPressed: () => AuthHelper.signOut(context),
                  child: const Icon(Icons.logout, color: Colors.white),
                ),
              ]
              : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
