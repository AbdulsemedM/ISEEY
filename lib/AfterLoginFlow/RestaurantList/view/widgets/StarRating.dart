// lib/widgets/StarRating.dart
import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;

  const StarRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool hasHalfStar = rating - fullStars > 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(
        5,
        (index) {
          if (index < fullStars) {
            return const Icon(
              Icons.star,
              color: Colors.amber,
              size: 10.0,
            );
          } else if (index == fullStars && hasHalfStar) {
            return const Icon(
              Icons.star_half,
              color: Colors.amber,
              size: 10.0,
            );
          } else {
            return const Icon(
              Icons.star_border,
              color: Colors.white,
              size: 10.0,
            );
          }
        },
      ),
    );
  }
}