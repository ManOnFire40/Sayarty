import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:sayarty/models/car.dart';
import 'package:sayarty/pages/cardetails.dart';
import 'package:sayarty/providers/auth_provider.dart' as myAuth;

class FeaturedCars extends StatelessWidget {
  final List<Car> cars;

  const FeaturedCars(
      {Key? key, required this.cars, required Function(Car p1) addFavorite})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dummyCars = _getDummyCars();
    return SizedBox(
      height: 340,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: dummyCars.map((car) {
          return _featuredCarItem(context, car);
        }).toList(),
      ),
    );
  }

  List<Car> _getDummyCars() {
    return [
      Car(
        id: '1',
        name: 'Toyota Camry',
        price: '\$24,000',
        image:
            'https://www.toyota.com/imgix/responsive/images/mlp/colorizer/2021/camry/3T3/1.png',
        make: 'Toyota',
        makeImage:
            'https://www.carlogos.org/car-logos/toyota-logo-2005-download.png',
        comments: [],
        description: 'A reliable and efficient sedan.',
        rating: 4,
        transmission: 'Automatic',
        userId: 'dummy_user',
        userPhone: '+1234567890',
        userEmail: 'dummy@example.com',
      ),
      Car(
        id: '2',
        name: 'Ford Mustang',
        price: '\$36,000',
        image:
            'https://www.ford.com/is/image/content/dam/brand_ford/en_us/brand/performance/mustang/2021/gallery/dm/21frd_mst_s550_gt_hero_dsc_5915.jpg',
        make: 'Ford',
        makeImage: 'https://www.carlogos.org/car-logos/ford-logo-2003.png',
        comments: [],
        description: 'A powerful and iconic muscle car.',
        rating: 5,
        transmission: 'Manual',
        userId: 'dummy_user',
        userPhone: '+1234567890',
        userEmail: 'dummy@example.com',
      ),
      Car(
        id: '3',
        name: 'BMW X5',
        price: '\$58,000',
        image:
            'https://cdn.bmwblog.com/wp-content/uploads/2019/09/BMW-X5-M-SUV.jpg',
        make: 'BMW',
        makeImage:
            'https://www.carlogos.org/car-logos/bmw-logo-2020-blue-white.png',
        comments: [],
        description: 'A luxurious and spacious SUV.',
        rating: 4,
        transmission: 'Automatic',
        userId: 'dummy_user',
        userPhone: '+1234567890',
        userEmail: 'dummy@example.com',
      ),
      Car(
        id: '4',
        name: 'Honda Civic',
        price: '\$20,000',
        image:
            'https://automobiles.honda.com/images/2021/civic-sedan/hero-gallery/2021-civic-sedan-hero-gallery.jpg',
        make: 'Honda',
        makeImage:
            'https://www.carlogos.org/car-logos/honda-logo-1700x1150.png',
        comments: [],
        description: 'A compact and fuel-efficient car.',
        rating: 4,
        transmission: 'Automatic',
        userId: 'dummy_user',
        userPhone: '+1234567890',
        userEmail: 'dummy@example.com',
      ),
    ];
  }

  Widget _featuredCarItem(BuildContext context, Car car) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarDetails(car: car),
          ),
        );
      },
      child: Container(
        width: 250,
        height: 250,
        margin: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF272F3E),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _carMake(car),
                _addButton(context, car),
              ],
            ),
            _carImage(car),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _carName(car),
                _carRating(car),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _carTransmission(car),
                _carPrice(car),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _addButton(BuildContext context, Car car) {
    return IconButton(
      icon: const Icon(
        Icons.add_circle_outline,
        color: Color(0xFFF7F7F7),
      ),
      onPressed: () {
        final authService =
            Provider.of<myAuth.AuthProvider>(context, listen: false);
        String userId = authService.user?.uid ??
            "guest_${DateTime.now().millisecondsSinceEpoch}";

        final databaseReference = FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(userId)
            .child("cart")
            .push();
        final cartId = databaseReference.key;

        final newCar = car.copyWith(id: cartId);
        databaseReference.set(newCar.toMap()).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Car added to cart!')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add car to cart: $error')),
          );
        });
      },
    );
  }

  Container _carMake(Car car) {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 10, left: 10),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(car.makeImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container _carPrice(Car car) {
    return Container(
      margin: const EdgeInsets.only(right: 10, top: 10),
      child: Text(
        car.price,
        style: const TextStyle(
          color: Color(0xFF6679C0),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Container _carTransmission(Car car) {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 10),
      child: Text(
        car.transmission,
        style: const TextStyle(
          color: Color(0xFFACB4C4),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Container _carRating(Car car) {
    return Container(
      margin: const EdgeInsets.only(right: 10, top: 10),
      child: Row(
        children: [
          Text(
            car.rating.toString(),
            style: const TextStyle(
              color: Color(0xFFF7F7F7),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Icon(
            Icons.star,
            color: Color(0xFFFFBF00),
            size: 16,
          ),
        ],
      ),
    );
  }

  Container _carName(Car car) {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 10),
      child: Text(
        car.name,
        style: const TextStyle(
          color: Color(0xFFF7F7F7),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Container _carImage(Car car) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(car.image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
