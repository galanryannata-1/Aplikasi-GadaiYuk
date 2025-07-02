import 'dart:async';
import 'dart:convert';
import '../db/dbHelpers.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gadaiyuk_terbaru/page/bottomNav.dart';

class Tanngal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TanngalState();
}

class _TanngalState extends State<Tanngal> {
   String userId = DatabaseHelper.getUserId();
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    //fetchTanggal();
  }

  Future<List<BG>> fetchTanggal() async {
    final profileUrl = 'http://192.168.100.12/PA/dataTanggal.php';

    final response = await http.post(
      Uri.parse(profileUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'id': userId},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((item) => BG(item['tanggal_bg'], item['status_bg'],
              item['foto_bukti_bg'] ?? "nul"))
          .toList();
    } else {
      return Future.error('Tidak ada', StackTrace.fromString('Tidak ada'));
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

  void _showAlertDialog(BG bg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Foto upload'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child :
              Image.network(
                  'http://192.168.100.12/PA/foto/${bg.foto}',
                  width: 300,
                  height:300,
                  fit: BoxFit.fill,),
               ) // Ganti 'assets/image.png' dengan path gambar Anda
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tanggal',style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xff4545ff),
          centerTitle: true,
           leading: new IconButton(
                icon: new Icon(Icons.arrow_back_ios_new,color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNav(),
                    ));
              }),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 16),
          child: FutureBuilder<List<BG>>(
            future: fetchTanggal(),
            builder: (BuildContext context, AsyncSnapshot<List<BG>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    final bg = snapshot.data![index];
                    bool cek = bg.statusbg == "Belum Bayar" ||
                        bg.statusbg == "Ditolak";
                    return Padding(
                      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                      child: Card(
                        child: ListTile(
                          title: _buildDetailRow('Tanggal', bg.tanggalbg),
                          subtitle: _buildDetailRow('Status', bg.statusbg),
                          trailing: MaterialButton(
                            onPressed: cek
                                ? null
                                : () {
                                    _showAlertDialog(bg);
                                  },
                            height: 30,
                            color: const Color(0xff4545ff),
                            child: Text(
                              'Lihat foto',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Times New Roman'),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
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

class BG {
  final String tanggalbg;
  final String statusbg;
  final String foto;

  BG(this.tanggalbg, this.statusbg, this.foto);
}
