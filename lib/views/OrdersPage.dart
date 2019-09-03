import 'package:flutter/material.dart';
import 'login_view.dart';
import 'CartPage.dart';
import 'FlowerPage.dart';
import 'package:flowers_app/models/User.dart';
import 'package:flowers_app/models/Order.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:flowers_app/APIsServices/DatabaseManager.dart';
import 'package:flowers_app/APIsServices/AuthManager.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  User user;
  ProgressHUD _progressHUD;
  var dbManager = DatabaseManager();
  var _ordersList = List<Order>();

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


  void loadOrders(){
    dbManager.getOrdersList().then((orders){
      setState(() {
        _progressHUD.state.dismiss();
        _ordersList.clear();
        orders.removeWhere((item)=> !item.status );
        _ordersList.addAll(orders);
      });
    }).catchError((error){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders List"),
      ),
      drawer: _getDrawer(),
      body: Stack(
        children: <Widget>[
          _getBody(),
          _progressHUD,
        ],
      ),
    );
  }

  Widget _getBody() {
    return ListView.builder(
      itemCount: _ordersList.length,
      itemBuilder: (context, index) {
        return _getListViewCell(index);
      },
    );
  }

  Widget _getListViewCell(int index) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  _ordersList[index].id,
                  textAlign: TextAlign.start,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  user.phone,
                  textAlign: TextAlign.start,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  user.address,
                  textAlign: TextAlign.start,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  _ordersList[index].payment,
                  textAlign: TextAlign.start,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Quanity: " + _ordersList[index].quantity.toString(),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
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
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CartPage();
        }));
        break;
      case 2:
        Navigator.pop(context);
        setState(() {});
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
