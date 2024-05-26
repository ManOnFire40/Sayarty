import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:sayarty/models/car.dart';
import 'package:sayarty/pages/cardetails.dart';
import 'package:sayarty/pages/checkout.dart';
import 'package:sayarty/providers/auth_provider.dart' as myAuth;

class FeaturedCars extends StatelessWidget {
  final List<Car> cars;
  final Function(Car) addFavorite;

  const FeaturedCars({
    Key? key,
    required this.cars,
    required this.addFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final demoCars = _getDemoCars();
    return SizedBox(
      height: 360,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: demoCars.map((car) {
          return _featuredCarItem(context, car);
        }).toList(),
      ),
    );
  }

  List<Car> _getDemoCars() {
    return [
      Car(
        id: '1',
        name: 'Toyota Camry',
        price: '\$24,000',
        image: 'https://www.toyota.com/imgix/responsive/images/mlp/colorizer/2021/camry/3T3/1.png',
        make: 'Toyota',
        makeImage: 'https://www.carlogos.org/car-logos/toyota-logo-2005-download.png',
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
        image: 'https://www.ford.com/is/image/content/dam/brand_ford/en_us/brand/performance/mustang/2021/gallery/dm/21frd_mst_s550_gt_hero_dsc_5915.jpg',
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
        image: 'https://cdn.bmwblog.com/wp-content/uploads/2019/09/BMW-X5-M-SUV.jpg',
        make: 'BMW',
        makeImage: 'https://www.carlogos.org/car-logos/bmw-logo-2020-blue-white.png',
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
        image: 'https://automobiles.honda.com/images/2021/civic-sedan/hero-gallery/2021-civic-sedan-hero-gallery.jpg',
        make: 'Honda',
        makeImage: 'https://www.carlogos.org/car-logos/honda-logo-1700x1150.png',
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
        height: 340,
        margin: const EdgeInsets.only(left: 20, right: 10, bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2736),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _carImage(car),
                Positioned(
                  top: 10,
                  left: 10,
                  child: _carMake(car),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: _favoriteButton(context, car),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _carName(car),
                  const SizedBox(height: 5),
                  _carPrice(car),
                  const SizedBox(height: 5),
                  _carRating(car),
                  const SizedBox(height: 5),
                  _carTransmission(car),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(selectedCar: car),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Car added to checkout!')),
                      );
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Buy Now'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: const Color(0xFF6679C0), // Text color
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _favoriteButton(BuildContext context, Car car) {
    return IconButton(
      icon: const Icon(
        Icons.favorite_border,
        color: Color(0xFFF7F7F7),
      ),
      onPressed: () {
        final authService =
            Provider.of<myAuth.AuthProvider>(context, listen: false);
        String userId = authService.user?.uid ?? "guest_${DateTime.now().millisecondsSinceEpoch}";

        final databaseReference = FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(userId)
            .child("favorites")
            .push();
        final favoriteId = databaseReference.key;

        final newFavoriteCar = car.copyWith(id: favoriteId);
        databaseReference.set(newFavoriteCar.toMap()).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Car added to favorites!')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add car to favorites: $error')),
          );
        });
      },
    );
  }

  Container _carMake(Car car) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(car.makeImage),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }

  Container _carPrice(Car car) {
    return Container(
      child: Text(
        car.price,
        style: const TextStyle(
          color: Color(0xFF6679C0),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Container _carTransmission(Car car) {
    return Container(
      child: Text(
        car.transmission,
        style: const TextStyle(
          color: Color(0xFFACB4C4),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Container _carRating(Car car) {
    return Container(
      child: Row(
        children: [
          Text(
            car.rating.toString(),
            style: const TextStyle(
              color: Color(0xFFFFBF00),
              fontSize: 16,
              fontWeight: FontWeight.w600,
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
      child: Text(
        car.name,
        style: const TextStyle(
          color: Color(0xFFF7F7F7),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Container _carImage(Car car) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        image: DecorationImage(
          image: NetworkImage(car.image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
