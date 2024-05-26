class Car {
  final String id;
  final String name;
  final String price;
  final String image;
  final String make;
  final String makeImage;
  final List<String> comments;
  final String description;
  final int rating;
  final String transmission;
  final String userId;
  final String userPhone;
  final String? userEmail;

  Car({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.make,
    required this.makeImage,
    required this.comments,
    required this.description,
    required this.rating,
    required this.transmission,
    required this.userId,
    required this.userPhone,
    this.userEmail,
  });

  Car copyWith({
    String? id,
    String? name,
    String? price,
    String? image,
    String? make,
    String? makeImage,
    List<String>? comments,
    String? description,
    int? rating,
    String? transmission,
    String? userId,
    String? userPhone,
    String? userEmail,
  }) {
    return Car(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      make: make ?? this.make,
      makeImage: makeImage ?? this.makeImage,
      comments: comments ?? this.comments,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      transmission: transmission ?? this.transmission,
      userId: userId ?? this.userId,
      userPhone: userPhone ?? this.userPhone,
      userEmail: userEmail ?? this.userEmail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'make': make,
      'makeImage': makeImage,
      'comments': comments,
      'description': description,
      'rating': rating,
      'transmission': transmission,
      'userId': userId,
      'userPhone': userPhone,
      'userEmail': userEmail,
    };
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'] as String,
      name: map['name'] as String,
      price: map['price'] as String,
      image: map['image'] as String,
      make: map['make'] as String,
      makeImage: map['makeImage'] as String,
      comments: List<String>.from(map['comments'] as List<dynamic>),
      description: map['description'] as String,
      rating: map['rating'] as int,
      transmission: map['transmission'] as String,
      userId: map['userId'] as String,
      userPhone: map['userPhone'] as String,
      userEmail: map['userEmail'] as String?,
    );
  }
}
