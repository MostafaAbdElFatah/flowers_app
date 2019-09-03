import 'package:flutter/material.dart';
import 'login_view.dart';
import 'FlowerPage.dart';
import 'OrdersPage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flowers_app/models/User.dart';
import 'package:flowers_app/models/Order.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:flowers_app/APIsServices/DatabaseManager.dart';
import 'package:flowers_app/APIsServices/AuthManager.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  User user;
  ProgressHUD _progressHUD;
  double _totalPrice = 0.0;
  var dbManager = DatabaseManager();
  var _cartList = List<Order>();
  var _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _progressHUD = new ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor: Colors.black,
      borderRadius: 5.0,
      loading: true,
    );

    dbManager.getUserInfo().then((userInfo) {
      user = userInfo;
      loadOrders();
    }).catchError((error) {});
  }

  void loadOrders() {
    dbManager.getOrdersList().then((orders) {
      setState(() {
        _progressHUD.state.dismiss();
        _cartList.clear();
        orders.removeWhere((item) => item.status);
        _cartList.addAll(orders);
        _totalPrice = 0.0;
        for (var item in _cartList) _totalPrice += item.totalPrice;
      });
    }).catchError((error) {
      _progressHUD.state.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart List"),
      ),
      drawer: _getDrawer(),
      body: Stack(
        children: <Widget>[
          _getBody(),
          Positioned(
            right: 10,
            left: 10,
            bottom: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(26, 92, 78, 1),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Total Orders Price:$_totalPrice\$",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: RaisedButton(
                          color: Colors.white,
                          onPressed: () {
                            _displayInputDialog();
                          },
                          child: Text(
                            "Olace Orders Address",
                            style: TextStyle(
                              fontFamily: 'nabila',
                              fontSize: 15,
                              color: Color.fromRGBO(83, 3, 103, 1),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _progressHUD,
        ],
      ),
    );
  }

  Widget _getBody() {
    return ListView.builder(
      itemCount: _cartList.length,
      itemBuilder: (context, index) {
        return _getListViewCell(index);
      },
    );
  }

  Widget _getListViewCell(int index) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        IconSlideAction(
          caption: 'delete',
          foregroundColor: Colors.red,
          iconWidget: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onTap: () => this._removeOrder(index),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'delete',
          foregroundColor: Colors.red,
          iconWidget: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onTap: () => this._removeOrder(index),
        ),
      ],
      //key: Key(_notesList[index].id.toString()),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    _cartList[index].flowerName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Quanity: " + _cartList[index].quantity.toString(),
                    textAlign: TextAlign.start,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "\$" + _cartList[index].totalPrice.toString(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _removeOrder(int index) {
    dbManager.removeOrder(_cartList[index]);
    setState(() {
      _cartList.removeAt(index);
    });
    _showDialog("Success", 'Order Deleted Successfully');
  }

  void _showDialog(String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
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

  void _displayInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("one More Step!")))
            ],
          ),
          content: SizedBox(
            height: 100,
            child: Center(
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text("Enter your Address!")),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: "Enter Address here",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Save"),
              onPressed: () {
                Navigator.of(context).pop();
                dbManager.saveAddress(_addressController.text);
                _showDialog("Success", 'Saved Address Successfully');
              },
            ),
          ],
        );
      },
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
                accountName: Text("User Name"),
                accountEmail: Text("user@gmail.com"),
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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) {
            return FlowerPage();
          }),
          ModalRoute.withName("/Home"),
        );
        break;
      case 1:
        Navigator.pop(context);
        setState(() {});
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
