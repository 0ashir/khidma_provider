import 'package:flutter/material.dart';

import '../../../../app/generalImports.dart';

/// A bill row whose arrow opens [details] (e.g. base price + each tax) under it.
class ExpandableChargeRow extends StatefulWidget {
  const ExpandableChargeRow({
    super.key,
    required this.title,
    required this.amount,
    required this.details,
  });

  final String title;
  final String amount;
  final List<Widget> details;

  @override
  State<ExpandableChargeRow> createState() => _ExpandableChargeRowState();
}

class _ExpandableChargeRowState extends State<ExpandableChargeRow> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInkWellContainer(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: CustomText(
                        widget.title,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        maxLines: 1,
                        color: context.colorScheme.blackColor,
                      ),
                    ),
                    const SizedBox(width: 2),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: context.colorScheme.lightGreyColor,
                      ),
                    ),
                  ],
                ),
              ),
              CustomText(
                widget.amount,
                textAlign: TextAlign.end,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.colorScheme.blackColor,
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: _expanded
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsetsDirectional.only(start: 4, top: 6),
                  padding: const EdgeInsetsDirectional.only(start: 12),
                  decoration: BoxDecoration(
                    // Same color as the detail labels (base price / tax).
                    border: BorderDirectional(
                      start: BorderSide(
                        color: context.colorScheme.lightGreyColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Column(children: widget.details),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

/// A small label/amount line shown under an [ExpandableChargeRow].
class ChargeDetailRow extends StatelessWidget {
  const ChargeDetailRow({super.key, required this.label, required this.amount});

  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: CustomText(
              label,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: context.colorScheme.lightGreyColor,
            ),
          ),
          CustomText(
            amount,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: context.colorScheme.blackColor,
          ),
        ],
      ),
    );
  }
}
