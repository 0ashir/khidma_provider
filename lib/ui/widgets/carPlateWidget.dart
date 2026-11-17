import 'package:flutter/material.dart';
import '../../app/generalImports.dart';

/// Shows the customer's car plate number(s) on car-service bookings.
/// Bookings for several cars store one plate per car, comma-separated.
class CarPlateWidget extends StatelessWidget {
  const CarPlateWidget({super.key, required this.plateNumber});

  final String plateNumber;

  List<String> get _plates => plateNumber
      .split(',')
      .map((final String plate) => plate.trim())
      .where((final String plate) => plate.isNotEmpty)
      .toList();

  @override
  Widget build(BuildContext context) {
    final List<String> plates = _plates;
    if (plates.isEmpty) return const SizedBox.shrink();

    final String translated = 'carPlateNumber'.translate(context: context);
    final String singular =
        translated == 'carPlateNumber' ? 'Car plate number' : translated;
    // Plural heading ("Car plate numbers (2)") when several cars are booked.
    final String pluralRaw = 'carPlateNumbers'.translate(context: context);
    final String label = plates.length > 1 && pluralRaw != 'carPlateNumbers'
        ? pluralRaw
        : singular;

    return Column(
      children: [
        CustomContainer(
          color: Theme.of(context).colorScheme.secondaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.directions_car_outlined,
                  size: 22,
                  color: context.colorScheme.accentColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomText(
                    plates.length > 1 ? '$label (${plates.length})' : label,
                    maxLines: 1,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.blackColor,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (int i = 0; i < plates.length; i++)
                      Padding(
                        padding: EdgeInsets.only(top: i == 0 ? 0 : 6),
                        child: CustomText(
                          plates.length > 1
                              ? '${i + 1}. ${plates[i]}'
                              : plates[i],
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.blackColor,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
