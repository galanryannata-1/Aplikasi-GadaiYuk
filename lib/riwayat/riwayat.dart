import 'dart:async';
import 'dart:convert';
import '../db/dbHelpers.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gadaiyuk_terbaru/page/bottomNav.dart';

class RiwayatGadai extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RiwayatGadaiState();
}

class _RiwayatGadaiState extends State<RiwayatGadai> {
   String userId = DatabaseHelper.getUserId();
  NumberFormat rupiahFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    //fetchRiwayat();
  }

  Future<List<RWY>> fetchRiwayat() async {
    final profileUrl = 'http://192.168.100.12/PA/dataRiwayat.php';

    final response = await http.post(
      Uri.parse(profileUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'id': userId},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((item) => RWY(
              item['status_dg'],
              item['nama_ktg'],
              item['nama_merek_dg'],
              item['harga_dg'],
              item['penawaran_dg'],
              item['tanggal_mulai_dg'],
              item['tanggal_akhir_dg'],
              item['bulan_dg'],
              item['uangper_dg'],
              item['nama_jns']))
          .toList();
    } else {
      return Future.error('Tidak ada', StackTrace.fromString('Tidak ada'));
    }
  }

  void showRiwayatDetail(RWY rwy) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
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
                          'Detail Riwayat',
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
              SizedBox(height: 10),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                children: [
                  _buildDetailRow('Status', rwy.status),
                  _buildDetailRow('Tanggal', rwy.tanggal),
                  _buildDetailRow('Katagori', rwy.katagori),
                  _buildDetailRow('Jenis', rwy.jenis),
                  _buildDetailRow('Nama merek', rwy.nama),
                  _buildDetailRow(
                      'Harga', rupiahFormat.format(int.parse(rwy.harga))),
                  _buildDetailRow(
                      'Penawaran', rupiahFormat.format(int.parse(rwy.pnwr))),
                  _buildDetailRow('Tanggal Mulai', rwy.tanggal),
                  _buildDetailRow('Tanggal Akhir', rwy.tanggalAkhir),
                  _buildDetailRow('Bulan', '${rwy.bulan} Bulan'),
                  _buildDetailRow(
                      'Angsuran', rupiahFormat.format(int.parse(rwy.cicil))),
                  /* SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      deleteRiwayatData(rwy.tanggal); 
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xff4545ff),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      minimumSize: Size(0, 45),
                    ),
                    child: Text(
                      'Hapus',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: 'Times New Roman',
                      ),
                    ),
                  ),*/
                ],
              )))
            ],
          ),
        );
      },
    );
  }

  void deleteRiwayatData(RWY rwy) async {
  try {
    final url = 'http://192.168.100.12/PA/deleteRiwayat.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'tanggal':rwy.tanggal,
        'id': userId.toString(),
      },
    );

    if (response.statusCode == 200) {
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Penting!!',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: 'Times New Roman',
            ),
          ),
          content: Text(
            'Gagal menghapus',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w300,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  color: Color(0xff4545ff),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  } catch (e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Register Gagal',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: 'Times New Roman',
          ),
        ),
        content: Text(
          '$e',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w300,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'OK',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                color: Color(0xff4545ff),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Riwayat', style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xff4545ff),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.only(top: 16),
          child: FutureBuilder<List<RWY>>(
            future: fetchRiwayat(),
            builder: (BuildContext context, AsyncSnapshot<List<RWY>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    final rwy = snapshot.data![index];
                    return Padding(
                      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            showRiwayatDetail(rwy);
                          },
                          title: _buildDetailRow('Tanggal', rwy.tanggal),
                          subtitle: Column(
                            children: [
                              _buildDetailRow(
                                  '${rwy.katagori}', rwy.jenis),
                              _buildDetailRow('Status', rwy.status),
                            ],
                          ),
                          
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Align(
                  alignment: Alignment.center,
                  child: Lottie.network(
                    "https://assets10.lottiefiles.com/private_files/lf30_cgfdhxgx.json",
                    animate: true,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}

class RWY {
  final String status;
  final String katagori;
  final String nama;
  final String harga;
  final String pnwr;
  final String tanggal;
  final String tanggalAkhir;
  final String bulan;
  final String cicil;
  final String jenis;

  RWY(this.status, this.katagori, this.nama, this.harga, this.pnwr,
      this.tanggal, this.tanggalAkhir, this.bulan, this.cicil, this.jenis);
}
