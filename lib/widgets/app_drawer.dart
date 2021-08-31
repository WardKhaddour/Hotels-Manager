import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../screens/add_hotel_screen.dart';
import '../screens/login_screen.dart';
import '../screens/my_hotels_screen.dart';
import 'drawer_item.dart';

class AppDrawer extends StatelessWidget {
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 250,
                  height: 250,
                  child: Image.asset(
                    'assets/images/tasqment-logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  'TasQment',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          DrawerItem(
              onTap: () {
                Get.back();
                Get.toNamed(AddHotelScreen.routeName);
              },
              title: 'Add Hotel',
              icon: Icons.add),
          DrawerItem(
              onTap: () {
                Get.back();

                Get.toNamed(MyHotelsScreen.routeName);
              },
              title: 'My Hotels',
              icon: Icons.my_library_books),
          DrawerItem(
              onTap: () {
                _authController.logout();
                Get.offNamed(LogInScreen.routeName);
              },
              title: 'Log Out',
              icon: Icons.logout),
          DrawerItem(
              onTap: SystemNavigator.pop,
              title: 'Exit',
              icon: Icons.exit_to_app),
          // Expanded(flex: 2, child: SizedBox())
        ],
      ),
    );
  }
}
