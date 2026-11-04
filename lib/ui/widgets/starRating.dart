import 'package:flutter/material.dart';

import '../../app/generalImports.dart';

typedef RatingChangeCallback = void Function(double rating);

class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    this.starCount = 5,
    this.rating = .0,
    required this.onRatingChanged,
  });
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = const Icon(Icons.star, color: AppColors.starRatingColor);
    } else if (index > rating - 1 && index < rating) {
      icon = const Icon(Icons.star_half, color: AppColors.starRatingColor);
    } else {
      icon = const Icon(Icons.star, color: AppColors.starRatingColor);
    }
    return InkResponse(onTap: () => onRatingChanged(index + 1.0), child: icon);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        starCount,
        (int index) => buildStar(context, index),
      ),
    );
  }
}
