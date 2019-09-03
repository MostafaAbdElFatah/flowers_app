import 'package:flutter/material.dart';
import 'SignIn.dart';
import 'SignUp.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Center(
          child: Image.asset(
            'assets/images/flower_bg.png',
            width: size.width,
            height: size.height,
            fit: BoxFit.fill,
          ),
        ),
        Column(
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
              child: Text(
                "the best and freshest flowers The Flower Boutique has exactly what you’re looking for! Check out our wide selection of flower arrangements to make your next occasion memorable.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'nabila',
                  fontSize: 15,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 50,
          right: 50,
          bottom: 20,
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return SignUp();
                      }));
                    },
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
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return SignIn();
                      }));
                    },
                    color: Colors.white,
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontFamily: 'nabila',
                        fontSize: 15,
                        color: Color.fromRGBO(83, 3, 103 ,1),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
