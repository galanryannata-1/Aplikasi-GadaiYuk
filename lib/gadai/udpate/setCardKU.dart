import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gadaiyuk_terbaru/gadai/setCardJ.dart';
import 'package:gadaiyuk_terbaru/page/bottomNav.dart';
import 'package:gadaiyuk_terbaru/gadai/udpate/setCardJU.dart';




class SetCardKU extends StatefulWidget {
  @override
  _SetCardKUState createState() => _SetCardKUState();
}

class _SetCardKUState extends State<SetCardKU> {
  NumberFormat rupiahFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    //fetchRiwayat();
  }

  Future<List<KTG>> fetchRiwayat() async {
    final profileUrl = 'http://192.168.100.12/PA/dataKatagori.php';

    final response = await http.post(
      Uri.parse(profileUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((item) => KTG(
              item['id_ktg'],
              item['nama_ktg']))
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
          title: Text('Katagori',style: TextStyle(color: Colors.white),),
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
          child: FutureBuilder<List<KTG>>(
            future: fetchRiwayat(),
            builder: (BuildContext context, AsyncSnapshot<List<KTG>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ktg = snapshot.data![index];
                    return Padding(
                      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SetCardJU(id: ktg.id, Katagori: ktg.katagori),
                                ));
                          },
                          title: Text('${ktg.katagori}'),
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

class KTG {
  final String id;
  final String katagori;

  KTG(this.id, this.katagori);
}
