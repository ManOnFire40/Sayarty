import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarty/models/car.dart';
import '../providers/auth_provider.dart';
import 'package:firebase_database/firebase_database.dart';

class CarDetails extends StatefulWidget {
  final Car car;

  const CarDetails({Key? key, required this.car}) : super(key: key);

  @override
  _CarDetailsState createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  final _commentController = TextEditingController();
  int _userRating = 0;

  void _addComment() {
    final authService = Provider.of<AuthProvider>(context, listen: false);
    if (authService.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to add a comment.')),
      );
      return;
    }

    final newComment = Comment(
      userId: authService.user!.uid,
      userName: authService.user!.email ?? 'Anonymous',
      text: _commentController.text,
      date: DateTime.now(),
    );

    final updatedComments = List<Comment>.from(widget.car.comments)..add(newComment);

    final updatedCar = widget.car.copyWith(comments: updatedComments);

    setState(() {
      widget.car.comments.add(newComment);
      _commentController.clear();
    });

    final databaseReference = FirebaseDatabase.instance.ref().child("cars").child(widget.car.id);
    databaseReference.update({
      'comments': updatedCar.comments.map((comment) => comment.toMap()).toList(),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment added successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add comment: $error')),
      );
    });
  }

  void _rateCar(int rating) {
    final authService = Provider.of<AuthProvider>(context, listen: false);
    if (authService.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to rate the car.')),
      );
      return;
    }

    final updatedCar = widget.car.copyWith(rating: rating);

    setState(() {
      _userRating = rating;
      widget.car.rating = rating; // Update the car's rating
    });

    final databaseReference = FirebaseDatabase.instance.ref().child("cars").child(widget.car.id);
    databaseReference.update({
      'rating': updatedCar.rating,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rating added successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add rating: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.car.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.car.image),
              const SizedBox(height: 10),
              Text(
                widget.car.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(widget.car.price),
              const SizedBox(height: 10),
              Text(widget.car.description),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Rating: ', style: TextStyle(fontSize: 16)),
                  ...List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < widget.car.rating ? Icons.star : Icons.star_border,
                      ),
                      color: index < widget.car.rating ? Colors.amber : Colors.grey,
                      onPressed: () => _rateCar(index + 1),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Comments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              if (widget.car.comments.isEmpty)
                const Text('No comments yet.')
              else
                ...widget.car.comments.map((comment) {
                  return ListTile(
                    title: Text(comment.userName),
                    subtitle: Text(comment.text),
                    trailing: Text(comment.date.toLocal().toString().split(' ')[0]),
                  );
                }).toList(),
              const SizedBox(height: 20),
              const Text('Add a Comment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addComment,
                child: const Text('Submit Comment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
