import 'package:flutter/material.dart';
import '../../../../app/generalImports.dart';

class BookingDetailsShimmer extends StatelessWidget {
  const BookingDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ShimmerLoadingContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer info section
            _buildSectionShimmer(context),
            const SizedBox(height: 10),
            // Status and invoice section
            _buildSectionShimmer(context, height: 80),
            const SizedBox(height: 10),
            // Date and time section
            _buildSectionShimmer(context, height: 100),
            const SizedBox(height: 10),
            // Notes section
            _buildSectionShimmer(context, height: 60),
            const SizedBox(height: 10),
            // Service details section
            _buildServiceDetailsShimmer(context),
            const SizedBox(height: 10),
            // Price section
            _buildPriceSectionShimmer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionShimmer(BuildContext context, {double height = 120}) {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(15),
      color: Theme.of(context).colorScheme.secondaryColor,
      borderRadius: UiUtils.borderRadiusOf10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CustomShimmerContainer(
                height: 50,
                width: 50,
                borderRadius: UiUtils.borderRadiusOf50,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomShimmerContainer(
                      height: 16,
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                    const SizedBox(height: 8),
                    CustomShimmerContainer(
                      height: 12,
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (height > 80) ...[
            const SizedBox(height: 15),
            CustomShimmerContainer(
              height: 14,
              width: MediaQuery.of(context).size.width * 0.6,
            ),
            const SizedBox(height: 8),
            CustomShimmerContainer(
              height: 14,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceDetailsShimmer(BuildContext context) {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(15),
      color: Theme.of(context).colorScheme.secondaryColor,
      borderRadius: UiUtils.borderRadiusOf10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomShimmerContainer(
            height: 18,
            width: MediaQuery.of(context).size.width * 0.35,
          ),
          const SizedBox(height: 15),
          ...List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const CustomShimmerContainer(
                    height: 60,
                    width: 60,
                    borderRadius: UiUtils.borderRadiusOf10,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomShimmerContainer(
                          height: 14,
                          width: MediaQuery.of(context).size.width * 0.4,
                        ),
                        const SizedBox(height: 6),
                        CustomShimmerContainer(
                          height: 12,
                          width: MediaQuery.of(context).size.width * 0.25,
                        ),
                      ],
                    ),
                  ),
                  const CustomShimmerContainer(height: 16, width: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSectionShimmer(BuildContext context) {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(15),
      color: Theme.of(context).colorScheme.secondaryColor,
      borderRadius: UiUtils.borderRadiusOf10,
      child: Column(
        children: [
          ...List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomShimmerContainer(
                    height: 14,
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                  const CustomShimmerContainer(height: 14, width: 60),
                ],
              ),
            ),
          ),
          const Divider(),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomShimmerContainer(
                height: 18,
                width: MediaQuery.of(context).size.width * 0.25,
              ),
              const CustomShimmerContainer(height: 18, width: 80),
            ],
          ),
        ],
      ),
    );
  }
}
