class Comment {
  final String userId;
  final String userName;
  final String text;
  final DateTime date;

  Comment({
    required this.userId,
    required this.userName,
    required this.text,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'text': text,
      'date': date.toIso8601String(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      userId: map['userId'],
      userName: map['userName'],
      text: map['text'],
      date: DateTime.parse(map['date']),
    );
  }
}

class Car {
  final String id;
  final String name;
  final String price;
  final String image;
  final String make;
  final String makeImage;
  final List<Comment> comments;
  final String description;
  int rating; // Removed final
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
    List<Comment>? comments,
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
      'comments': comments.map((comment) => comment.toMap()).toList(),
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
      id: map['id'],
      name: map['name'],
      price: map['price'],
      image: map['image'],
      make: map['make'],
      makeImage: map['makeImage'],
      comments: List<Comment>.from(map['comments']?.map((x) => Comment.fromMap(x)) ?? []),
      description: map['description'],
      rating: map['rating'],
      transmission: map['transmission'],
      userId: map['userId'],
      userPhone: map['userPhone'],
      userEmail: map['userEmail'],
    );
  }
}
