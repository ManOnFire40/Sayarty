import 'package:flutter/material.dart';
import 'package:sayarty/providers/car_make_provider.dart';
import 'package:provider/provider.dart';

class CarMake extends StatefulWidget {
  final bool showAll;

  const CarMake({Key? key, required this.showAll}) : super(key: key);

  @override
  State<CarMake> createState() => _CarMakeState();
}

class _CarMakeState extends State<CarMake> {
  @override
  void initState() {
    Provider.of<CarMakeProvider>(context, listen: false).fetchCarMakes();
    print('CarMake fetched');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final showAll = widget.showAll;
    final carMakes = Provider.of<CarMakeProvider>(context).carMakes;
    return SizedBox(
      height: !showAll ? 100 : MediaQuery.of(context).size.height,
      child: !showAll
          ? ListView(
              scrollDirection: Axis.horizontal,
              children: carMakes
                  .map((carMake) => _carMakeItem(carMake.name, carMake.image))
                  .take(showAll ? carMakes.length : 5)
                  .toList())
          :
          //add grid view if not show all
          GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: carMakes.length,
              itemBuilder: (context, index) {
                return _carMakeItem(
                    carMakes[index].name, carMakes[index].image);
              },
            ),
    );
  }
}

Widget _carMakeItem(String name, String image) {
  return Container(
    width: 100,
    height: 100,
    margin: const EdgeInsets.only(left: 20),
    decoration: BoxDecoration(
      color: const Color(0xFF272F3E),
      border: Border.all(
        color: const Color(0xFFF7F7F7),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            //size of the image
            image: DecorationImage(
              image: NetworkImage(image),
            ),
          ),
        ),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xFFF7F7F7),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
