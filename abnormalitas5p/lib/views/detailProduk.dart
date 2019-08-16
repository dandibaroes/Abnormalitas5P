import 'dart:io';

import 'package:abnormalitas5p/modal/api.dart';
import 'package:abnormalitas5p/modal/produkModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

class DetailProduk extends StatefulWidget {
  final Abnormalitas model;

  DetailProduk(this.model);
  @override
  _DetailProdukState createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {

   String keterangan, idUsers, username, unit;
  File _imageFile;
  
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
      username = preferences.getString("username");
      unit = preferences.getString("unit");
    });
  }

  // _pilihGallery() async {
  //   var image = await ImagePicker.pickImage(
  //       source: ImageSource.gallery,);
  //   setState(() {
  //     _imageFile = image;
  //   });
  // }

  _pilihKamera() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      _imageFile = image;
    });
  }

  submit() async {
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse(BaseUrl.uploadsebelum);
      var request = http.MultipartRequest("POST", uri);
      request.fields['id'] = widget.model.id;

      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("image upload");
        setState(() {
          Navigator.pop(context);
        });
      } else {
        print("image failed");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }
  
@override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
     var placeholder = Container(
      width: double.infinity,
      height: 150.0,
      child: Image.asset('assets/foto.png'),
    );
    return Scaffold(
      appBar: AppBar(title: Text("Detail Page")),
      body: Container(
        child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom:8.0),
                        child: Text("GAMBAR SEBELUM DITANGANI",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          shadows: [
                                  Shadow(
                                      color: Colors.yellow,
                                      blurRadius: 5.0,
                                      offset: Offset(5.0, 5.0),
                                  ),
                                  Shadow(
                                      color: Colors.black,
                                      blurRadius: 10.0,
                                      offset: Offset(-5.0, 5.0),
                                      ),
                                  ],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                        ),
                        ),
                      ),
                      Image.network('http://192.168.1.101/ingatdandi/upload/'+widget.model.gambar),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text("GAMBAR SETELAH DITANGANI",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          shadows: [
                                  Shadow(
                                      color: Colors.green,
                                      blurRadius: 5.0,
                                      offset: Offset(5.0, 5.0),
                                  ),
                                  Shadow(
                                      color: Colors.black,
                                      blurRadius: 10.0,
                                      offset: Offset(-5.0, 5.0),
                                      ),
                                  ],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                          ),
                        ),
                      ),
                      
                      Image.network('http://192.168.1.101/ingatdandi/upload/'+widget.model.gambarsesudah),
                      Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text("KETERANGAN",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                          shadows: [
                                  Shadow(
                                      color: Colors.blue,
                                      blurRadius: 5.0,
                                      offset: Offset(5.0, 5.0),
                                  ),
                                  Shadow(
                                      color: Colors.black,
                                      blurRadius: 10.0,
                                      offset: Offset(-5.0, 5.0),
                                      ),
                                  ],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                          ),
                          ),
                        ),
                        Text("User pelapor: "+widget.model.userpelapor,textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,)),
                        Text("Unit kerja: "+widget.model.unitkerja,textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,)),
                        Text("keterangan: "+widget.model.keterangan,textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,)),
                        Text("Status: "+widget.model.statusabnormalitas,textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,)),
                        Text("Prioritas: "+widget.model.prioritas,textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,)),
                        Text("Lokasi: "+widget.model.lokasi,textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,)),
                        Text("Koordinat: "+widget.model.koordinat,textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,)),
                        Text("Ketinggian: "+widget.model.ketinggian+" mdpl",textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,)),
                        Text("PIC: "+widget.model.pic,textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,)),
                        Text("Tanggal input: "+widget.model.tanggalinput,textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,)),
                        Text("Tanggal selesai: "+widget.model.tanggalselesai,textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,)),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text("UPLOAD FOTO TERBARU",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                          shadows: [
                                  Shadow(
                                      color: Colors.blue,
                                      blurRadius: 5.0,
                                      offset: Offset(5.0, 5.0),
                                  ),
                                  Shadow(
                                      color: Colors.black,
                                      blurRadius: 10.0,
                                      offset: Offset(-5.0, 5.0),
                                      ),
                                  ],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                          ),
                          ),
                        ),
                        Container(
              child: InkWell(
                onTap: () {
                  _pilihKamera();
                },
                child: _imageFile == null
                    ? placeholder
                    : Image.file(
                        _imageFile,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: MaterialButton(
                minWidth: 100.0,
                height: 35,
                color: Color(0xFFF44336),
                onPressed: () {
                  submit();
                },
                child: Text("Simpan",style:
                TextStyle(
                color: Colors.white,
                ),),
              ),
            )
          ],),
                  ),
        )
      ),
    );
  }
}