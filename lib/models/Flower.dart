import 'dart:convert';

Flower flowerFromJson(String str) => Flower.fromJson(json.decode(str));

String flowerToJson(Flower data) => json.encode(data.toJson());

class Flower {
  String category;
  String instructions;
  String name;
  String photo;
  double price;
  int productId;
  String url;

  Flower({
    this.category,
    this.instructions,
    this.name,
    this.photo,
    this.price,
    this.productId,
  });

  factory Flower.fromJson(Map<dynamic, dynamic> json) => new Flower(
    category: json["category"],
    instructions: json["instructions"],
    name: json["name"],
    photo: json["photo"],
    price: json["price"].toDouble(),
    productId: json["productId"],
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "instructions": instructions,
    "name": name,
    "photo": photo,
    "price": price,
    "productId": productId,
  };
}
