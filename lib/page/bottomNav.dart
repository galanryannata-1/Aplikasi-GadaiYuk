import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:gadaiyuk_terbaru/page/akun.dart';
import 'package:gadaiyuk_terbaru/page/home.dart';
import 'package:gadaiyuk_terbaru/riwayat/riwayat.dart';
import 'package:gadaiyuk_terbaru/page/landscape_mode.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  List<Type> tabs = [Home, RiwayatGadai, Profil];

  int currentPage = 0;

  setPage(index) {
    setState(() {
      currentPage = index;
    });
  }

  Widget getPageWidget(int index) {
    switch (index) {
      case 0:
        return Home();
      case 1:
        return RiwayatGadai();
      case 2:
        return Profil();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: GNav(
              backgroundColor: Colors.white,
              color: Colors.grey,
              activeColor: Color(0xff4545ff),
              gap: 3,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              selectedIndex: currentPage,
              onTabChange: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                  iconSize: 24,
                ),
                GButton(
                  icon: Icons.history,
                  text: 'Riwayat',
                  iconSize: 24,
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Akun',
                  iconSize: 24,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: getPageWidget(currentPage),
      ),
    );
  }
}
