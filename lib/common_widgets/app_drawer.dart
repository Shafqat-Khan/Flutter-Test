import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: const Image(image: AssetImage('assets/icons/logo.png'))
          ),
          _createDrawerItem(Icons.home, 'Home', () {

          }),
          _createDrawerItem(Icons.settings, 'Settings', () {}),
          _createDrawerItem(Icons.logout, 'Logout', () {}),
        ],
      ),
    );
  }

  ListTile _createDrawerItem(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}
