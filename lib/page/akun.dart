import 'dart:convert';
import 'bottomNav.dart';
import '../db/dbHelpers.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gadaiyuk_terbaru/auth/signIn.dart';
import 'package:gadaiyuk_terbaru/page/updateakun.dart';


class Profil extends StatefulWidget {
  const Profil({super.key});

_ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String nama = '';
  String namaDepan = '';
  String nomer = '';
  String alamat = '';
     String IDP = DatabaseHelper.getUserId();
  static String idg = DatabaseHelper.getIddg();
@override
      void initState() {
    super.initState();
    fetchUserProfile();
    
  }




  Future<void> _refreshData() async {
    // Tempatkan kode Anda di sini untuk memperbarui data
    // Misalnya, panggil fungsi untuk memperbarui data dari server

    // Tunggu beberapa waktu palsu untuk simulasi
    await Future.delayed(Duration(seconds: 2));

    // Setelah selesai memperbarui data, panggil setState untuk membangkitkan ulang UI
    setState(() {
      fetchUserProfile();
    });
  }
  

  Future<void> fetchUserProfile() async {
    try {
      final profileUrl = 'http://192.168.100.12/PA/dataPengguna.php';

    final response = await http.post(
      Uri.parse(profileUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'id': IDP},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
         namaDepan = data['nama_depan'];
         nama = data['nama_blkg'];
         nomer= data['nomer'];
         alamat= data['alamat'];
        });
      } else {
        setState(() {
         namaDepan = '';
         nama = '';
         nomer= '';
         alamat= '';
        });
      }
    } else {
      setState(() {
       namaDepan = '';
       nama = '';
       nomer= '';
       alamat= '';
      });
    }
    } catch (e) {
         AlertDialog(
          title: Text('Penting !!!',
              style: TextStyle(
                  fontWeight: FontWeight.w400, fontFamily: 'Times New Roman')),
          content: Text('Mohon tunggu sebentar',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w300,
              )),
          actions: <Widget>[
            TextButton(
              child: Text('OK',
                  style: TextStyle(
                      fontFamily: 'Times New Roman', color: Color(0xff4545ff))),
              onPressed: () {
                Navigator.of(context).pop();
                
              },
            ),
          ],
        );
      
      
    }
  }

  void logoutUser() {
    DatabaseHelper.clearUserData();
    Navigator.of(context).pop();
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => Login(),
    ));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile', style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xff4545ff),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.only(top: 16),
         child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$namaDepan $nama',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0),
                Text(
                  '$nomer',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0),
                Text(
                  '$alamat',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.0),
                Card(
                    child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Iconsax.user, color: Color(0xff4545ff)),
                      title: Text('Update Akun'),
                      onTap: (){
                         Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProfil(),
                      ));
                      }
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.logout, color: Color(0xff4545ff)),
                      title: Text('Keluar'),
                      onTap: () {
                         logoutUser();             
                      },
                    ),
                  ],
                )),
              ],
            ),
          ),
         ),
        ));
  }
}
