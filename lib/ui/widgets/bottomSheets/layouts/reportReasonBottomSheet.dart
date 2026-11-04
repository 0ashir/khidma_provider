import 'package:edemand_partner/cubits/chat/reportReasonCubit.dart';
import 'package:edemand_partner/cubits/chat/submitBlockReportCubit.dart';
import 'package:edemand_partner/data/model/chat/reportReasonModel.dart';
import 'package:flutter/material.dart';

import '../../../../app/generalImports.dart';

enum ReportMessageType { success, error, loading }

class ReportReasonBottomSheet extends StatefulWidget {
  final String userId;
  final bool isBlocked;
  final Function(bool) onBlockStatusChanged;

  const ReportReasonBottomSheet({
    super.key,
    required this.userId,
    required this.isBlocked,
    required this.onBlockStatusChanged,
  });

  @override
  State<ReportReasonBottomSheet> createState() =>
      _ReportReasonBottomSheetState();
}

class _ReportReasonBottomSheetState extends State<ReportReasonBottomSheet> {
  String? selectedReasonId;
  final TextEditingController additionalInfoController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    additionalInfoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<GetReportReasonsCubit>().getReportReasons();
  }

  Widget _buildReasonItem({
    required BuildContext context,
    required ReportReasonModel reason,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        CustomInkWellContainer(
          onTap: onTap,
          child: CustomContainer(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    reason.translatedReason?.translate(context: context) ?? '',
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: Theme.of(context).colorScheme.blackColor,
                    fontSize: 14,
                    maxLines: 1,
                  ),
                ),
                CustomContainer(
                  height: 25,
                  width: 25,
                  child: CustomRadioButton(
                    onChanged: (value) {
                      onTap();
                    },
                    value: isSelected,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isSelected && reason.needsAdditionalInfo == "1") ...[
          const SizedBox(height: 10),
          CustomTextFormField(
            controller: additionalInfoController,
            labelText: 'additionalInfo'.translate(context: context),
            hintText: 'enterAdditionalInfo'.translate(context: context),
            textInputType: TextInputType.multiline,
            expands: true,
            minLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'pleaseEnterAdditionalInfo'.translate(context: context);
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SubmitReportCubit, SubmitReportState>(
          listener: (context, state) {
            if (state is SubmitReportSuccess) {
              widget.onBlockStatusChanged(true);
              Navigator.pop(context);
              UiUtils.showMessage(
                context,
                state.message,
                ToastificationType.success,
              );
            } else if (state is SubmitReportFailure) {
              UiUtils.showMessage(
                context,
                state.errorMessage,
                ToastificationType.error,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<GetReportReasonsCubit, GetReportReasonsState>(
        builder: (context, state) {
          if (state is GetReportReasonsInProgress) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state is GetReportReasonsFailure) {
            return BottomSheetLayout(
              title: 'reportUser'.translate(context: context),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ErrorContainer(
                    errorMessage: state.errorMessage,
                    onTapRetry: () {
                      context.read<GetReportReasonsCubit>().getReportReasons();
                    },
                  ),
                ),
              ),
            );
          } else if (state is GetReportReasonsSuccess) {
            if (state.reportReasons.isEmpty) {
              // Directly submit report with empty values when list is empty
              context.read<SubmitReportCubit>().submitReport(
                userId: widget.userId,
                reasonId: '',
                additionalInfo: '',
              );
              return const SizedBox.shrink();
            }
            return BottomSheetLayout(
              title: 'reportUser'.translate(context: context),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.reportReasons.length,
                          itemBuilder: (context, index) {
                            final reason = state.reportReasons[index];
                            return _buildReasonItem(
                              context: context,
                              reason: reason,
                              isSelected: selectedReasonId == reason.id,
                              onTap: () {
                                setState(() {
                                  selectedReasonId = reason.id;
                                  if (reason.needsAdditionalInfo != "1") {
                                    additionalInfoController.clear();
                                  }
                                });
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomRoundedButton(
                          buttonTitle: 'submit'.translate(context: context),
                          widthPercentage: 1,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.accentColor,
                          showBorder: false,
                          titleColor: AppColors.whiteColors,
                          onTap: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              if (selectedReasonId == null) {
                                UiUtils.showMessage(
                                  context,
                                  "pleaseSelectReason",
                                  ToastificationType.error,
                                );
                                return;
                              }
                              context.read<SubmitReportCubit>().submitReport(
                                userId: widget.userId,
                                reasonId: selectedReasonId!,
                                additionalInfo: additionalInfoController.text,
                              );
                            }
                          },
                          child: state is SubmitReportInProgress
                              ? CustomCircularProgressIndicator(
                                  color: AppColors.whiteColors,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
