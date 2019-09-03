import 'package:flutter/material.dart';
import 'package:flowers_app/APIsServices/AuthManager.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:flowers_app/views/FlowerPage.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  ProgressHUD _progressHUD;
  var _formKey = GlobalKey<FormState>();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _progressHUD = new ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor: Colors.black,
      borderRadius: 5.0,
      //text: 'Logging\nplease wait...',
      loading: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/images/flower_bg.png',
              width: size.width,
              height: size.height,
              fit: BoxFit.fill,
            ),
          ),
          Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/flower_log.png',
                    fit: BoxFit.fill,
                    height: size.height / 3,
                    width: size.height / 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.white),
                    controller: _emailController,
                    validator: _validateEmail,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter Email here",
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      errorStyle: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    controller: _passwordController,
                    validator: _validatePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter Password here",
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      errorStyle: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            bottom: 20,
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    child: RaisedButton(
                      onPressed: _signInClicked,
                      color: Colors.white,
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontFamily: 'nabila',
                          fontSize: 15,
                          color: Color.fromRGBO(83, 3, 103, 1),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _progressHUD,
        ],
      ),
    );
  }

  void _signInClicked() {
    if (_formKey.currentState.validate()) {
      _progressHUD.state.show();

      /// sign up to server
      AuthManager authManager = AuthManager();
      authManager
          .signInUser(_emailController.text, _passwordController.text)
          .then((uid) {
        _progressHUD.state.dismiss();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) {
            return FlowerPage();
          }),
          ModalRoute.withName("/Home"),
        );
      });
    }
  }

  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty)
      return 'Email is required';
    else if (!regex.hasMatch(value))
      return 'invalid Email';
    else
      return null;
  }

  String _validatePassword(String value) {
    if (value.isEmpty)
      return 'Password is required';
    else if (value.length < 6)
      return 'Password must at least 6 digit';
    else
      return null;
  }
}
