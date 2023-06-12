import 'package:flutter/material.dart';
import 'package:mifone_sdk_flutter/mifone_sdk_flutter.dart';
import 'numpad_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: const NumpadScreen(),
      extendBody: true,
      // bottomNavigationBar: buildMyNavBar(context),
    );
  }
}
