import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';

class AdditionalChargesBottomSheet extends StatefulWidget {
  const AdditionalChargesBottomSheet({super.key, this.additionalCharges});

  final List<Map<String, dynamic>>? additionalCharges;

  @override
  State<AdditionalChargesBottomSheet> createState() =>
      _AdditionalChargesBottomSheetState();
}

class _AdditionalChargesBottomSheetState
    extends State<AdditionalChargesBottomSheet> {
  late ValueNotifier<List<Map<String, dynamic>>> addAditionalCharges =
      ValueNotifier(widget.additionalCharges ?? []);

  TextEditingController nameTextController = TextEditingController();
  TextEditingController chargesTextController = TextEditingController();

  Future<void> addCharge() async {
    final String name = nameTextController.text.trim();
    final String charge = chargesTextController.text.trim();

    if (name.isNotEmpty && charge.isNotEmpty) {
      final newCharge = {'name': name, 'charge': charge};

      // Update the ValueNotifier
      addAditionalCharges.value = [...addAditionalCharges.value, newCharge];

      // Clear the text fields
      nameTextController.clear();
      chargesTextController.clear();
    }
  }

  @override
  void dispose() {
    nameTextController.dispose();
    chargesTextController.dispose();
    addAditionalCharges.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetLayout(
      title: 'addAdiotionalCharges',
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Input fields for new charge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            labelText: 'serviceName'.translate(
                              context: context,
                            ),
                            controller: nameTextController,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomTextFormField(
                            labelText: 'chargeAmount'.translate(
                              context: context,
                            ),
                            controller: chargesTextController,
                            textInputType: TextInputType.number,
                            allowOnlySingleDecimalPoint: true,
                          ),
                        ),
                        const SizedBox(width: 10),
                        CustomRoundedButton(
                          height: 48,
                          backgroundColor: context.colorScheme.accentColor,
                          buttonTitle: 'add'.translate(context: context),
                          widthPercentage: .3,
                          showBorder: false,
                          onTap: addCharge,
                        ),
                      ],
                    ),
                    // List of added charges
                    Flexible(
                      child: ValueListenableBuilder(
                        valueListenable: addAditionalCharges,
                        builder:
                            (
                              BuildContext context,
                              List<Map<String, dynamic>> value,
                              Widget? child,
                            ) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (value.isNotEmpty) ...[
                                    const Divider(),
                                    const SizedBox(
                                      height: 10,
                                    ), // Space after divider
                                  ],
                                  Flexible(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(
                                          value.length,
                                          (int index) => Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomContainer(
                                                height: 60,
                                                borderRadius:
                                                    UiUtils.borderRadiusOf10,
                                                border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .blackColor
                                                      .withValues(alpha: 0.5),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 8,
                                                      ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          CustomText(
                                                            value[index]['name'],
                                                            maxLines: 1,
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .blackColor,
                                                          ),
                                                          CustomText(
                                                            value[index]['charge'],
                                                            maxLines: 1,
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .blackColor
                                                                    .withValues(
                                                                      alpha:
                                                                          0.5,
                                                                    ),
                                                          ),
                                                        ],
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          // Remove charge
                                                          addAditionalCharges
                                                              .value = List.from(
                                                            addAditionalCharges
                                                                .value,
                                                          )..removeAt(index);
                                                        },
                                                        icon: Icon(
                                                          Icons.clear_rounded,
                                                          size: 20,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .blackColor
                                                                  .withValues(
                                                                    alpha: 0.4,
                                                                  ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ), // Space between items
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15), // Space before bottom buttons
            CloseAndConfirmButton(
              closeButtonPressed: () {
                Navigator.pop(context);
              },
              confirmButtonPressed: () {
                Navigator.pop(context, addAditionalCharges.value);
              },
              confirmButtonName: 'done'.translate(context: context),
            ),
          ],
        ),
      ),
    );
  }
}
