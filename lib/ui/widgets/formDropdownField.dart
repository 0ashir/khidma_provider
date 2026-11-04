import 'package:flutter/material.dart';

import '../../app/generalImports.dart';

class CustomFormDropdown extends StatefulWidget {
  final VoidCallback onTap;
  final String? Function(String?)? validator;
  final String? initialTitle;
  final String? selectedValue;

  const CustomFormDropdown({
    super.key,
    required this.onTap,
    this.validator,
    this.initialTitle,
    this.selectedValue,
  });

  @override
  State<CustomFormDropdown> createState() => _CustomFormDropdownState();
}

class _CustomFormDropdownState extends State<CustomFormDropdown> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      validator: widget.validator,
      onTap: widget.onTap,
      style: TextStyle(
        fontSize: 14,
        color: Theme.of(context).colorScheme.blackColor,
      ),
      controller: TextEditingController(
        text: widget.selectedValue ?? widget.initialTitle,
      ),
      decoration: InputDecoration(
        errorStyle: const TextStyle(fontSize: 12),
        suffixIcon: Icon(
          Icons.arrow_drop_down_sharp,
          color: Theme.of(context).colorScheme.blackColor,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.redColor),
          borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.accentColor,
          ),
          borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.lightGreyColor,
          ),
          borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.accentColor,
          ),
          borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
        ),
      ),
    );
  }
}
