import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gadaiyuk_terbaru/auth/signIn.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class OTP extends StatefulWidget {
  const OTP({Key? key}) : super(key: key);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  int randomNumber = 10000;
  TextEditingController otpController = TextEditingController();

  bool _isResendAgain = false;

  int _start = 60;

  late Timer _timer;
  late Timer _timerr;
  int _currentIndex = 0;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
     super.initState();
    _startTimer();
    initializeNotifications();
    random();
    showRandomNumberNotification();
  }

  void _startTimer() {
    _timerr = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        // Check if the widget is still mounted before updating the state
        setState(() {
          _currentIndex++;

          if (_currentIndex == 3) {
            _currentIndex = 0;
          }
        });
      }
    });
  }


  

  void initializeNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showRandomNumberNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'random_number_channel', 'Random Number Channel',
            importance: Importance.high, priority: Priority.high);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await Future.delayed(Duration(seconds: 5));

    await flutterLocalNotificationsPlugin.show(
      0,
      'Kode OTP anda',
      'Kode OTP Anda: $randomNumber mohon jangan berikan code OTP anda kepada orang lain',
      platformChannelSpecifics,
      payload: 'random_number',
    );
  }

  Future<void> onSelectNotification(String? payload) async {
    if (payload == 'random_number') {}
  }

  void resend() {
    setState(() {
      _isResendAgain = true;
      random();
    });

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start == 0) {
          _start = 60;
          _isResendAgain = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  void random() {
    setState(() {
      Random random = Random();
      randomNumber = random.nextInt(1000000);
    });
  }

  @override
  void dispose() {
    _timerr?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Verifikasi",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Times New Roman',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "silahkan cek sms handphone anda masukan kode OTP",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                  fontFamily: 'Times New Roman',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              OtpTextField(
                clearText: true,
                numberOfFields: 6,
                borderColor: const Color(0xff4545ff),
                showFieldAsBox: true,
                onCodeChanged: (String code) {
                  print(code);
                },
                onSubmit: (String verificationCode) {
                  if (randomNumber == int.parse(verificationCode)) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            "Sukses",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Times New Roman',
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: const <Widget>[
                                Text(
                                  'Silahkan login',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Times New Roman',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                'OK',
                                style: TextStyle(
                                  color: Color(0xff4545ff),
                                  fontFamily: 'Times New Roman',
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Login(),
                                    ));
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            "Verifikasi Gagal",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Times New Roman',
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: const <Widget>[
                                Text(
                                  'Kode OTP anda salah',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Times New Roman',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                'OK',
                                style: TextStyle(
                                  color: Color(0xff4545ff),
                                  fontFamily: 'Times New Roman',
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                  setState(() {});
                }, // end onSubmit
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Belum dapat OTP?",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_isResendAgain) return;
                      resend();
                      showRandomNumberNotification();
                    },
                    child: Text(
                      _isResendAgain
                          ? "Kirim Ulang Dalam " + _start.toString()
                          : "Kirim Ulang",
                      style: TextStyle(
                        color: const Color(0xff4545ff),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}