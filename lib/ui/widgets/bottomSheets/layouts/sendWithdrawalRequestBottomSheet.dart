import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';

class SendWithdrawalRequestBottomsheet extends StatefulWidget {
  const SendWithdrawalRequestBottomsheet({super.key});

  @override
  SendWithdrawalRequestScreenState createState() =>
      SendWithdrawalRequestScreenState();
}

class SendWithdrawalRequestScreenState
    extends State<SendWithdrawalRequestBottomsheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController amountController = TextEditingController();

  FocusNode amountFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    amountFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: BottomSheetLayout(
        title: "sendWithdrawalRequest",
        child: withdrawAmountForm(context),
      ),
    );
  }

  Widget withdrawAmountForm(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomContainer(
              color: Theme.of(context).colorScheme.primaryColor,
              padding: const EdgeInsetsDirectional.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<GetCustomFieldsCubit, GetCustomFieldsState>(
                    builder: (context, state) {
                      if (state is GetCustomFieldsInProgress ||
                          state is GetCustomFieldsInitial) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: CustomCircularProgressIndicator(),
                          ),
                        );
                      }

                      if (state is GetCustomFieldsFail) {
                        return ErrorContainer(
                          errorMessage: state.error,
                          showErrorImage: false,
                          errorMessageFontSize: 12,
                          onTapRetry: () {
                            context
                                .read<GetCustomFieldsCubit>()
                                .fetchCustomFields();
                          },
                        );
                      }

                      if (state is GetCustomFieldsSuccess) {
                        final bankFields = state.fields
                            .where((f) => f.fieldGroup == 'bank_details')
                            .toList();

                        final nonEmptyEntries =
                            <MapEntry<CustomFieldModel, dynamic>>[];
                        for (final field in bankFields) {
                          final value = state.savedValues[field.id.toString()];
                          if (value != null &&
                              value.toString().trim().isNotEmpty) {
                            nonEmptyEntries.add(MapEntry(field, value));
                          }
                        }

                        if (nonEmptyEntries.isEmpty) {
                          return CustomContainer(
                            padding: const EdgeInsets.all(15),
                            color: Theme.of(context).colorScheme.secondaryColor,
                            borderRadius: UiUtils.borderRadiusOf8,
                            child: CustomText(
                              'noBankDetailsAvailable'.translate(
                                context: context,
                              ),
                              color: Theme.of(
                                context,
                              ).colorScheme.lightGreyColor,
                            ),
                          );
                        }

                        return CustomContainer(
                          padding: const EdgeInsets.all(15),
                          border: Border.all(
                            color: context.colorScheme.blackColor.withAlpha(50),
                          ),
                          color: Theme.of(context).colorScheme.secondaryColor,
                          width: double.maxFinite,
                          borderRadius: UiUtils.borderRadiusOf8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                'bankDetailsLbl'.translate(context: context),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.blackColor,
                              ),
                              const SizedBox(height: 12),
                              for (
                                var i = 0;
                                i < nonEmptyEntries.length;
                                i += 2
                              )
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: _buildBankDetailItem(
                                          context,
                                          nonEmptyEntries[i].key.name,
                                          nonEmptyEntries[i].value.toString(),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      if (i + 1 < nonEmptyEntries.length)
                                        Expanded(
                                          child: _buildBankDetailItem(
                                            context,
                                            nonEmptyEntries[i + 1].key.name,
                                            nonEmptyEntries[i + 1].value
                                                .toString(),
                                          ),
                                        )
                                      else
                                        const Expanded(child: SizedBox()),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    labelText: 'amountLbl'.translate(context: context),
                    controller: amountController,
                    currentFocusNode: amountFocus,
                    fillColor: Theme.of(context).colorScheme.secondaryColor,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                    ],
                    validator: (String? val) {
                      if (val != '') {
                        if (double.parse(val!) <= 0) {
                          return 'amountShouldBeGreaterThanZero'.translate(
                            context: context,
                          );
                        } else if (double.parse(val) >
                            double.parse(
                              (context.read<FetchSystemSettingsCubit>().state
                                      as FetchSystemSettingsSuccess)
                                  .availableAmount,
                            )) {
                          return 'bigAmount'.translate(context: context);
                        }
                      }

                      return Validator.nullCheck(context, val);
                    },
                    textInputType: TextInputType.number,
                  ),
                ],
              ),
            ),
            resetAndSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget resetAndSubmitButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        top: 10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: resetBtn(context)),
          const SizedBox(width: 10),
          Expanded(child: submitBtn(context)),
        ],
      ),
    );
  }

  Widget submitBtn(BuildContext context) {
    return BlocConsumer<SendWithdrawalRequestCubit, SendWithdrawalRequestState>(
      listener: (BuildContext context, SendWithdrawalRequestState state) {
        if (state is SendWithdrawalRequestSuccess) {
          //update amount globally
          context.read<FetchSystemSettingsCubit>().updateAmount(state.balance);

          UiUtils.showMessage(
            context,
            state.message.isNotEmpty ? state.message : 'success',
            ToastificationType.success,
            onMessageClosed: () {},
          );

          // little bit delay because bottom sheet is closing very fast
          Future.delayed(
            const Duration(milliseconds: 500),
          ).then((value) => Navigator.pop(context, true));
        }

        if (state is SendWithdrawalRequestFailure) {
          UiUtils.showMessage(context, 'failed', ToastificationType.error);
        }
      },
      builder: (BuildContext context, SendWithdrawalRequestState state) {
        Widget? child;

        if (state is SendWithdrawalRequestInProgress) {
          child = CustomCircularProgressIndicator(color: AppColors.whiteColors);
        }

        return CustomInkWellContainer(
          onTap: () {
            UiUtils.removeFocus();
            onSubmitClick(context);
          },
          child: CustomContainer(
            height: 44,
            boxShadow: const [
              BoxShadow(
                color: Color(0x1c343f53),
                offset: Offset(0, -3),
                blurRadius: 10,
              ),
            ],
            color: Theme.of(context).colorScheme.accentColor,
            child: Center(
              child:
                  child ??
                  Text(
                    'submitBtnLbl'.translate(context: context),
                    style: TextStyle(
                      color: AppColors.whiteColors,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0,
                    ),
                  ),
            ),
          ),
        );
      },
    );
  }

  Widget resetBtn(BuildContext context) {
    return CustomInkWellContainer(
      onTap: () {
        amountController.text = '';
        FocusScope.of(context).requestFocus(amountFocus);
        setState(() {});
      },
      child: CustomContainer(
        height: 44,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1c343f53),
            offset: Offset(0, -3),
            blurRadius: 10,
          ),
        ],
        color: Theme.of(context).colorScheme.secondaryColor,
        child: Center(
          child: Text(
            'resetBtnLbl'.translate(context: context),
            style: TextStyle(
              color: Theme.of(context).colorScheme.blackColor,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBankDetailItem(
    BuildContext context,
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title,
          fontSize: 12,
          maxLines: 1,
          color: Theme.of(context).colorScheme.lightGreyColor,
        ),
        const SizedBox(height: 4),
        CustomText(
          value,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          maxLines: 2,
          color: Theme.of(context).colorScheme.blackColor,
        ),
      ],
    );
  }

  Future<void> onSubmitClick(BuildContext context) async {
    final state = context.read<GetCustomFieldsCubit>().state;

    if (state is GetCustomFieldsSuccess) {
      final bankFields = state.fields
          .where((f) => f.fieldGroup == 'bank_details')
          .toList();
      final hasAnyBankDetail = bankFields.any((f) {
        final value = state.savedValues[f.id.toString()];
        return value != null && value.toString().trim().isNotEmpty;
      });

      if (!hasAnyBankDetail) {
        UiUtils.showMessage(
          context,
          'addBankDetailsToWithdraw'.translate(context: context),
          ToastificationType.error,
        );
        return;
      }
    } else {
      UiUtils.showMessage(
        context,
        'noBankDetailsAvailable'.translate(context: context),
        ToastificationType.error,
      );
      return;
    }

    final FormState? form = formKey.currentState;
    if (form == null) return;
    form.save();
    if (form.validate()) {
      context.read<SendWithdrawalRequestCubit>().sendWithdrawalRequest(
        amount: amountController.text,
      );
    }
  }
}
