import 'dart:convert';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gadaiyuk_terbaru/auth/OTP.dart';
import 'package:gadaiyuk_terbaru/auth/signIn.dart';
import 'package:gadaiyuk_terbaru/page/landscape_mode.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _LnamaController = TextEditingController();
  TextEditingController _FnamaController = TextEditingController();
  TextEditingController _nomerController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isObscurePassword = true;
  bool isLoading = false;

  Future<void> _register() async {
    try {
      final url = 'http://192.168.100.12/PA/regis.php';

      final data = {
        'Fnama': _FnamaController.text,
        'Lnama': _LnamaController.text,
        'alamat': _alamatController.text,
        'nomer': _nomerController.text,
        'password': _passwordController.text,
      };

      final response = await http.post(Uri.parse(url), body: data);
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        // Registrasi berhasil
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OTP()),
        );
      } else if (responseData['status'] == 'pngs') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Register Gagal',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Times New Roman')),
            content: Text('Akun Sudah Ada',
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
      } else {
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
        appBar: null,
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
                    height: 60,
                  ),
                  Text(
                    'Buat Akun',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Times New Roman'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    cursorColor: const Color(0xff4545ff),
                    controller: _FnamaController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0.0),
                      labelText: 'Nama Depan',
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
                      prefixIcon: const Icon(
                        Iconsax.user,
                        color: Color(0xff4545ff),
                        size: 18,
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
                  TextField(
                    cursorColor: const Color(0xff4545ff),
                    controller: _LnamaController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0.0),
                      labelText: 'Nama Belakang',
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
                      prefixIcon: const Icon(
                        Iconsax.user,
                        color: Color(0xff4545ff),
                        size: 18,
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
                  TextField(
                    cursorColor: const Color(0xff4545ff),
                    keyboardType: TextInputType.phone,
                    controller: _nomerController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0.0),
                      labelText: 'Nomer Hp',
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
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: Color(0xff4545ff),
                        size: 18,
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
                  TextField(
                    cursorColor: const Color(0xff4545ff),
                    controller: _alamatController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0.0),
                      labelText: 'Alamat',
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
                      prefixIcon: const Icon(
                        Icons.home,
                        color: Color(0xff4545ff),
                        size: 18,
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
                  TextField(
                    cursorColor: const Color(0xff4545ff),
                    obscureText: _isObscure,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0.0),
                      labelText: 'Password',
                      hintText: 'Masukan Password',
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          }),
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                      labelStyle: const TextStyle(
                          color: Color(0xff4545ff),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Times New Roman'),
                      prefixIcon: const Icon(
                        Iconsax.key,
                        color: Color(0xff4545ff),
                        size: 18,
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
                  TextField(
                    cursorColor: const Color(0xff4545ff),
                    obscureText: _isObscurePassword,
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0.0),
                      labelText: 'Konfirmasi Password',
                      hintText: 'Masukan Konfirmasi Password',
                      suffixIcon: IconButton(
                          icon: Icon(_isObscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isObscurePassword = !_isObscurePassword;
                            });
                          }),
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                      labelStyle: const TextStyle(
                        color: Color(0xff4545ff),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: const Icon(
                        Iconsax.key,
                        color: Color(0xff4545ff),
                        size: 18,
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
                          _nomerController.text.isEmpty ||
                          _passwordController.text.isEmpty ||
                          _confirmPasswordController.text.isEmpty) {
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
                                  _passwordController.clear();
                                  _confirmPasswordController.clear();
                                },
                              ),
                            ],
                          ),
                        );
                      } else if (_passwordController.text.length < 6) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Times New Roman')),
                            content: Text(
                                'Password tidak boleh kurang dari 6 karakter',
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
                                  _passwordController.clear();
                                  _confirmPasswordController.clear();
                                },
                              ),
                            ],
                          ),
                        );
                      } else if (_confirmPasswordController.text.length < 6) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Times New Roman')),
                            content: Text(
                                'Password tidak boleh kurang dari 6 karakter',
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
                                  _passwordController.clear();
                                  _confirmPasswordController.clear();
                                },
                              ),
                            ],
                          ),
                        );
                      } else if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Times New Roman')),
                            content: Text('Konfirmasi password tidak cocok',
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
                                  _passwordController.clear();
                                  _confirmPasswordController.clear();
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        await _register();
        
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
                            'Daftar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'Times New Roman',
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Apakah sudah punya akun?',
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Times New Roman'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _LnamaController.clear();
                          _FnamaController.clear();
                          _nomerController.clear();
                          _passwordController.clear();
                          _confirmPasswordController.clear();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ));
                        },
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                              color: Color(0xff4545ff),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Times New Roman'),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              )
            ),
        ), 
        );
  }
}
