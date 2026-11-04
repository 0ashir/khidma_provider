import 'package:edemand_partner/data/model/chat/reportReasonModel.dart';
import '../../../../app/generalImports.dart';

class CancelReasonBottomSheet extends StatefulWidget {
  const CancelReasonBottomSheet({super.key});

  @override
  State<CancelReasonBottomSheet> createState() =>
      _CancelReasonBottomSheetState();
}

class _CancelReasonBottomSheetState extends State<CancelReasonBottomSheet> {
  String? selectedReasonId;
  ReportReasonModel? selectedReason;
  final TextEditingController _additionalInfoController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<GetCancellationReasonsCubit>().getCancellationReasons();
  }

  @override
  void dispose() {
    _additionalInfoController.dispose();
    super.dispose();
  }

  void _onConfirm(BuildContext context) {
    if (selectedReasonId == null) {
      UiUtils.showMessage(
        context,
        'pleaseSelectReason'.translate(context: context),
        ToastificationType.error,
      );
      return;
    }
    if (!(_formKey.currentState?.validate() ?? true)) return;

    Navigator.of(context).pop({
      'reasonId': selectedReasonId ?? '',
      'additionalInfo': selectedReason?.needsAdditionalInfo == '1'
          ? _additionalInfoController.text.trim()
          : null,
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetLayout(
      title: 'selectCancellationReason'.translate(context: context),
      child:
          BlocBuilder<GetCancellationReasonsCubit, GetCancellationReasonsState>(
            builder: (context, state) {
              if (state is GetCancellationReasonsInProgress) {
                return const SizedBox(
                  height: 160,
                  child: Center(child: CustomCircularProgressIndicator()),
                );
              }
              if (state is GetCancellationReasonsFailure) {
                return SizedBox(
                  height: 160,
                  child: Center(
                    child: ErrorContainer(
                      errorMessage: state.errorMessage,
                      onTapRetry: () => context
                          .read<GetCancellationReasonsCubit>()
                          .getCancellationReasons(),
                    ),
                  ),
                );
              }
              if (state is GetCancellationReasonsSuccess) {
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    12,
                    8,
                    12,
                    MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildReasonList(context, state.reasons),
                        _buildFooter(context),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
    );
  }

  Widget _buildReasonList(
    BuildContext context,
    List<ReportReasonModel> reasons,
  ) {
    if (reasons.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: CustomText(
            'noDataFound'.translate(context: context),
            color: context.colorScheme.lightGreyColor,
            fontSize: 14,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final reason in reasons) _buildReasonButton(context, reason),
        if (selectedReason?.needsAdditionalInfo == '1') ...[
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      '${'additionalInfo'.translate(context: context)} ${selectedReason?.reason}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: context.colorScheme.blackColor,
                  ),
                ),
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.redColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          CustomTextFormField(
            controller: _additionalInfoController,
            hintText: 'enterAdditionalInfo'.translate(context: context),
            textInputType: TextInputType.multiline,
            minLines: 3,
            expands: false,
            showFullBorder: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'pleaseEnterAdditionalInfo'.translate(context: context);
              }
              return null;
            },
          ),
        ],
      ],
    );
  }

  Widget _buildReasonButton(BuildContext context, ReportReasonModel reason) {
    final bool isSelected = selectedReasonId == reason.id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CustomInkWellContainer(
        borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf8),
        onTap: () {
          setState(() {
            selectedReasonId = reason.id;
            selectedReason = reason;
            if (reason.needsAdditionalInfo != '1') {
              _additionalInfoController.clear();
            }
          });
        },
        child: CustomContainer(
          width: double.infinity,
          borderRadius: UiUtils.borderRadiusOf8,
          color: isSelected
              ? context.colorScheme.accentColor
              : context.colorScheme.secondaryColor,
          border: Border.all(
            color: isSelected
                ? context.colorScheme.accentColor
                : context.colorScheme.lightGreyColor,
            width: 0.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: CustomText(
            reason.translatedReason?.translate(context: context) ??
                reason.reason ??
                '',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: isSelected
                ? AppColors.whiteColors
                : context.colorScheme.blackColor,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Row(
        children: [
          Expanded(
            child: CustomRoundedButton(
              buttonTitle: 'cancel'.translate(context: context),
              textSize: 16,
              widthPercentage: 1,
              backgroundColor: context.colorScheme.secondaryColor,
              showBorder: true,
              borderColor: context.colorScheme.accentColor,
              titleColor: context.colorScheme.accentColor,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomRoundedButton(
              buttonTitle: 'confirm'.translate(context: context),
              textSize: 16,
              widthPercentage: 1,
              backgroundColor: context.colorScheme.accentColor,
              showBorder: false,
              titleColor: AppColors.whiteColors,
              onTap: () => _onConfirm(context),
            ),
          ),
        ],
      ),
    );
  }
}
