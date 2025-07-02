import 'dart:io';
import 'dart:core';
import 'dart:convert';
import '../db/dbHelpers.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gadaiyuk_terbaru/page/bottomNav.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gadaiyuk_terbaru/page/landscape_mode.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class uploadBayar extends StatefulWidget {
  const uploadBayar({Key? key}) : super(key: key);

  @override
  uploadBayarState createState() => uploadBayarState();
}

class uploadBayarState extends State<uploadBayar> {
  NumberFormat rupiahFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  NumberFormat titikFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);
  TextEditingController _tanggalController = TextEditingController();
   String IDP = DatabaseHelper.getUserId();
   String userIdGadai = DatabaseHelper.getIddg();
  bool isLoading = false;

  File? _image;
  String tanggal = '';
  String statusdg = '';
  String status = '';
  @override
  void initState() {
    super.initState();
    fetchStatusGadai();
  }

  void fetchStatusGadai() async {
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
    if (status == 'Sedang menggadaikan') {
      checkDate();
    } else {
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
              Text('Anda tidak sedang menggadaikan'),
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
  }

  void checkDate() async {
    try {
      final url = 'http://192.168.100.12/PA/aktifkan.php?id=$IDP';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        tanggal = data['tanggal'];
        statusdg = data['status'];
        _tanggalController.text = data['tanggal'];

        final currentDate = DateTime.now();
        final targetDate = DateTime.parse(tanggal);
        final difference = targetDate.difference(currentDate).inDays;

        if (difference==0) {
           if (statusdg == 'Menunggu Konfirmasi') {
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
                        'Status upload sedang Menunggu Konfirmasi Anda tidak bisa upload ulang'),
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
          else if (statusdg == 'Ditolak') { }
          else if (statusdg == 'Belum Bayar') { }
          else if (statusdg == 'Diterima') {
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
                        'Bukti transfer anda sudah diterima'),
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
        } 
        else{
         checkDateAktif();
        }
      } else {
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
                Text('Data error'),
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
    } catch (e) {
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
              Text('Anda belum gadai'),
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
  }

   void checkDateAktif() async {
    try {
      final url = 'http://192.168.100.12/PA/aktifkanSudahBayar.php?id=$IDP';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        tanggal = data['tanggal'];
        statusdg = data['status'];
        _tanggalController.text = data['tanggal'];

        final currentDate = DateTime.now();
        final targetDate = DateTime.parse(tanggal);
        final difference = targetDate.difference(currentDate).inDays;

        if (difference==0) {
           if (statusdg == 'Sudah Bayar') {
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
        } 
        else{
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
                  Text('Belum waktunya bayar angsuran'),
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
      } else {
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
                Text('Data error'),
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
    } catch (e) {
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
              Text('Belum waktunya bayar angsuran'),
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
  }


  Future<void> _pickImage(ImageSource source) async {
  final pickedFile = await ImagePicker().pickImage(source: source); 
  if (pickedFile != null) {
    setState(() {
      _image = File(pickedFile.path);
    });
  }
}
  Future<List<int>?> _compressImage(File? image) async {
    if (image == null) return null;

    final imageBytes = await image.readAsBytes();
    final compressedImageBytes = await FlutterImageCompress.compressWithList(
      imageBytes,
      quality: 50, // Sesuaikan kualitas kompresi sesuai kebutuhan
      minHeight:
          1000, // Sesuaikan ukuran minimal tinggi gambar sesuai kebutuhan
      minWidth: 1000, // Sesuaikan ukuran minimal lebar gambar sesuai kebutuhan
    );

    return compressedImageBytes;
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    final compressedImageBytes = await _compressImage(_image);

    if (compressedImageBytes == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Upload Gagal'),
          content: Text('Gagal mengompres gambar.'),
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
      return;
    }
    final url =
        'http://192.168.100.12/PA/uploadfoto.php'; // Ganti dengan URL endpoint server Anda
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id': IDP.toString(),
        'tanggal': tanggal.toString(),
        'image': base64Encode(compressedImageBytes)
      },
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNav(),
          ));
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Upload Berhasil'),
          content: Text('Foto berhasil diunggah ke database.'),
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
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Upload Gagal'),
          content: Text('Gagal mengunggah foto ke database.'),
          actions: [
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Upload bukti transfer',style: TextStyle(color: Colors.white),),
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
        body: SingleChildScrollView(
            child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/Bank bca.png', // Ganti dengan URL foto bank Galan
                                    height: 40,
                                    width: 40,
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '0394839102938',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Gadai Yuk',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ],
                              ))),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/Bank mandari.png', // Ganti dengan URL foto bank Galan
                                    height: 40,
                                    width: 40,
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '0394839102938',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Gadai Yuk',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ],
                              ))),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 150),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 30, 16, 30),
                child: Form(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Tanggal',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        cursorColor: const Color(0xff4545ff),
                        readOnly: true,
                        controller: _tanggalController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          hintText: '',
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
                            borderSide: BorderSide(
                                color: Colors.grey.shade200, width: 2),
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
                        height: 10,
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 200,
                              width: 200,
                              child: _image != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                        _image!,
                                        fit: BoxFit.fill,
                                      ),
                                  )
                                  : Align(
                                    alignment: Alignment.center,
                                    child:  Text(
                                      'Silahkan upload foto'),
                                  ),
                            ),
                            MaterialButton(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              height: 20,
                              color: const Color(0xff4545ff),
                              child: const Text(
                                "Pilih dari galeri",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () => _pickImage(ImageSource.camera),
                              height: 20,
                              color: const Color(0xff4545ff),
                              child: const Text(
                                "Ambil foto",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await _uploadImage();

                          setState(() {
                            isLoading = false;
                          });
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
                                'Upload',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontFamily: 'Times New Roman',
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
