import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmerCard(height: 100, context: context), // Free Plan Card
          const SizedBox(height: 18),
          CustomContainer(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildShimmerBox(context: context)),
                const SizedBox(width: 5),
                Expanded(child: _buildShimmerBox(context: context)),
                const SizedBox(width: 5),
                Expanded(child: _buildShimmerBox(context: context)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildShimmerCard(height: 400, context: context),
          const SizedBox(height: 16),
          _buildShimmerCard(height: 100, context: context),
          const SizedBox(height: 16),
          _buildShimmerCard(height: 150, context: context),
          const SizedBox(height: 16),
          _buildShimmerCard(height: 100, context: context),
        ],
      ),
    );
  }

  Widget _buildShimmerCard({double height = 100, required context}) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.shimmerBaseColor,
      highlightColor: Theme.of(context).colorScheme.shimmerHighlightColor,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildShimmerBox({
    double width = 100,
    double height = 50,
    required context,
  }) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.shimmerBaseColor,
      highlightColor: Theme.of(context).colorScheme.shimmerHighlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
