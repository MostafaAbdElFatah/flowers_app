import 'package:flutter/material.dart';
import 'package:flowers_app/APIsServices/AuthManager.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:flowers_app/views/FlowerPage.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  ProgressHUD _progressHUD;
  var _formKey = GlobalKey<FormState>();
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _phoneController = TextEditingController();
  var _passwordController = TextEditingController();
  var _confirmPassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _progressHUD = new ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor: Colors.black,
      borderRadius: 5.0,
      //text: 'Creating Account\nplease wait...',
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
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.white),
                    controller: _nameController,
                    validator: _validateUserName,
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "Enter Name here",
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
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: Colors.white),
                    controller: _phoneController,
                    validator: _validateMobile,
                    decoration: InputDecoration(
                      labelText: "Phone",
                      hintText: "Enter Phone here",
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    controller: _confirmPassController,
                    validator: _validateConfirmPassword,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      hintText: "Enter Confirm Password here",
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
                      onPressed: _signUpClicked,
                      color: Color.fromRGBO(26, 92, 78, 1),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          fontFamily: 'nabila',
                          fontSize: 15,
                          color: Colors.white,
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

  void _signUpClicked() {
    if (_formKey.currentState.validate()) {
      _progressHUD.state.show();
      /// sign up to server
      AuthManager authManager = AuthManager();
      authManager
          .signUpUser(_nameController.text, _emailController.text,
              _phoneController.text, _passwordController.text)
          .then((uid) {
        _progressHUD.state.dismiss();
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return FlowerPage();
        }), ModalRoute.withName("/Home"));
      }).catchError((error){
        _progressHUD.state.dismiss();
        print(error);
        _showDialog(error.toString());
      });
    }
  }

  String _validateUserName(String value) {
    if (value.isEmpty)
      return 'User Name is required';
    else
      return null;
  }

  String _validateMobile(String value) {
    if (value.isEmpty)
      return 'Mobile Number is required';
    else if (value.length != 11)
      return 'Mobile Number must be of 11 digit';
    else
      return null;
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

  String _validateConfirmPassword(String value) {
    if (value.isEmpty)
      return 'Confirm password is required';
    else if (value != _passwordController.text)
      return 'Passwords aren\'t same';
    else
      return null;
  }


  void _showDialog(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Eroor"),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
