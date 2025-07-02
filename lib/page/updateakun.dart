import 'dart:convert';
import '../db/dbHelpers.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gadaiyuk_terbaru/auth/OTP.dart';
import 'package:gadaiyuk_terbaru/auth/signIn.dart';
import 'package:gadaiyuk_terbaru/page/bottomNav.dart';
import 'package:gadaiyuk_terbaru/page/landscape_mode.dart';



class UpdateProfil extends StatefulWidget {
  const UpdateProfil({Key? key}) : super(key: key);

  @override
  _UpdateProfilState createState() => _UpdateProfilState();
}

class _UpdateProfilState extends State<UpdateProfil> {
  TextEditingController _LnamaController = TextEditingController();
  TextEditingController _FnamaController = TextEditingController();
  TextEditingController _nomerController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  bool _isObscure = true;
  bool _isObscurePassword = true;
  bool isLoading = false;

  String IDP = DatabaseHelper.getUserId();
   @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }
  
  Future<void> fetchUserProfile() async {
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
          _FnamaController.text = data['nama_depan'];
         _LnamaController.text = data['nama_blkg'];
          _nomerController.text = data['nomer'];
          _alamatController.text = data['alamat'];
        });
      } else {
        setState(() {
          _FnamaController.text = '';
         _LnamaController.text = '';
          _nomerController.text = '';
          _alamatController.text = '';
        });
      }
    } else {
      setState(() {
        _FnamaController.text = '';
       _LnamaController.text = '';
        _nomerController.text = '';
        _alamatController.text = '';
      });
    }
  }

   Future<void> update() async {
    try {
      final url = 'http://192.168.100.12/PA/updateAkun.php';

      final data = {
        'idpng' : IDP.toString(),
        'Fnama': _FnamaController.text,
        'Lnama': _LnamaController.text,
        'alamat': _alamatController.text,
        'nomer': _nomerController.text,
      };

      final response = await http.post(Uri.parse(url), body: data);
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        // Registrasi berhasil
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BottomNav()),
        );
      }else {
        // Registrasi gagal
        setState(() {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Register Gagal',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Times New Roman')),
              content: Text('Register Gagal',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.w300,
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('OK',
                      style: TextStyle(
                          fontFamily: 'Times New Roman',
                          color: Color(0xff4545ff))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erorr',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w400,
                )),
            content: Text('Server error',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w300,
                )),
            actions: <Widget>[
              TextButton(
                child: Text('OK',
                    style: TextStyle(
                        fontFamily: 'Times New Roman',
                        color: Color(0xff4545ff))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
          title: Text('Update Profil', style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xff4545ff),
          centerTitle: true,
           leading: new IconButton(
                icon: new Icon(Icons.arrow_back_ios_new,color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNav(),
                      ));
                }),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nama Depan',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  TextField(
                    cursorColor: const Color(0xff4545ff),
                    controller: _FnamaController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      hintText: 'Masukan Nama Depan',
                      labelStyle: const TextStyle(
                          color: Color(0xff4545ff),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Times New Roman'),
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade200, width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xff4545ff),
                        fontSize: 18.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff4545ff), width: 1.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nama Belakang',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  TextField(
                    cursorColor: const Color(0xff4545ff),
                    controller: _LnamaController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      hintText: 'Masukan Nama Belakang',
                      labelStyle: const TextStyle(
                          color: Color(0xff4545ff),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Times New Roman'),
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                     
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade200, width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xff4545ff),
                        fontSize: 18.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff4545ff), width: 1.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nomer HP',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  TextField(
                    cursorColor: const Color(0xff4545ff),
                    keyboardType: TextInputType.phone,
                    controller: _nomerController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      hintText: 'Masukan Nomer Hp',
                      hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                          fontFamily: 'Times New Roman'),
                      labelStyle: const TextStyle(
                        color: Color(0xff4545ff),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                     
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade200, width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xff4545ff),
                        fontSize: 18.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff4545ff), width: 1.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Alamat',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  TextField(
                    cursorColor: const Color(0xff4545ff),
                    controller: _alamatController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      hintText: 'Masukan Alamat',
                      hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                          fontFamily: 'Times New Roman'),
                      labelStyle: const TextStyle(
                        color: Color(0xff4545ff),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade200, width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xff4545ff),
                        fontSize: 18.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff4545ff), width: 1.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_LnamaController.text.isEmpty ||
                          _FnamaController.text.isEmpty ||
                          _alamatController.text.isEmpty ||
                          _nomerController.text.isEmpty ) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'Error',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Times New Roman'),
                            ),
                            content: const Text('Harap lengkapi semua data',
                                style: TextStyle(
                                    fontFamily: 'Times New Roman',
                                    fontWeight: FontWeight.w300)),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK',
                                    style: TextStyle(
                                        fontFamily: 'Times New Roman',
                                        color: Color(0xff4545ff))),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _LnamaController.clear();
                                  _nomerController.clear();
                                  _alamatController.clear();
                                 
                                },
                              ),
                            ],
                          ),
                        );
                      }else {
                        setState(() {
                          isLoading = true;
                        });
                        await update();
        
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff4545ff),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 50),
                      minimumSize: Size(0, 45),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'Simpan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'Times New Roman',
                            ),
                          ),
                  ),
                ],
              ),
              )
            ),
        ), 
        );
  }
}
