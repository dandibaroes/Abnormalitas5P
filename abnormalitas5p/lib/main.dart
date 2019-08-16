import 'dart:convert';

import 'package:abnormalitas5p/views/menuUser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'modal/api.dart';
import 'views/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flushbar/flushbar.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    title: 'Abnormalitas5P',
    theme: ThemeData(
      primarySwatch: Colors.red,
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 4,
      navigateAfterSeconds: new Login(),
      title: new Text('ABNORMALITAS5P',
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      image: new Image.asset('assets/semen.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.redAccent,
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn, signInUsers }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String username, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http.post(BaseUrl.login,
        body: {"username": username, "password": password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String usernameAPI = data['username'];
    String id = data['id'];
    String unit = data['unit'];
    String level = data['level'];
    if (value == 1) {
      if(level=="2"){
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, usernameAPI, id, unit, level);
      });
      print(pesan);
    } else {
      setState(() {
        _loginStatus = LoginStatus.signInUsers;
        savePref(value, usernameAPI, id, unit, level);
      });
      print(pesan);
    }
    }else{
    showFloatingFlushbarLogin(context);
    }
  }

  savePref(int value, String username, String id, String unit, String level) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("unit", unit);
      preferences.setString("username", username);
      preferences.setString("id", id);
      preferences.setString("level", level);
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getString("level");

      _loginStatus = value == 1 ? LoginStatus.signInUsers : value==2 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("level", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return new Center(
      child: new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ), 
    home:  Scaffold(
          body: Form(
            key: _key,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: SizedBox(
                        height: 155.0,
                        child: Image.asset(
                          "assets/semen.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                ),
                TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Please insert username";
                    }
                  },
                  onSaved: (e) => username = e,
                  decoration: InputDecoration(
                    helperText: "Gunakan username akun perusahaan",
                    prefixIcon: (Icon(Icons.person)),
                    labelText: "Username",
                  ),
                ),
                TextFormField(
                  obscureText: _secureText,
                  onSaved: (e) => password = e,
                  decoration: InputDecoration(
                    helperText: "Gunakan password akun perusahaan",
                    labelText: "Password",
                    prefixIcon: (Icon(Icons.enhanced_encryption)),
                    suffixIcon: IconButton(
                      onPressed: showHide,
                      icon: Icon(_secureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    check();
                  },
                  child: Text("Login"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:30.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: Text(
                      "Klik disini untuk membuat akun baru",
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        )));
        break;
      case LoginStatus.signIn:
        return MainMenu(signOut);
        break;
        case LoginStatus.signInUsers:
        return MenuUsers(signOut);
        break;
    }
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String username, password, nama;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
      
    }
  }

  save() async {
    final response = await http.post(BaseUrl.register,
        body: {"username": username, "password": password,"login":"login"});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        showFloatingFlushbar(context);
      });
    } else if(value == 2) {
      print(pesan);
      setState(() {
       showFloatingFlushbarGagal(context); 
      });
    } else{
      print(pesan);
      setState(() {
       showFloatingFlushbarGagalAD(context); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            // TextFormField(
            //   validator: (e) {
            //     if (e.isEmpty) {
            //       return "Please insert fullname";
            //     }
            //   },
            //   onSaved: (e) => nama = e,
            //   decoration: InputDecoration(labelText: "Nama Lengkap"),
            // ),
            Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: SizedBox(
                        height: 155.0,
                        child: Image.asset(
                          "assets/semen.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                ),
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Please insert username";
                }
              },
              onSaved: (e) => username = e,
              decoration: InputDecoration(labelText: "Username",
              helperText: "Gunakan username akun perusahaan",
                    prefixIcon: (Icon(Icons.person)),),
            ),
            TextFormField(
              obscureText: _secureText,
              onSaved: (e) => password = e,
              decoration: InputDecoration(
                labelText: "Password",
                helperText: "Gunakan password akun perusahaan",
                    prefixIcon: (Icon(Icons.enhanced_encryption)),
                suffixIcon: IconButton(
                  onPressed: showHide,
                  icon: Icon(
                      _secureText ? Icons.visibility_off : Icons.visibility),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String username = "", nama = "";
  TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      // nama = preferences.getString("nama");
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Abnormalitas5P"),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(Icons.exit_to_app),
            )
          ],
          
        ),
        body: Product(),
      ),
    );
  }
}

void showFloatingFlushbar(BuildContext context) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: 8,
      icon: Icon(Icons.check, color: Colors.white,),
      duration: Duration(seconds: 2),
      backgroundGradient: LinearGradient(
        colors: [Colors.green.shade500, Colors.white],
        stops: [0.6, 1],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: 'Selamat!',
      message: 'Register berhasil',
    )..show(context);
  }

  void showFloatingFlushbarGagal(BuildContext context) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: 8,
      icon: Icon(Icons.warning,color: Colors.yellow,),
      duration: Duration(seconds: 4),
      backgroundGradient: LinearGradient(
        colors: [Colors.red.shade500, Colors.white],
        stops: [0.6, 1],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: 'Perhatian!',
      message: 'Register gagal, akun anda sudah terdaftar',
    )..show(context);
  }

  void showFloatingFlushbarGagalAD(BuildContext context) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: 8,
      icon: Icon(Icons.warning,color: Colors.yellow,),
      duration: Duration(seconds: 4),
      backgroundGradient: LinearGradient(
        colors: [Colors.red.shade500, Colors.white],
        stops: [0.6, 1],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: 'Perhatian!',
      message: 'Register gagal, akun yang anda coba daftarkan tidak sesuai dengan email atau password perusahaan',
    )..show(context);
  }
  void showFloatingFlushbarLogin(BuildContext context) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: 8,
      icon: Icon(Icons.warning,color: Colors.yellow,),
      duration: Duration(seconds: 4),
      backgroundGradient: LinearGradient(
        colors: [Colors.red.shade500, Colors.white],
        stops: [0.6, 1],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: 'Perhatian!',
      message: 'Login gagal, pastikan anda mengisi username dan password dengan benar',
    )..show(context);
  }