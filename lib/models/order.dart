import 'package:sayarty/models/car.dart';

class Order {
  final String id;
  final String userId;
  final Car car;
  final String orderDate;

  Order({
    required this.id,
    required this.userId,
    required this.car,
    required this.orderDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'car': car.toMap(),
      'orderDate': orderDate,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      userId: map['userId'] as String,
      car: Car.fromMap(map['car'] as Map<String, dynamic>),
      orderDate: map['orderDate'] as String,
    );
  }
}
