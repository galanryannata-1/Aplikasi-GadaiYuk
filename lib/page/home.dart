import 'dart:convert';
import 'package:get/get.dart';
import '../db/dbHelpers.dart';
import 'package:intl/intl.dart';
import '../gadai/udpate/update.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gadaiyuk_terbaru/gadai/cek.dart';
import 'package:gadaiyuk_terbaru/gadai/bayar.dart';
import 'package:gadaiyuk_terbaru/gadai/lihatTanggal.dart';
import 'package:gadaiyuk_terbaru/gadai/udpate/setCardKU.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
 String IDP = DatabaseHelper.getUserId();
  NumberFormat rupiahFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
 String nama =DatabaseHelper.getNama();
  static String statusdg ="";
    static String statusdgid ="";
  static String userIdGadai = "";
  String ktpdg = '';
  String nomerdg = '';
  String namadepan = '';
  String namablkg = '';
  String katagoridg = '';
  String jenisdg = '';
  String merekdg = '';
  String hrgdg = '';
  String pnwrdg = '';
  String blndg = '';
  String tglmulaidg = '';
  String tglakhirdg = '';
  String uangprdg = '';
  String alamat = '';
  String statusTanggal = '';
  String statusdgdd = '';

  String tanggal = '';
  @override
  void initState() {
    super.initState();
    fetchStatusGadai();
  }

  

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initializeNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
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

  Future<void> onSelectNotification(String? payload) async {
    if (payload == 'notif') {}
  }



  void fetchStatusGadai() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.100.12/PA/cek.php?id=$IDP'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        statusdgid = data['status'];
      });
      _showAlertDialog(context);
    }
    } catch (e) {
      
    }
  }

  void _showAlertDialog(BuildContext context) {
    if (statusdgid == 'Sedang menggadaikan' ||
        statusdgid == 'Dikonfirmasi' ||
        statusdgid == 'Pengecekan' ||
        statusdgid == 'Aktif' ||
        statusdgid == 'Menunggu Konfirmasi' ||
        statusdgid == 'Pengajuan Pembatalan' ||
        statusdgid == 'Sudah' ||
        statusdgid == 'Batal') {
      fetchUserProfile();
    }
  }

  Future<void> fetchUserProfile() async {
    try {


      final profileUrl = 'http://192.168.100.12/PA/dataGadai.php';

      final response = await http.post(
        Uri.parse(profileUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'id': IDP.toString()},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            statusdg = data['statusDG'];
            ktpdg = data['ktp'] ?? 'Anda tidak gadai';
            nomerdg = data['nomer'] ?? 'Anda tidak gadai';
            namadepan = data['nama_depan'] ?? 'Anda tidak gadai';
            namablkg = data['nama_blkg'] ?? 'Anda tidak gadai';
            katagoridg = data['katagori'] ?? 'Anda tidak gadai';
            jenisdg = data['jenis'] ?? 'Anda tidak gadai';
            merekdg = data['merek'] ?? 'Anda tidak gadai';
            hrgdg = data['harga'] ?? 'Anda tidak gadai';
            pnwrdg = data['pnwr'] ?? 'Anda tidak gadai';
            blndg = data['cll'] ?? 'Anda tidak gadai';
            tglmulaidg = data['tgl_mulai'] ?? 'Anda tidak gadai';
            tglakhirdg = data['tgl_akhir'] ?? 'Anda tidak gadai';
            uangprdg = data['uangper'] ?? 'Anda tidak gadai';
            alamat = data['alamat'] ?? 'Anda tidak gadai';
          });
        } else {
          setState(() {
            //statusdg = 'Anda tidak gadai';
            ktpdg = 'Anda tidak Gadai';
            nomerdg = 'Anda tidak Gadai';
            namadepan = 'Anda tidak Gadai';
            namablkg = 'Anda tidak Gadai';
            katagoridg = 'Anda tidak Gadai';
            jenisdg = 'Anda tidak Gadai';
            merekdg = 'Anda tidak Gadai';
            hrgdg = 'Anda tidak Gadai';
            pnwrdg = 'nda tidak Gadai';
            blndg = 'Anda tidak Gadai';
            tglmulaidg = 'Anda tidak Gadai';
            tglakhirdg = 'Anda tidak Gadai';
            uangprdg = 'Anda tidak Gadai';
          });
        }
      } else {
        setState(() {
          // statusdg = 'Anda tidak gadai';
          ktpdg = 'Anda tidak Gadai';
          nomerdg = 'Anda tidak Gadai';
          namadepan = 'Anda tidak Gadai';
          namablkg = 'Anda tidak Gadai';
          katagoridg = 'katagAnda tidak Gadai';
          jenisdg = 'Anda tidak Gadai';
          merekdg = 'Anda tidak Gadai';
          hrgdg = 'Anda tidak Gadai';
          pnwrdg = 'nda tidak Gadai';
          blndg = 'Anda tidak Gadai';
          tglmulaidg = 'Anda tidak Gadai';
          tglakhirdg = 'Anda tidak Gadai';
          uangprdg = 'Anda tidak Gadai';
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

 

  void showRiwayatDetail() {
    bool isButtonDisabledCek = statusdg == 'Menunggu Konfirmasi' ||
        statusdg == 'Sedang menggadaikan' ||
        statusdg == 'Dikonfirmasi' ||
        statusdg == 'Dikonfirmasi' ||
        statusdg == 'Pengajuan Pembatalan' ||
        statusdg == 'Tolak' ||
        statusdg == 'Batal' ||
        statusdg == 'Aktif';
    bool isButtonDisabledbatal = statusdg == 'Pengecekan' ||
        statusdg == 'Sedang menggadaikan' ||
        statusdg == 'Dikonfirmasi' ||
        statusdg == 'Pengajuan Pembatalan' ||
        statusdg == 'Tolak' ||
        statusdg == 'Batal' ||
        statusdg == 'Aktif';
    //bool ButtonDisabled = statusdg == 'Nonaktif' || statusdg == 'Pengecekan';
    try {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 500,
            color: Colors.white,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: ListTile(
                        title: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Detail data gadai',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Times New Roman',
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const Divider(
                  height: 0,
                  color: Colors.grey,
                ),
                SizedBox(height: 5),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildDetailRow('Status', '$statusdg'),
                        _buildDetailRow('No KTP', '$ktpdg'),
                        _buildDetailRow('Katagori', '$katagoridg'),
                        _buildDetailRow('Jenis', '$jenisdg'),
                        _buildDetailRow('Merek', '$merekdg'),
                        _buildDetailRow(
                            'Harga', rupiahFormat.format(int.parse(hrgdg))),
                        _buildDetailRow('Penawaran',
                            rupiahFormat.format(int.parse(pnwrdg))),
                        _buildDetailRow('Berapa bulan', '$blndg'),
                        _buildDetailRow('Tanggal mulai', '$tglmulaidg'),
                        _buildDetailRow('Tanggal akhir', '$tglakhirdg'),
                        _buildDetailRow('Uang perbulan yang dibayarkan',
                            rupiahFormat.format(int.parse(uangprdg))),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: isButtonDisabledCek
                                  ? null
                                  : () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SetCardKU(),
                                          ));
                                    },
                              height: 30,
                              color: const Color(0xff4545ff),
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            SizedBox(width: 10),
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Tanngal(),
                                    ));
                              },
                              height: 40,
                              color: const Color(0xff4545ff),
                              child: const Text(
                                "Detail Tanggal",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            SizedBox(width: 10),
                            /*MaterialButton(
                              onPressed: isButtonDisabledbatal
                                  ? null
                                  : () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Penting !!!',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      'Times New Roman')),
                                          content: Text(
                                              'Apakah anda yakin mau membatalkan pengajuan gadai?',
                                              style: TextStyle(
                                                fontFamily: 'Times New Roman',
                                                fontWeight: FontWeight.w300,
                                              )),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Tidak',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Times New Roman',
                                                      color: Colors.red)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('OK',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Times New Roman',
                                                      color:
                                                          Color(0xff4545ff))),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                update();
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                              height: 30,
                              color: const Color(0xff4545ff),
                              child: Text(
                                'Batal',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),*/
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Penting!!!",
              style: TextStyle(
                  fontWeight: FontWeight.w400, fontFamily: 'Times New Roman'),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                    'Anda tidak gadai',
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
    }
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              '$label',
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              ':',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> update() async {
    String Gstatus = "Pembatalan";
    try {
      final url =
          'http://192.168.100.12/PA/updateStatusGadaiRandom.php';
      final data = {'idpng': IDP.toString(), 'statusdg': Gstatus.toString()};

      final response = await http.post(Uri.parse(url), body: data);
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
      } else {
        // Registrasi gagal
        setState(() {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Penting !!!',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Times New Roman')),
              content: Text('Pengajuan batal gagal',
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
            content: Text('$e',
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

  Widget build(BuildContext context) {
    bool isButtonDisabled = statusdgid == 'Tidak menggadaikan' ||
        statusdgid == 'Selesai' ||
        statusdgid == 'Sudah' ||
        statusdgid == 'Batal' ||
        statusdgid == 'Tolak' ||
        statusdgid == 'Diaktifkan';
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(
          "Selamat Datang, $nama",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Times New Roman',
          ),
        ),
        backgroundColor: Color(0xff4545ff),
        centerTitle: false,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipPath(
              clipper: ClipPathClass(),
              child: Container(
                height: MediaQuery.of(context).size.height / 7,
                //width: Get.width,
                color: Color(0xff4545ff),
              ),
            ),
          SafeArea(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CekStatus()),
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/gadai.png',
                                    fit: BoxFit.contain,
                                    width: MediaQuery.of(context).size.width * 0.12,
                                    height: MediaQuery.of(context).size.width * 0.12,
                                  ),
                                ),
                                SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CekStatus()),
                                    );
                                  },
                                  child: Text(
                                    'Gadai Barang Yuk',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.upload, size: 30),
                                  color: Color(0xff4545ff),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => uploadBayar()),
                                    );
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => uploadBayar()),
                                    );
                                  },
                                  child: Text(
                                    'Upload Bukti Transfer',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: 140),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Informasi Gadai",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff4545ff),
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // Kolom Status
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Status",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Times New Roman',
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "$statusdgid",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Times New Roman',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: MaterialButton(
                                onPressed: isButtonDisabled ? null : showRiwayatDetail,
                                height: 40,
                                color: Color(0xff4545ff),
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  "Detail",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          ],
        ),
      ),
    );
  }
}

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
