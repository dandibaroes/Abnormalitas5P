import 'dart:convert';

import 'package:abnormalitas5p/views/detailProduk.dart';
import 'package:flutter/material.dart';
import 'package:abnormalitas5p/modal/api.dart';
import 'package:abnormalitas5p/modal/produkModel.dart';
import 'package:abnormalitas5p/views/editProduk.dart';
// import 'package:abnormalitas5p/views/tambahProduk.dart';
import 'package:http/http.dart' as http;

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  var loading = false;
  final list = new List<Abnormalitas>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.lihatAbnormalitas);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new Abnormalitas(
          api['id'],
          api['userpelapor'],
          api['unitkerja'],
          api['keterangan'],
          api['statusabnormalitas'],
          api['prioritas'],
          api['gambar'],
          api['gambarsesudah'],
          api['lokasi'],
          api['koordinat'],
          api['ketinggian'],
          api['pic'],
          api['tanggalinput'],
          api['tanggalselesai'],
          api['idUsers'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  dialogDelete(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Apa anda yakin untuk menghapus data abnormalitas ini?",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          _delete(id);
                        },
                        child: Text("Yes")),
                        SizedBox(
                      width: 16.0,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                  ],
                )
              ],
            ),
          );
        });
  }

  _delete(String id) async {
    final response =
        await http.post(BaseUrl.deleteAbnormalitas, body: {"id": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        _lihatData();
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    super.initState();
    _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.of(context).push(MaterialPageRoute(
      //         builder: (context) => TambahProduk(_lihatData)));
      //   },
      //   child: Icon(Icons.add_a_photo),
      // ),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return
                  InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context)=>DetailProduk(x),
                    ));
                  },
                    child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.network('http://192.168.1.101/ingatdandi/upload/'+x.gambar,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Status: " +x.statusabnormalitas,
                              style: x.statusabnormalitas=="Open"? TextStyle(fontStyle: FontStyle.italic,background: Paint()..color = Colors.yellowAccent): 
                          (x.statusabnormalitas=="Inprogress"? TextStyle(fontStyle: FontStyle.italic,background: Paint()..color = Colors.lightGreen)
                          : TextStyle(fontStyle: FontStyle.italic,background: Paint()..color = Colors.redAccent)),),
                              Text("Prioritas: "+x.prioritas,
                               style: x.prioritas=="Low"? TextStyle(fontStyle: FontStyle.italic,background: Paint()..color = Colors.lightGreen): 
                          (x.prioritas=="Medium"? TextStyle(fontStyle: FontStyle.italic,background: Paint()..color = Colors.yellowAccent)
                          : TextStyle(fontStyle: FontStyle.italic,background: Paint()..color = Colors.redAccent)),),
                              Text("PIC: "+x.pic,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                              Text("Tanggal Input: "+x.tanggalinput,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    EditProduk(x, _lihatData)));
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            dialogDelete(x.id);
                          },
                          icon: Icon(Icons.delete),
                        )
                      ],
                    ),
                  ));
                },
              ),
      ),
    );
  }
}
