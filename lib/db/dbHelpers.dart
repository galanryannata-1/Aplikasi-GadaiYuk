import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseHelper {
  static String userId = '';
  static String userIdGadai = '';
  static String nama = '';
  static String statusdg = '';
  static String namaBelakang = '';
  static String nomer123 = '';
  static String alamat = '';

 static void clearUserData() {
  userId = '';
  userIdGadai = '';
  nama = '';
  statusdg = '';
  namaBelakang = '';
  nomer123 = '';
  alamat = '';
}
 static Future<bool> loginUser(String nomer, String password) async {
    final url = 'http://192.168.100.12/PA/login.php';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'nomer': nomer, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        userId = data['id'];
        nama = data['nama'];
        namaBelakang= data['namaBelakang'];
        nomer123 = data['nomer123'];
        alamat = data['alamat'];// Simpan ID pengguna ke variabel statis
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception('Gagal melakukan login');
    }
  }

  static String getUserId() {
    return userId;
  }

  static String getNama() {
    return nama;
  }

  static String getStatus() {
    return statusdg;
  } 

  static String getIddg(){
    return userIdGadai;
  }

  static String getNomer(){
    return nomer123;
  }

  static String getnamaBelakang(){
    return namaBelakang;
  }

  static String getAlamat(){
    return alamat;
  }

  
  
  
}
