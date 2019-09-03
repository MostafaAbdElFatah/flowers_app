import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  int discount;
  String flowerName;
  String id;
  String payment;
  int quantity;
  bool status;
  double totalPrice;

  Order({
    this.discount,
    this.flowerName,
    this.id,
    this.payment,
    this.quantity,
    this.status,
    this.totalPrice,
  });

  factory Order.fromJson(Map<dynamic, dynamic> json) => new Order(
    discount: json["discount"],
    flowerName: json["flowerName"],
    id: json["id"],
    payment: json["payment"],
    quantity: json["quantity"],
    status: json["status"],
    totalPrice: json["totalPrice"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "discount": discount,
    "flowerName": flowerName,
    "id": id,
    "payment": payment,
    "quantity": quantity,
    "status": status,
    "totalPrice": totalPrice,
  };
}