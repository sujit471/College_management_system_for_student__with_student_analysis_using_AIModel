import 'dart:async';

import 'package:college_management_app/Notification/notification.dart';
import 'package:college_management_app/Search/searching.dart';
import 'package:college_management_app/Userprofile/profile.dart';
import 'package:college_management_app/Welcome_UI/wel_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import'package:college_management_app/login_UI_yt/logintry.dart';

class NavigationMenu extends StatelessWidget {
   NavigationMenu({Key? key,  }) : super(key: key);

  @override
  Widget build(BuildContext) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        ()=> NavigationBar(
          height : 80,
          elevation :0,
          selectedIndex: controller.selectedIndex.value,
           onDestinationSelected: (index)=>controller.selectedIndex.value=index,
          destinations:const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.notification), label: 'Updates'),
            NavigationDestination(icon: Icon(Iconsax.medal), label: 'Predictor'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),


          ],
        ),
      ),

      body:Obx (()=>controller.screens[controller.selectedIndex.value]),
    );
  }
}
class NavigationController extends GetxController{

  late User user;
  final Rx<int> selectedIndex = 0.obs;
  final screens =[const YourApp(),const Notifications(), const Search(),Profile1(user: FirebaseAuth.instance.currentUser!)];
}
