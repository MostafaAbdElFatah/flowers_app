import 'package:flutter/material.dart';
import 'login_view.dart';
import 'CartPage.dart';
import 'OrdersPage.dart';
import 'package:flowers_app/models/User.dart';
import 'package:flowers_app/models/Flower.dart';
import 'package:flowers_app/APIsServices/DatabaseManager.dart';
import 'package:flowers_app/APIsServices/AuthManager.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:flowers_app/views/FlowerDetails.dart';

class FlowerPage extends StatefulWidget {
  @override
  _FlowerPageState createState() => _FlowerPageState();
}

class _FlowerPageState extends State<FlowerPage> {
  User user;
  ProgressHUD _progressHUD;
  var dbManager = DatabaseManager();
  var _flowersList = List<Flower>();

  @override
  void initState() {
    super.initState();

    _progressHUD = new ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor: Colors.black,
      borderRadius: 5.0,
      //text: 'Logging\nplease wait...',
      loading: true,
    );

    dbManager.getUserInfo().then((userInfo) {
      setState(() {
        user = userInfo;
      });
    }).catchError((error) {});
    dbManager.getFlowersList().then((list) {
      setState(() {
        _progressHUD.state.dismiss();
        _flowersList.clear();
        _flowersList.addAll(list);
      });
    }).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Flowers List"),
      ),
      drawer: _getDrawer(),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/images/flower_bg.png',
              width: size.width,
              height: size.height,
              fit: BoxFit.fill,
            ),
          ),
          _getBody(),
          _progressHUD
        ],
      ),
    );
  }

  Widget _getBody() {
    return ListView.builder(
      itemCount: _flowersList.length,
      itemBuilder: (context, index) {
        return _getListViewRow(index);
      },
    );
  }

  Widget _getListViewRow(int index) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.white, width: 5.0)),
        child: ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FlowerDetails(flower: _flowersList[index]);
            }));
          },
          title: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/images/loading.png",
                  image: _flowersList[index].url,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          _flowersList[index].name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Text(
                              _flowersList[index].category,
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "\$" + _flowersList[index].price.toString(),
                              textAlign: TextAlign.end,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getDrawer() {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: Align(
          alignment: Alignment.topLeft,
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(36, 36, 36, 1),
                ),
                accountName: Text(user == null ? "user name" : user.name),
                accountEmail:
                    Text(user == null ? "user@gmail.com" : user.email),
              ),
              Card(
                color: Colors.black,
                child: ListTile(
                  onTap: () {
                    _drawerItemSelected(0);
                  },
                  leading: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Home",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.black,
                child: ListTile(
                  onTap: () {
                    _drawerItemSelected(1);
                  },
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Cart",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.black,
                child: ListTile(
                  onTap: () {
                    _drawerItemSelected(2);
                  },
                  leading: Icon(
                    Icons.access_time,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Orders",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.black,
                child: ListTile(
                  onTap: () {
                    _drawerItemSelected(3);
                  },
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Log Out",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _drawerItemSelected(int index) {
    switch (index) {
      case 0:
        Navigator.pop(context);
        break;
      case 1:
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CartPage();
        }));
        break;
      case 2:
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OrdersPage();
        }));
        break;
      case 3:
        Navigator.pop(context);
        var authManager = AuthManager();
        authManager.logOut();
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return Login();
        }), ModalRoute.withName("/Home"));
        break;
    }
  }
}
