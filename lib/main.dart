import 'package:flutter/material.dart';
import 'package:flowers_app/views/login_view.dart';
import 'package:flowers_app/views/FlowerPage.dart';
import 'package:flowers_app/APIsServices/AuthManager.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blue ,
        primaryColorDark: Colors.black,
        primaryColor: Color.fromRGBO(26, 92, 78, 1)
      ),
      home: AppPage() ,
    );
  }

}

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {

  var _isLogging = false;

  @override
  void initState() {
    super.initState();
    AuthManager authManager = AuthManager();
    //authManager.logOut();
    authManager.authChanged().then((user){
      setState(() {
        _isLogging = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLogging? FlowerPage():Login();
  }
}
