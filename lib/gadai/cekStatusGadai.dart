import 'dart:math';
import 'dart:async';
import 'dart:convert';
import '../db/dbHelpers.dart';
import '../page/landscape_mode.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gadaiyuk_terbaru/page/bottomNav.dart';
import 'package:gadaiyuk_terbaru/gadai/setCardK.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CekStatusGadai extends StatefulWidget {
  @override
  _CekStatusGadaiState createState() => _CekStatusGadaiState();
}

class _CekStatusGadaiState extends State<CekStatusGadai> {
  String status = "";
   String IDP = DatabaseHelper.getUserId();
   String userIdGadai = DatabaseHelper.getIddg();
  Timer? _timer;
  String tanggal = '';
  String statusdg = '';


  @override
  void initState() {
    super.initState();
    fetchStatus();
    initializeNotifications();
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

  

  
  void checkDate() async {
    try {
      final url = 'http://192.168.100.12/PA/aktifkan.php?id=$IDP';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        tanggal = data['tanggal'];
        statusdg = data['status'];

        final currentDate = DateTime.now();
        final targetDate = DateTime.parse(tanggal);
        final difference = targetDate.difference(currentDate).inDays;

        if (difference >= - 3 &&difference == 0) {
             if (statusdg == 'Ditolak'){
            showNotifTolak();
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNav(),
                ));
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Penting'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        'bukti transfer anda ditolak silahkan upload ulang'),
                  ],
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
              ),
            );
          } else if(statusdg == 'Diterima'){
            update();
            showNotifterima();
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNav(),
                ));
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Penting'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        'Bukti transfer anda diterima'),
                  ],
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
              ),
            );
            
          }
           else if(statusdg == 'Belum Bayar'){
          showNotification();
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNav(),
              ));
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Penting'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Hari ini waktunya untuk bayar tanggal $tanggal Status $statusdg'),
                ],
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
            ),
          );
        }
      }else{
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNav(),
              ));
        }
      } else {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNav(),
            ));
      }
    } catch (e) {
       Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNav(),
            ));
      
    }
  }

   Future<void> update() async {
    try {
      final url = 'http://192.168.100.12/PA/updateStatusBayar.php';
      final data = {
        'idpng': IDP.toString(),
        'tanggal': tanggal.toString(),
     
      };

      final response = await http.post(Uri.parse(url), body: data);
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {

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

  Future<void> updateGadai() async {
    String sts = "Sedang menggadaikan";
    try {
      final url = 'http://192.168.100.12/PA/updateStatusGadaiAktif.php';
      final data = {
        'idpng': IDP.toString(),
       'statusdg': "Sedang menggadaikan"
      };

      final response = await http.post(Uri.parse(url), body: data);
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNav(),
            ));
        showNotifaktif();
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Selamat',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Times New Roman')),
              content: Text('Selamat pengajuan gadai anda di terima jangan lupa bayar angsuran setiap bulan',
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



  /*void checkDate() async {
    try {
      final url = 'http://192.168.100.12/PA/aktifkan.php?id=$IDP';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        tanggal = data['tanggal'];
        statusdg = data['status'];

        final currentDate = DateTime.now();
        final targetDate = DateTime.parse(tanggal);
        final difference = targetDate.difference(currentDate).inDays;

        if (difference == 0) {
          showNotification();
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNav(),
              ));
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Penting'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Hari waktunya bayar cicilan'),
                ],
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
            ),
          );
        } else {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNav(),
              ));
        }
      } else {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNav(),
            ));
      }
    } catch (e) {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNav(),
          ));
    }
  }*/

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initializeNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('notif_channel', 'Notif Channel',
            importance: Importance.high, priority: Priority.high);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Penting!!!',
      'Hari ini waktunya untuk bayar tanggal $tanggal Status $statusdg',
      platformChannelSpecifics,
      payload: 'notif',
    );
  }

  Future<void> showNotifMB() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('notif_channel', 'Notif Channel',
            importance: Importance.high, priority: Priority.high);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Penting!!!',
      'Upload foto berhasil, bukti transfer anda sedang cek',
      platformChannelSpecifics,
      payload: 'notif',
    );
  }

   Future<void> showNotifTolak() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('notif_channel', 'Notif Channel',
            importance: Importance.high, priority: Priority.high);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Penting!!!',
      'bukti transfer anda ditolak silahkan upload ulang',
      platformChannelSpecifics,
      payload: 'notif',
    );
  }

  Future<void> showNotifterima() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('notif_channel', 'Notif Channel',
            importance: Importance.high, priority: Priority.high);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Penting!!!',
      'bukti transfer anda diterima',
      platformChannelSpecifics,
      payload: 'notif',
    );
  }

   Future<void> showNotifaktif() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('notif_channel', 'Notif Channel',
            importance: Importance.high, priority: Priority.high);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Penting!!!',
      'Selamat pengajuan gadai anda di terima jangan lupa bayar cicilan setiap bulan',
      platformChannelSpecifics,
      payload: 'notif',
    );
  }

  Future<void> showNotifbatal() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('notif_channel', 'Notif Channel',
            importance: Importance.high, priority: Priority.high);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Penting!!!',
      'Pembatalan gadai anda sukses',
      platformChannelSpecifics,
      payload: 'notif',
    );
  }

  Future<void> showNotifTolakGadai() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('notif_channel', 'Notif Channel',
            importance: Importance.high, priority: Priority.high);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Penting!!!',
      'Maaf pengajuan anda ditolak',
      platformChannelSpecifics,
      payload: 'notif',
    );
  }

  Future<void> showNotifselesai() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('notif_channel', 'Notif Channel',
            importance: Importance.high, priority: Priority.high);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Penting!!!',
      'Selamat anda telah menyelesaikan gadai anda',
      platformChannelSpecifics,
      payload: 'notif',
    );
  }

  Future<void> showNotisetuju() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('notif_channel', 'Notif Channel',
            importance: Importance.high, priority: Priority.high);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Penting!!!',
      'Data gadai anda sudah dikonfirmasi',
      platformChannelSpecifics,
      payload: 'notif',
    );
  }
   Future<void> showNotifcek() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('notif_channel', 'Notif Channel',
            importance: Importance.high, priority: Priority.high);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Penting!!!',
      'Silahkan dicek data anda kembali',
      platformChannelSpecifics,
      payload: 'notif',
    );
  }


  Future<void> onSelectNotification(String? payload) async {
    if (payload == 'notif') {}
  }

  Future<void> updateGadiSelesai() async {
    try {
      final url = 'http://192.168.100.12/PA/updateStatusGadaiSudah.php';
      final data = {
        'idpng': IDP.toString(),
       'statusdg': "Selesai"
      };

      final response = await http.post(Uri.parse(url), body: data);
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        deleteData();
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
  
  void deleteData() async {
    final url = 'http://192.168.100.12/PA/deletebayar.php';
    final response = await http.post(
      Uri.parse(url),
      body: {'id': IDP.toString()},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNav(),
            ));
          showNotifselesai();
         showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Selamat',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Times New Roman')),
              content: Text('Selamat anda telah menyelesaikan gadai anda ',
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
      // Tangani kesalahan jika ada
    }
  }

 


  void deleteDataBatal() async {
    final url = 'http://192.168.100.12/PA/deletebayar.php';
    final response = await http.post(
      Uri.parse(url),
      body: {'id': IDP.toString()},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String status = data['status'];
      String message = data['message'];
      _hapusdatagadaiBatal();
    } else {
      // Tangani kesalahan jika ada
    }
  }

  Future<void> _hapusdatagadaiBatal() async {
    try {
      final url = 'http://192.168.100.12/PA/hapusdatagadai.php';
      final data = {
        'id': IDP.toString(),
        //'iddg': userIdGadai.toString(),
      };

      final response = await http.post(Uri.parse(url), body: data);
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNav(),
            ));
      showNotifbatal();
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Penting',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w400,
                )),
            content: Text('Pembatalan gadai anda sukses',
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
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNav(),
            ));
      }
    } catch (e) {
      /*setState(() {
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
      });*/
    }
  }

   void deleteDataTolak() async {
    final url = 'http://192.168.100.12/PA/deletebayar.php';
    final response = await http.post(
      Uri.parse(url),
      body: {'id': IDP.toString()},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String status = data['status'];
      String message = data['message'];
      _hapusdatagadaiTolak();
    } else {
      // Tangani kesalahan jika ada
    }
  }

  Future<void> _hapusdatagadaiTolak() async {
    try {
      final url = 'http://192.168.100.12/PA/hapusdatagadai.php';
      final data = {
        'id': IDP.toString(),
        //'iddg': userIdGadai.toString(),
      };

      final response = await http.post(Uri.parse(url), body: data);
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNav(),
            ));
      showNotifTolakGadai();
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Penting',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w400,
                )),
            content: Text('Maaf pengajuan anda ditolak',
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
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNav(),
            ));
      }
    } catch (e) {
      /*setState(() {
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
      });*/
    }
  }


  void _showAlertDialog(BuildContext context) {
    if (status == 'Sedang menggadaikan') {
      checkDate();
    } else if(status == 'Aktif'){ Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNav(),
                ));}
    else if(status == 'Menunggu Konfirmasi'){ Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNav(),
                ));}
    else if (status == 'selesai') {
      Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNav(),
                ));
    }
    else if (status == 'Sudah') {
      updateGadiSelesai();
    } else if(status == 'Diaktifkan'){
      updateGadai();
    } else if (status == 'Dikonfirmasi') {
      Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNav(),
            ));
          showNotisetuju();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Penting'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'Data gadai anda sudah dikonfirmasi'),
                ],
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
            ),
          );
        } else if(status == 'Pengecekan'){
          Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNav(),
            ));
          showNotifcek();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Penting'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'Silahkan dicek data anda kembali'),
                ],
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
            ),
          );
        }
    else if(status == 'Pembatalan'){
       deleteDataBatal();
    } else if(status == 'Tolak'){
       deleteDataTolak();
    }
    else {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNav(),
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
          ));
    
  }
}
