import 'dart:convert';

import 'package:abnormalitas5p/views/detailProduk.dart';
import 'package:flutter/material.dart';
import 'package:abnormalitas5p/modal/api.dart';
import 'package:abnormalitas5p/modal/produkModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:abnormalitas5p/views/tambahProdukUser.dart';

class MenuUsers extends StatefulWidget {
final VoidCallback signOut;

  MenuUsers(this.signOut);

  @override
  _MenuUsersState createState() => _MenuUsersState();
}

class _MenuUsersState extends State<MenuUsers> {

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

  String keterangan, idUsers, username, unit;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
      username = preferences.getString("username");
      unit = preferences.getString("unit");
    });
  }

  @override
  void initState() {
    super.initState();
    _lihatData();
    getPref();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TambahProdukUser(_lihatData)));
        },
        child: Icon(Icons.add_a_photo),
      ),
      appBar: AppBar(
        title: Text('Daftar Masalah'),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              setState(() {
               widget.signOut(); 
              });
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
              child: Container(
          child: OrientationBuilder(
            builder: (context,orientation){
              return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait? 1:2,
              ),
              itemCount: list.length,
              itemBuilder: (context, i){
                final x = list[i];
                return 
                x.unitkerja==unit? 
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context)=>DetailProduk(x),
                    ));
                  },
                                child: Card(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Hero(
                                  tag: x.id,
                                    child: Image.network(
                                    'http://192.168.43.64/ingatdandi/upload/'+x.gambar,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                "Tanggal input: "+x.tanggalinput,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Status: "+x.statusabnormalitas,
                                style: x.statusabnormalitas=="Open"? TextStyle(fontStyle: FontStyle.italic,background: Paint()..color = Colors.yellowAccent): 
                              (x.statusabnormalitas=="Inprogress"? TextStyle(fontStyle: FontStyle.italic,background: Paint()..color = Colors.lightGreen)
                              : TextStyle(fontStyle: FontStyle.italic,background: Paint()..color = Colors.redAccent)),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Prioritas: "+x.prioritas,
                                style: x.prioritas=="Low"? TextStyle(fontStyle: FontStyle.italic,background: Paint()..color = Colors.lightGreen): 
                              (x.prioritas=="Medium"? TextStyle(fontStyle: FontStyle.italic,background: Paint()..color = Colors.yellowAccent)
                              : TextStyle(fontStyle: FontStyle.italic,background: Paint()..color = Colors.redAccent)),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ),
                )
                :
                Text('',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 0.005),)
                // null
                ;
              },
            );
            }

          )
        ),
      ),
    );
  }
}