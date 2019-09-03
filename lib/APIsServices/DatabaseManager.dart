import 'package:firebase_database/firebase_database.dart';
import 'AuthManager.dart';
import 'package:flowers_app/models/Order.dart';
import 'package:flowers_app/models/Flower.dart';
import 'package:flowers_app/models/User.dart';
import 'StorageManager.dart';

class DatabaseManager {
  DatabaseReference root;
  DatabaseReference users;
  DatabaseReference flowers;
  DatabaseReference orders;
  DatabaseReference currentUser;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  DatabaseManager() {
    root = _firebaseDatabase.reference();
    users = root.child("users");
    flowers = root.child("flowers");
  }

  // MARK:- Save user info to firebase database
  Future<void> saveUserInfo(User user) async {
    AuthManager authManager = AuthManager();
    String uid = await authManager.getCurrentUser();
    currentUser = users.child(uid);

    //var data = {"name": userName, "phone": phone, "address": "No ADDRESS", "device_token":""};

    var result = await currentUser.set(user.toJson());

//    currentUser.child("name").set(userName);
//    currentUser.child("phone").set(phone);
//    currentUser.child("address").set("No ADDRESS");
    return result;
  }

  Future<void> saveDeviceToken() async {
    AuthManager authManager = AuthManager();
    String uid = await authManager.getCurrentUser();
    currentUser = users.child(uid);

    currentUser.child("device_token").set("");
  }

  // set address in firebase database
  Future<void> saveAddress(String address) async {
    AuthManager authManager = AuthManager();
    String uid = await authManager.getCurrentUser();
    currentUser = users.child(uid);

    currentUser.child("address").set(address);
  }

  Future<void> saveOrder(Order order) async {
    AuthManager authManager = AuthManager();
    String uid = await authManager.getCurrentUser();
    currentUser = users.child(uid);
    orders = currentUser.child("orders");

    var dbOrder = orders.push();
    order.id = dbOrder.key;
    dbOrder.set(order.toJson());
  }

  //remove order from firebase
  void removeOrder(Order order) {
    orders.child(order.id).remove();
  }

  // MARK:- get User info
  Future<User> getUserInfo() async {
    AuthManager authManager = AuthManager();
    String uid = await authManager.getCurrentUser();
    currentUser = users.child(uid);

    DataSnapshot snapshot = await currentUser.once();
    Map<dynamic, dynamic> values = snapshot.value;
    User user = User.fromJson(values);
    return user;
  }

  // MARK:- get User info
  Future<List<Flower>> getFlowersList() async {
    DataSnapshot snapshot = await flowers.once();
    Map<dynamic, dynamic> value = snapshot.value;
    var flowersList = List<Flower>();
    value.forEach((key, values) {
      flowersList.add(Flower.fromJson(values));
    });
    for(var index = 0; index < flowersList.length;index++){
      flowersList[index].url = await _getUrl(flowersList[index]);
    }
    return flowersList;
  }

  Future<String> _getUrl(Flower flower) async {
    var storageManager = StorageManager();
    return await storageManager.getImageURL(flower.photo);
  }


  // MARK:- get orders list
  Future<List<Order>> getOrdersList() async {
    AuthManager authManager = AuthManager();
    String uid = await authManager.getCurrentUser();
    currentUser = users.child(uid);
    orders = currentUser.child("orders");

    DataSnapshot snapshot = await orders.once();
    Map<dynamic, dynamic> values = snapshot.value;
    var ordersList = List<Order>();
    values.forEach((key, values) {
      ordersList.add(Order.fromJson(values));
    });
    return ordersList;
  }
}
