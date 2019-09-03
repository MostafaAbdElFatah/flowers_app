import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flowers_app/models/Flower.dart';
import 'package:flowers_app/views/SliverContainer.dart';
import 'package:flowers_app/APIsServices/DatabaseManager.dart';
import 'package:flowers_app/models/Order.dart';

class FlowerDetails extends StatefulWidget {
  Flower flower;

  FlowerDetails({@required this.flower});

  @override
  _FlowerDetailsState createState() => _FlowerDetailsState();
}

class _FlowerDetailsState extends State<FlowerDetails> {
  int counter = 0;
  String payment;
  final List<String> _dropdownValues = [
    "PayPal",
    "Credit Card",
    "With Delviery",
  ];

  @override
  void initState() {
    super.initState();
  }

  void _makeOrder() {
    if (counter <= 0) {
      _showDialog("Error", "Please Selected  Quantity");
      return;
    }
    if (payment == null) {
      _showDialog("Error", "Please Selected Payment Method");
      return;
    }
    var dbManager = DatabaseManager();

    dbManager.saveOrder(Order(
        flowerName: widget.flower.name,
        quantity: counter,
        discount: 0,
        payment: payment,
        status: false,
        totalPrice: (counter * widget.flower.price)));
    _showDialog("Success", "Order save successfully");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      body: new Builder(
        builder: (context) => new SliverContainer(
          floatingActionButton: FloatingActionButton(
            onPressed: _makeOrder,
            child: new Icon(
              Icons.add_shopping_cart,
              color: Color.fromRGBO(26, 92, 78, 1),
            ),
            backgroundColor: Colors.white,
          ),
          expandedHeight: size.height / 2,
          slivers: <Widget>[
            SliverAppBar(
              iconTheme: IconThemeData(color: Colors.white),
              expandedHeight: size.height / 2,
              pinned: true,
              flexibleSpace: new FlexibleSpaceBar(
                title: new Text(
                  widget.flower.name,
                  style: TextStyle(color: Colors.white),
                ),
                background: FadeInImage.assetNetwork(
                  placeholder: "assets/images/loading.png",
                  image: widget.flower.url,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
              delegate: new SliverChildListDelegate(
                List.generate(1, (index) => getContent()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getContent() {
    return Column(
      children: <Widget>[
        Card(
          margin: EdgeInsets.only(left: 10, right: 10, top: 50, bottom: 20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Text(
                    widget.flower.category,
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "\$" + widget.flower.price.toString(),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              widget.flower.instructions,
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.only(left: 10, right: 10, top: 50, bottom: 20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Quantity",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                SizedBox(
                  child: Container(
                    margin: const EdgeInsets.all(20.0),
                    width: 200,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(26, 92, 78, 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (counter > 0)
                                setState(() {
                                  counter--;
                                });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            counter.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                counter++;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 100),
          child: SizedBox(
            width: double.infinity,
            height: 90,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: RaisedButton(
                  color: Color.fromRGBO(26, 92, 78, 1),
                  onPressed: () {
                    _displayDialog(context);
                  },
                  child: Text(
                    "Payment Method",
                    style: TextStyle(
                      fontFamily: 'nabila',
                      fontSize: 15,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 200,
        )
      ],
    );
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

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Payment'),
            content: DropdownButton(
              items: _dropdownValues
                  .map((value) => DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      ))
                  .toList(),
              onChanged: (String value) {
                setState(() {
                  payment = value;
                });
              },
              isExpanded: false,
              hint: Text('Select Payment Method'),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
