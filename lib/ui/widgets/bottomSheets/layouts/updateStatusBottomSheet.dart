import 'package:flutter/material.dart';

import '../../../../app/generalImports.dart';

class UpdateStatusBottomSheet extends StatefulWidget {
  const UpdateStatusBottomSheet({
    super.key,
    required this.selectedItem,
    required this.itemValues,
  });

  final Map<String, String> selectedItem;
  final List<Map<String, String>> itemValues;

  @override
  State<UpdateStatusBottomSheet> createState() =>
      _UpdateStatusBottomSheetState();
}

class _UpdateStatusBottomSheetState extends State<UpdateStatusBottomSheet> {
  late Map<String, String> selectedStatus = widget.selectedItem;

  Widget getFilterOption({required Map<String, String> filterOptionName}) {
    return CustomInkWellContainer(
      onTap: () {
        selectedStatus = filterOptionName;
        setState(() {});
      },
      child: CustomContainer(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              filterOptionName['title'].toString().translate(context: context),
              color: Theme.of(context).colorScheme.blackColor,
              fontWeight: selectedStatus['value'] == filterOptionName['value']
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontStyle: FontStyle.normal,
              fontSize: 14.0,
              textAlign: TextAlign.start,
            ),
            const Spacer(),
            CustomContainer(
              width: 25,
              height: 25,
              child: CustomRadioButton(
                onChanged: (p0) {
                  selectedStatus = filterOptionName;
                  setState(() {});
                },
                value: selectedStatus['value'] == filterOptionName['value'],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetLayout(
      title: "updateStatus",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            List.generate(widget.itemValues.length, (i) {
              return getFilterOption(filterOptionName: widget.itemValues[i]);
            }) +
            <Widget>[
              CloseAndConfirmButton(
                closeButtonPressed: () {
                  Navigator.pop(context);
                },
                confirmButtonPressed: () {
                  Navigator.pop(context, {'selectedStatus': selectedStatus});
                },
                confirmButtonBackgroundColor: Theme.of(
                  context,
                ).colorScheme.accentColor,
              ),
            ],
      ),
    );
  }
}
