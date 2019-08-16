import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:abnormalitas5p/modal/api.dart';
import 'package:abnormalitas5p/modal/produkModel.dart';
import 'package:http/http.dart' as http;

class EditProduk extends StatefulWidget {
  final Abnormalitas model;
  final VoidCallback reload;
  EditProduk(this.model, this.reload);
  @override
  _EditProdukState createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  final _key = new GlobalKey<FormState>();
  String pic;

  TextEditingController picnya;

  setup() {
    picnya = TextEditingController(text: widget.model.pic);
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    } else {}
  }

  submit() async {
    final response = await http.post(BaseUrl.editAbnormalitas, body: {
      "pic": pic,
      "idProduk": widget.model.id,
      "status":_radioValue,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];

    if (value == 1) {
      setState(() {
        widget.reload();
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }

   String _radioValue='Open';
  String choice;

  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'Open':
          choice = value;
          break;
        case 'Inprogress':
          choice = value;
          break;
        case 'Close':
          choice = value;
          break;
        default:
          choice = 'Open';
      }
      debugPrint(choice);
    });
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: picnya,
              onSaved: (e) => pic = e,
              decoration: InputDecoration(labelText: 'pic'),
            ),
              Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:0.0),
                      child: Text("Status :",style: TextStyle(fontSize: 15.0),),
                    ),
                    Radio(
                      value: 'Open',
                      groupValue: _radioValue,
                      onChanged: radioButtonChanges,
                    ),Text("Open",style: TextStyle(fontSize: 10.0),),
                    Radio(
                      value: 'Inprogress',
                      groupValue: _radioValue,
                      onChanged: radioButtonChanges,
                    ),
                    Flexible(child: 
                    Text("Inprogress",style: TextStyle(fontSize: 10.0),),),
                    Radio(
                      value: 'Close',
                      groupValue: _radioValue,
                      onChanged: radioButtonChanges,
                    ),
                    Flexible(child: 
                    Text("Close",style: TextStyle(fontSize: 10.0),),)
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
