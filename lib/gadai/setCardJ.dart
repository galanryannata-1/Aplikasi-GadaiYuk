import 'dart:async';
import 'dart:convert';
import '../db/dbHelpers.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gadaiyuk_terbaru/gadai/gadai.dart';
import 'package:gadaiyuk_terbaru/gadai/setCardK.dart';
import 'package:gadaiyuk_terbaru/page/bottomNav.dart';




class SetCardJ extends StatefulWidget {
  final String id;
  final String Katagori;
  const SetCardJ({Key? key, required this.id, required this.Katagori}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SetCardJState();
}

class _SetCardJState extends State<SetCardJ> {
   String id = '';
   String Katagori = '';
  
  static String userId = DatabaseHelper.getUserId();
  NumberFormat rupiahFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  
    //fetchRiwayat();
    id = widget.id; // Inisialisasi nilai id dari widget.id
    Katagori = widget.Katagori;
  }


  Future<List<JNS>> fetchRiwayat() async {
    final profileUrl = 'http://192.168.100.12/PA/dataJenis.php';

    final response = await http.post(
      Uri.parse(profileUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'id': id},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((item) => JNS(
              item['nama_jns'],
              item['id_jns']))
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Jenis Katagori',style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xff4545ff),
          centerTitle: true,
           leading: new IconButton(
                icon: new Icon(Icons.arrow_back_ios_new,color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SetCardK(),
                      ));
                }),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 16),
          child: FutureBuilder<List<JNS>>(
            future: fetchRiwayat(),
            builder: (BuildContext context, AsyncSnapshot<List<JNS>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    final jns = snapshot.data![index];
                    return Padding(
                      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => data(id: id, Katagori: Katagori, jenis: jns.nama, idjns:jns.idJNS),
                                ));
                          },
                          title: Text('${jns.nama}'),
                          trailing:Icon(Icons.keyboard_arrow_right)
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

class JNS {
  final String idJNS;
  final String nama;


  JNS(this.nama, this.idJNS);
}
