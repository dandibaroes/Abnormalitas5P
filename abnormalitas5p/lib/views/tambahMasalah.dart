import 'dart:convert';
import 'dart:io';
import 'package:abnormalitas5p/custom/datePicker.dart';
import 'package:abnormalitas5p/modal/lokasiModel.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:abnormalitas5p/modal/api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:geolocator/geolocator.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'dart:math' as Math;

class TambahProduk extends StatefulWidget {
  final VoidCallback reload;
  TambahProduk(this.reload);
  @override
  _TambahProdukState createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {

  Geolocator geolocator = Geolocator();

  Position userLocation;

  AutoCompleteTextField searchTextField;
AutoCompleteTextField searchTextField1;
  GlobalKey<AutoCompleteTextFieldState<Lokasi>> key = new GlobalKey();
  static List<Lokasi> users = new List<Lokasi>();
  bool loading = true;

  void getUsers() async {
    try {
      final response =
          await http.get(BaseUrl.cariLokasi);
      if (response.statusCode == 200) {
        users = loadUsers(response.body);
        print('Lokasi: ${users.length}');
        setState(() {
          loading = false;
        });
      } else {
        print("cek");
      }
    } catch (e) {
      print("test");
    }
  }

  static List<Lokasi> loadUsers(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Lokasi>((json) => Lokasi.fromJson(json)).toList();
  }


TextEditingController namaTempat = new TextEditingController();

@override  void dispose() {
    namaTempat.dispose();
    super.dispose();
  }

  String _radioValue='Medium';
  String choice;

  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'Low':
          choice = value;
          break;
        case 'Medium':
          choice = value;
          break;
        case 'High':
          choice = value;
          break;
        default:
          choice = 'Medium';
      }
      debugPrint(choice);
    });
  }

  String keterangan, idUsers, username, unit;
  final _key = new GlobalKey<FormState>();
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
    var imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );

  final tempDir = await getTemporaryDirectory();
  final path = tempDir.path;

  int rand= new Math.Random().nextInt(100000);

  Img.Image image= Img.decodeImage(imageFile.readAsBytesSync());
  Img.Image smallerImg = Img.copyResize(image, width: 1000);

  var compressImg= new File("$path/image_$rand.jpg")
  ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

    setState(() {
      _imageFile = compressImg;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit(_imageFile);
    }
  }

  submit(File imageFile) async {
    try {
      var stream = new
          http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var uri = Uri.parse(BaseUrl.tambahAbnormalitas);
      var request = http.MultipartRequest("POST", uri);
      request.fields['keterangan'] = keterangan;
      request.fields['username'] = username;
      request.fields['idUsers'] = idUsers;
      request.fields['prioritas']=_radioValue;
      request.fields['unit'] = "null";
      request.fields['lokasi'] = namaTempat.text;
      request.fields['koordinat'] = userLocation.latitude.toString() + " | " + userLocation.longitude.toString();
      request.fields['ketinggian'] = userLocation.altitude.toString();
      request.fields['selesai'] = "$tgl";

      request.files.add(new http.MultipartFile("image", stream, length,
          filename: path.basename(imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("image upload");
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      } else {
        print("image failed");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  String pilihTanggal, labelText;
  DateTime tgl = DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);
  Future<Null> _selectedDate(BuildContext context)async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: tgl,
      firstDate: DateTime(2019),
      lastDate: DateTime(2099)
    );

    if (picked != null && picked != tgl) {
      setState(() {
        tgl = picked;
        pilihTanggal = new DateFormat.yMd().format(tgl);
      });
    } else {
    }
  }

  @override
  void initState() {
    getUsers();
    super.initState();
    _getLocation().then((position) {
      userLocation = position;
    });
    getPref();
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  Widget row(Lokasi user) {
    return 
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
        child: Text(
          user.tempat,
          style: TextStyle(fontSize: 16.0),
        ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 150.0,
      child: Image.asset('assets/foto.png'),
    );
    return Scaffold(
      appBar: AppBar(title: Text("Upload Abnormalitas"),),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
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
            TextFormField(
              maxLength: 150,
              onSaved: (e) => keterangan = e,
              decoration: InputDecoration(labelText: 'Keterangan',
              prefixIcon: (Icon(Icons.info)),
              ),
            ),
             Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: loading
              ? CircularProgressIndicator()
              : searchTextField = new AutoCompleteTextField<Lokasi>(
                suggestionsAmount: 10,
                controller: namaTempat,
                    key: key,
                    clearOnSubmit: false,
                    suggestions: users,
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                    decoration: InputDecoration(
                      hintText: "Cari Lokasi",
                      helperText: "Jika lokasi tidak tersedia, silakan ketik secara manual",
                      prefixIcon: (Icon(Icons.my_location)),
                      suffixIcon: IconButton(icon: Icon(Icons.clear),
                      onPressed: (){
                    namaTempat.clear();
                  },)
                    ),
                    itemFilter: (item, query) {
                      return item.tempat
                          .toLowerCase()
                          .contains(query.toLowerCase());
                    },
                    itemSorter: (a, b) {
                      return a.tempat.compareTo(b.tempat);
                    },
                    itemSubmitted: (item) {
                      setState(() {
                        searchTextField.textField.controller.text = item.tempat;
                      });
                    },
                    itemBuilder: (context, item) {
                      return row(item);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("Tanggal dibutuhkan selesai",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.0),),
                ),
                DateDropDown(
                  labelText: labelText,
                  valueText: new DateFormat.yMd().format(tgl),
                  valueStyle: valueStyle,
                  onPressed: (){
                    _selectedDate(context);
                  },
                ),
             Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:0.0),
                      child: Text("Prioritas :",style: TextStyle(fontSize: 15.0),),
                    ),
                    Radio(
                      value: 'Low',
                      groupValue: _radioValue,
                      onChanged: radioButtonChanges,
                    ),Text("Low",style: TextStyle(fontSize: 10.0),),
                    Radio(
                      value: 'Medium',
                      groupValue: _radioValue,
                      onChanged: radioButtonChanges,
                    ),
                    Flexible(child: 
                    Text("Medium",style: TextStyle(fontSize: 10.0),),),
                    Radio(
                      value: 'High',
                      groupValue: _radioValue,
                      onChanged: radioButtonChanges,
                    ),
                    Flexible(child: 
                    Text("High",style: TextStyle(fontSize: 10.0),),)
                  ],
                ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}
