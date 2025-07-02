import 'dart:convert';
import '../db/dbHelpers.dart';
import '../page/landscape_mode.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gadaiyuk_terbaru/page/bottomNav.dart';
import 'package:gadaiyuk_terbaru/gadai/setCardK.dart';

class CekStatus extends StatefulWidget {
  @override
  _CekStatusState createState() => _CekStatusState();
}

class _CekStatusState extends State<CekStatus> {
  String status = "";
   String IDP = DatabaseHelper.getUserId();


  @override
  void initState() {
    super.initState();
    fetchStatus();
  }

  void fetchStatus() async {
    final response = await http.get(
        Uri.parse('http://192.168.100.12/PA/cek.php?id=$IDP'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        status = data['status'];
      });
      _showAlertDialog(context);
    }
  }

  void _showAlertDialog(BuildContext context) {
    if (status == 'Menunggu Konfirmasi' ||
        status == 'Sedang menggadaikan' ||
        status == 'Pengecekan' ||
        status == 'Selesai' || status == 'Pengajuan Pembatalan' ||status == 'Batal' ||status == 'Tolak' ||status == 'Aktif') {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNav(),
          ));
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Peringatan",
              style: TextStyle(
                  fontWeight: FontWeight.w400, fontFamily: 'Times New Roman'),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                    'Mohon selesaikan Gadai anda terlebih dahalu',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Times New Roman'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Color(0xff4545ff)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetCardK(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Memuat...',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
