import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../components/car_make.dart';
import '../components/featured_cars.dart';
import './car_makes_screen.dart';
import './login_screen.dart';
import './profile_information.dart';
import './favorites.dart';
import 'package:sayarty/models/car.dart';
import './addingcars.dart';
import '../providers/auth_provider.dart';
import '../main.dart';
import './profile_information.dart';
import './errorPopup.dart';
import '../Users_Read_write.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  List<Car> _favorites = [];
  List<Car> _userAddedCars = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addFavorite(Car car) {
    setState(() {
      final authService = Provider.of<AuthProvider>(context, listen: false);
      String userId = authService.user?.uid ?? "12345";

      if (!_favorites.any((element) => element.name == car.name) &&
          userId != "12345") {
        _favorites.add(car);
      } else if (userId == "12345") {
        showErrorDialog(
            context, 'Can not add to favorites without authentication ');
      } else {
        showErrorDialog(context, 'Car already added to the favorites');
      }
    });
  }

  void _addUserCar(Car car) {
    setState(() {
      _userAddedCars.add(car);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthProvider>(context, listen: false);

    FirebaseService readWriteUsers = FirebaseService();
    String userId = authService.user?.uid ?? "12345";

    List<Widget> widgetOptions = <Widget>[
      HomeContent(
        addFavorite: _addFavorite,
        userAddedCars: _userAddedCars,
      ),
      userId != "12345" ? FavoritesPage(favorites: _favorites) : Login(),
      userId != "12345" ? ProfileInformation() : Login(),
    ];

    return Scaffold(
      appBar: _appBar(context),
      body: IndexedStack(
        index: _selectedIndex,
        children: widgetOptions,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCarScreen(addCar: _addUserCar),
                  ),
                );
              },
              backgroundColor: const Color(0xFF6679C0),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1F2736),
        selectedItemColor: const Color(0xFF6679C0),
        unselectedItemColor: const Color(0xFFF7F7F7),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color(0xFFF7F7F7)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Color(0xFFF7F7F7)),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Color(0xFFF7F7F7)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    final authService = Provider.of<AuthProvider>(context, listen: false);
    String userId = authService.user?.uid ?? "12345";
    return AppBar(
      backgroundColor: const Color(0xFF1F2736),
      centerTitle: true,
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: null,
                  icon: Icon(Icons.location_on,
                      color: Color(0xFFF7F7F7), size: 20)),
              Text('Cairo,Egypt',
                  style: TextStyle(
                      color: Color(0xFFF7F7F7),
                      fontSize: 16,
                      fontWeight: FontWeight.w400)),
              Icon(
                Icons.arrow_drop_down,
                color: Color(0xFFF7F7F7),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFF7F7F7), width: 1),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications),
            color: const Color(0xFFF7F7F7),
            onPressed: () {
              // go to notifications
            },
          ),
        ),
      ],
      leading: Container(
        margin: const EdgeInsets.only(left: 10),
        child: IconButton(
          icon: const CircleAvatar(
            backgroundImage:
                NetworkImage('https://avatar.iran.liara.run/public'),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => userId != "12345"
                        ? const ProfileInformation()
                        : const Login()

                    //     ,

                    ));
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
          },
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final Function(Car) addFavorite;
  final List<Car> userAddedCars;

  const HomeContent(
      {super.key, required this.addFavorite, required this.userAddedCars});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _headingText(context),
        _searchBarHeading(),
        _searchBar(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, top: 20),
              child: const Text(
                'Available Cars',
                style: TextStyle(
                    color: Color(0xFFF7F7F7),
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(right: 20, top: 20),
                child: RichText(
                  text: TextSpan(
                    text: 'View All',
                    style: const TextStyle(
                        color: Color(0xFF6679C0),
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CarMakes()));
                      },
                  ),
                )),
          ],
        ),
        const SizedBox(height: 20),
        const CarMake(
          showAll: false,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: const Text(
                'Featured Cars',
                style: TextStyle(
                    color: Color(0xFFF7F7F7),
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(right: 20),
                child: RichText(
                  text: TextSpan(
                    text: 'View All',
                    style: const TextStyle(
                        color: Color(0xFF6679C0),
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // go to all popular cars
                      },
                  ),
                )),
          ],
        ),
        const SizedBox(height: 20),
        FeaturedCars(
          addFavorite: widget.addFavorite,
          cars: [],
        ),
        if (widget.userAddedCars.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'User Added Cars',
              style: TextStyle(
                  color: Color(0xFFF7F7F7),
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 340,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.userAddedCars.length,
              itemBuilder: (context, index) {
                return _userCarItem(
                    widget.userAddedCars[index], widget.addFavorite);
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _userCarItem(Car car, Function(Car) addFavorite) {
    return Container(
      width: 250,
      height: 340,
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
              _favoriteButton(car, addFavorite),
            ],
          ),
          _carImage(car),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _carName(car),
              _carPrice(car),
            ],
          ),
        ],
      ),
    );
  }

  Container _searchBarHeading() {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 10),
      child: const Text(
        'Let\'s find your favorite car here',
        style: TextStyle(
            color: Color(0xFFF7F7F7),
            fontSize: 14,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  Row _searchBar(BuildContext context) {
    return Row(
      children: [
        Container(
            margin: const EdgeInsets.only(left: 20, top: 15),
            width: MediaQuery.of(context).size.width * 0.77,
            height: 50,
            child: TextField(
              cursorColor: const Color(0xFFF7F7F7),
              style: const TextStyle(
                  color: Color(0xFFF7F7F7),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 15),
                hintText: 'Search for cars',
                hintStyle: const TextStyle(
                    color: Color(0xFFACB4C4),
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFACB4C4)),
                filled: true,
                fillColor: const Color(0xFF272F3E),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF272F3E)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF272F3E)),
                ),
              ),
            )),
        Container(
          margin: const EdgeInsets.only(left: 10, top: 15),
          width: MediaQuery.of(context).size.width * 0.13,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF6679C0),
          ),
          child: IconButton(
            icon: const Icon(Icons.filter_list),
            color: const Color(0xFFF7F7F7),
            onPressed: () {
              // go to filters
            },
          ),
        ),
      ],
    );
  }

  Widget _headingText(BuildContext context) {
    final authService = Provider.of<AuthProvider>(context, listen: false);

    FirebaseService readWriteUsers = FirebaseService();
    String userId = authService.user?.uid ?? "12345";

    return FutureBuilder<String?>(
      future: readWriteUsers.readUserUserName(userId),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // or some other widget while waiting
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    'Hello ${snapshot.data ?? "Guest"}', // snapshot.data contains your username
                    style: const TextStyle(
                        color: Color(0xFFF7F7F7),
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          }
        }
      },
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
      width: 250,
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(car.image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container _favoriteButton(Car car, Function(Car) addFavorite) {
    return Container(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: const Icon(
          Icons.favorite_border,
          color: Color(0xFFF7F7F7),
        ),
        onPressed: () {
          addFavorite(car);
        },
      ),
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
}
