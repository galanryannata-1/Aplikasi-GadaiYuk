import 'dart:core';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../db/dbHelpers.dart';
import '../../page/bottomNav.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gadaiyuk_terbaru/page/landscape_mode.dart';



class Update extends StatefulWidget {
   final String id;
  final String Katagori;
   final String jenis;
   final String  idjns;
  
  const Update({Key? key, required this.id, required this.Katagori, required this.jenis, required this.idjns})
      : super(key: key);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
   String id = '';
  String Katagori = '';
  String jenis = '';
  String  idjns ='';
  String idg = '';
    String ibg = '';
  NumberFormat rupiahFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  NumberFormat titikFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);
  TextEditingController _namaLPController = TextEditingController();
  TextEditingController _jmlController = TextEditingController();
  TextEditingController _namaDepanController = TextEditingController();
  TextEditingController _namaBLKGController = TextEditingController();
  TextEditingController _ktpController = TextEditingController();
  TextEditingController _nomerHPController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _tanggalController = TextEditingController();
  TextEditingController _katagoriController = TextEditingController();
  TextEditingController _jenisController = TextEditingController();
     final NumberFormat _numberFormat = NumberFormat("#,###", "id_ID");
  int _selectedOption = 3;
  int biayaAdministrasi = 20000;
  int jumlahPinjaman = 0;
  int cicilanPerBulan = 0;
  String tanggalAwal = '';
  String formattedDate = '';
  String IDP = DatabaseHelper.getUserId();
  String pts = '';
  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    id = widget.id;
    jenis = widget.jenis;
    _katagoriController.text = widget.Katagori;
     _jenisController.text = widget.jenis; // Inisialisasi nilai id dari widget.id
    Katagori = widget.Katagori;
    idjns = widget.idjns;
    _pts();
   
  }

  Future<void> fetchUserProfile() async {
    final profileUrl = 'http://192.168.100.12/PA/dataGadaiUpdate.php';

    final response = await http.post(
      Uri.parse(profileUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'id': IDP},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          _namaLPController.text = data['merek'];
          _jmlController.text = titikFormat.format(int.parse(data['harga']));
          _namaDepanController.text = data['nama_depan'];
          _namaBLKGController.text = data['nama_blkg'];
          _ktpController.text = data['ktp'];
          _nomerHPController.text = data['nomer'];
          _alamatController.text = data['alamat'];
          _katagoriController.text = data['katagori'];
          _jenisController.text = data['jenis'];
          idg = data['id'];
        });
      } else {
        setState(() {
          _namaLPController.text = '';
          _jmlController.text = '';
          _namaDepanController.text = '';
          _namaBLKGController.text = '';
          _ktpController.text = '';
          _nomerHPController.text = '';
          _alamatController.text = '';
          _katagoriController.text = '';
          _jenisController.text = '';
        });
      }
    } else {
      setState(() {
        _namaLPController.text = '';
        _jmlController.text = '';
        _namaDepanController.text = '';
        _namaBLKGController.text = '';
        _ktpController.text = '';
        _nomerHPController.text = '';
        _alamatController.text = '';
        _katagoriController.text = '';
        _jenisController.text = '';
      });
    }
  }

  Future<void> _pts() async {
    try {
      final url = 'http://192.168.100.12/PA/dataPTS.php';
      final data = {
        'id': id.toString(),
      };

      final response = await http.post(Uri.parse(url), body: data);
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
         final data = jsonDecode(response.body);
         pts = data['ptss'];
         hitungJumlahPinjaman(pts);
        
      } else {
        // Registrasi gagal
        setState(() {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Penting!! ',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Times New Roman')),
              content: Text('Data gagal',
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
         AlertDialog(
            title: Text('Erorr',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w400,
                )),
            content: Text('$e ',
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
          );
      
    }
  }

void hitungJumlahPinjaman(String pts) {
    double persentaseUser = double.tryParse(pts) ?? 0.0;
    double persentase50 = persentaseUser / 100.0;
    double hps = double.tryParse(_jmlController.text.replaceAll('.', '')) ?? 0.0;

    // Validasi jika input tidak masuk akal
    if (hps <= 0 || persentase50 <= 0) {
      jumlahPinjaman = 0;
      cicilanPerBulan = 0;
      return;
    }

    // Hitung pinjaman pokok sesuai persentase
    int up1 = (hps * persentase50).toInt();
    jumlahPinjaman = up1 + biayaAdministrasi;
    cicilanPerBulan = (jumlahPinjaman / _selectedOption).ceil();
    setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime firstSelectableDate = currentDate;

    final DateTime lastDayOfMonth = DateTime(
      firstSelectableDate.year,
      firstSelectableDate.month + 1,
      0,
    );

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: firstSelectableDate,
      firstDate: firstSelectableDate,
      lastDate: lastDayOfMonth,
    );

    if (pickedDate != null) {
      setState(() {
        _tanggalController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
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
      _insertdatar();
    } else {
      // Tangani kesalahan jika ada
    }
  }

  Future<void> _insertdatar() async {
    try {
      final url = 'http://192.168.100.12/PA/updateGadai.php';
      final data = {
        'iddg': idg.toString(),
        'idjns': idjns.toString(),
        'merek': _namaLPController.text.toString(),
        'harga': int.parse(_jmlController.text.replaceAll('.', '')).toString(),
        'penawaran': jumlahPinjaman.toString(),
        'bulan': _selectedOption.toString(),
        'bayar': cicilanPerBulan.toString()
      };

      final response = await http.post(Uri.parse(url), body: data);
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
         final data = jsonDecode(response.body);
         Future.delayed(Duration(seconds: 1), () {
          insertData();
        });
      } else {
        // Registrasi gagal
        setState(() {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Penting!! ',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Times New Roman')),
              content: Text('Data gagal di inputkan',
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
            content: Text('$e datar',
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

  
  Future<void> insertData() async {
    try {
      final url = 'http://192.168.100.12/PA/insertbayar.php';
      //final DateFormat formatter = DateFormat('yyyy-MM-dd');
      DateTime tanggalMulai =
          DateFormat('yyyy-MM-dd').parse(_tanggalController.text);
      tanggalAwal = DateFormat('yyyy-MM-dd').format(tanggalMulai);

      /*for (int i = 0; i < _selectedOption; i++) {
    DateTime tanggalNabungPerBulan = tanggalMulai.add(Duration(days: i * 30));
      formattedDate = tanggalNabungPerBulan.toIso8601String();
    print('Bulan ke-$i: $tanggalNabungPerBulan');
    }*/

      for (int i = 0; i < _selectedOption; i++) {
        final data = {
          'iddg': idg.toString(),
          'tanggal': tanggalMulai.add(Duration(days: i * 31)).toString(),
        };

        final response = await http.post(
          Uri.parse(url),
          body: data,
        );

        if (response.statusCode == 200) {
          _inserttangal();
        } else {
          print('Failed to insert data ');
        }
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
            content: Text('$e bayar',
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

  Future<void> _inserttangal() async {
    try {
      final url = 'http://192.168.100.12/PA/insertTanggal.php';
      final data = {
        'inbg': IDP.toString(),
        'id': idg.toString(),
      };

      final response = await http.post(Uri.parse(url), body: data);
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNav(),
            ));
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
        
      
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text('Update Data ',style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xff4545ff),
          centerTitle: true,
           leading: new IconButton(
                icon: new Icon(Icons.arrow_back_ios_new,color: Colors.white),
                onPressed: () {
               
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNav(),
                      ));
                }),
          ),
          body: Container(
              margin: EdgeInsets.only(top: 0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 30),
                  child: Form(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Katagori ',
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
                          controller: _katagoriController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            hintText: 'masukkan nama ',
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Jenis',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          cursorColor: const Color(0xff4545ff),
                          controller: _jenisController,
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            hintText: 'masukkan nama ',
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Merek',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          cursorColor: const Color(0xff4545ff),
                          controller: _namaLPController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            hintText: 'masukkan merek',
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
                        Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Harga',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        cursorColor: const Color(0xff4545ff),
                        controller: _jmlController,
                        keyboardType: TextInputType.phone,
                        
                         inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            _NumberInputFormatter(),
                          ],
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          hintText: 'masukkan harga',
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                              fontFamily: 'Times New Roman'),
                          prefix: Text(
                            "Rp",style: TextStyle(
                               color: Colors.black,
                              fontSize: 14.0,
                              fontFamily: 'Times New Roman'
                            ),
                             textAlign: TextAlign.center,
                          ),
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
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextField(
                              cursorColor: const Color(0xff4545ff),
                              controller: _tanggalController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(15),
                                hintText: 'Tanggal mulai menabung',
                                suffixIcon: Icon(Icons.calendar_today),
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
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Pilih angsuran',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        DropdownButtonFormField<int>(
                          value: _selectedOption,
                          onChanged: (int? newValue) {
                            // Update the selected option
                            setState(() {
                              _selectedOption = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            labelStyle: const TextStyle(
                              color: Color(0xff4545ff),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xff4545ff),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          items: <DropdownMenuItem<int>>[
                            DropdownMenuItem<int>(
                              value: 3,
                              child: Text('3 bulan'),
                            ),
                            DropdownMenuItem<int>(
                              value: 6,
                              child: Text('6 bulan'),
                            ),
                            DropdownMenuItem<int>(
                              value: 9,
                              child: Text('9 bulan'),
                            ),
                            DropdownMenuItem<int>(
                              value: 12,
                              child: Text('12 bulan'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        MaterialButton(
                          onPressed: () {
                            if (_tanggalController.text
                            .isEmpty ) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Error",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Times New Roman'),
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text(
                                            'Isi semua data jangan ada yang kosong!!!!',
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
                                            style: TextStyle(
                                                color: Color(0xff4545ff)),
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
                            } else if (_ktpController.text.length <= 15 ||
                                _ktpController.text.length >= 17) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Error",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Times New Roman'),
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text(
                                            'Nomer KTP tidak boleh kurang dan lebih dari 16 digit!!!!',
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
                                            style: TextStyle(
                                                color: Color(0xff4545ff)),
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
                            } else if (int.parse(_jmlController.text.replaceAll('.','')) < 100000) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Error",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Times New Roman'),
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text(
                                            'Harga tidak boleh kurang dari Rp100.000',
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
                                            style: TextStyle(
                                                color: Color(0xff4545ff)),
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
                            else {
                              hitungJumlahPinjaman(pts);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Konfirmasi",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: Form(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Katagori: ${_katagoriController.text}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily:
                                                      'Times New Roman'),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Jenis: ${_jenisController.text}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily:
                                                      'Times New Roman'),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Nama merek: ${_namaLPController.text}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily:
                                                      'Times New Roman'),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Harga: ${rupiahFormat.format(int.parse(_jmlController.text.replaceAll('.', '')))}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily:
                                                      'Times New Roman'),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Penawaran yang kami berikan: ${rupiahFormat.format(jumlahPinjaman)} \n sudah termasuk biaya admin ${rupiahFormat.format(biayaAdministrasi)}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily:
                                                      'Times New Roman'),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Tanggal mulai angsuran: ${_tanggalController.text}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily:
                                                      'Times New Roman'),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Angsuran $_selectedOption bulan dengan biaya yang harus dibayar perbulan: ${rupiahFormat.format(cicilanPerBulan)}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily:
                                                      'Times New Roman'),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Dengan anda klik tombol SIMPAN berarti ada telah menyetujui penawaran kami',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      'Times New Roman'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text(
                                          'Tidak',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'Times New Roman'),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: const Text(
                                          'Simpan',
                                          style: TextStyle(
                                              color: Color(0xff4545ff),
                                              fontFamily: 'Times New Roman'),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          deleteData();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          height: 45,
                          color: const Color(0xff4545ff),
                          child: const Text(
                            "Hitung",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))),
    );
  }
}

class _NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String value = newValue.text.replaceAll(',', '');
    double doubleValue = double.tryParse(value) ?? 0.0;
    String formattedValue = NumberFormat("#,###","id_ID").format(doubleValue);

    return newValue.copyWith(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}

