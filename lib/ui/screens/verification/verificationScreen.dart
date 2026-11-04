import 'package:flutter/material.dart';

import '../../../app/generalImports.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();

  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(builder: (_) => const VerificationScreen());
  }
}

class _VerificationScreenState extends State<VerificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<CustomFieldsFormState> _customFieldsKey =
      GlobalKey<CustomFieldsFormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetVerificationStatusCubit>().fetch();
    });
  }

  void _onSubmit(VerificationStatusModel status) {
    UiUtils.removeFocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final values = _customFieldsKey.currentState?.getKeyValueMap() ?? {};
    // Tells the backend this is a resubmission (vs. a first-time submit) so
    // it keeps the existing file for any file field the user left untouched.
    values['is_resubmit'] =
        status.status == VerificationRequestStatus.disapproved ? 1 : 0;
    context.read<SubmitVerificationRequestCubit>().submit(values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: UiUtils.getSimpleAppBar(
        context: context,
        title: 'providerVerificationLbl'.translate(context: context),
        statusBarColor: context.colorScheme.secondaryColor,
        elevation: 1,
      ),
      body:
          BlocListener<
            SubmitVerificationRequestCubit,
            SubmitVerificationRequestState
          >(
            listener: (context, state) {
              if (state is SubmitVerificationRequestSuccess) {
                UiUtils.showMessage(
                  context,
                  state.message,
                  ToastificationType.success,
                );
                context.read<GetVerificationStatusCubit>().fetch();
              }
              if (state is SubmitVerificationRequestFail) {
                UiUtils.showMessage(
                  context,
                  state.error,
                  ToastificationType.error,
                );
              }
            },
            child:
                BlocBuilder<
                  GetVerificationStatusCubit,
                  GetVerificationStatusState
                >(
                  builder: (context, state) {
                    if (state is GetVerificationStatusInProgress ||
                        state is GetVerificationStatusInitial) {
                      return _buildShimmer();
                    }
                    if (state is GetVerificationStatusFail) {
                      return _buildError(state.error);
                    }
                    final status =
                        (state as GetVerificationStatusSuccess).status;
                    return _buildContent(status);
                  },
                ),
          ),
    );
  }

  Widget _buildShimmer() {
    return const ShimmerLoadingContainer(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            CustomShimmerContainer(
              height: 80,
              margin: EdgeInsets.only(bottom: 15),
            ),
            CustomShimmerContainer(
              height: 60,
              margin: EdgeInsets.only(bottom: 15),
            ),
            CustomShimmerContainer(
              height: 60,
              margin: EdgeInsets.only(bottom: 15),
            ),
            CustomShimmerContainer(
              height: 60,
              margin: EdgeInsets.only(bottom: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(error, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            CustomRoundedButton(
              widthPercentage: 0.5,
              height: 44,
              titleColor: AppColors.whiteColors,
              backgroundColor: context.colorScheme.accentColor,
              buttonTitle: 'retry'.translate(context: context),
              onTap: () => context.read<GetVerificationStatusCubit>().fetch(),
              showBorder: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(VerificationStatusModel status) {
    final bool inProgress =
        context.watch<SubmitVerificationRequestCubit>().state
            is SubmitVerificationRequestInProgress;

    // Show submitted details in read-only mode for pending / approved states.
    final bool showSubmittedReadOnly =
        (status.status == VerificationRequestStatus.pending ||
            status.status == VerificationRequestStatus.approved) &&
        status.submittedFields.isNotEmpty;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            15,
            15,
            15,
            15 + (status.canSubmit ? UiUtils.bottomButtonSpacing : 0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusCard(status),

              // ── Read-only submitted details (pending / approved) ────────────
              if (showSubmittedReadOnly) ...[
                const SizedBox(height: 16),
                _buildSectionHeader(
                  icon: Icons.assignment_outlined,
                  label: 'submittedDetailsLbl'.translate(context: context),
                ),
                const SizedBox(height: 10),
                CustomFieldsForm(
                  fields: status.submittedFields,
                  initialValues: status.submittedValues,
                  readOnly: true,
                ),
              ],

              // ── Editable form (canSubmit) ──────────────────────────────────
              if (status.canSubmit) ...[
                const SizedBox(height: 12),
                Form(
                  key: _formKey,
                  child: CustomFieldsForm(
                    key: _customFieldsKey,
                    fields: status.fields,
                    initialValues: status.submittedValues,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (status.canSubmit)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 5,
                left: 15,
                right: 15,
              ),
              child: CustomRoundedButton(
                widthPercentage: 1,
                textSize: 14,
                height: 55,
                titleColor: AppColors.whiteColors,
                onTap: inProgress ? () {} : () => _onSubmit(status),
                backgroundColor: context.colorScheme.accentColor,
                buttonTitle: 'submitBtnLbl'.translate(context: context),
                showBorder: true,
                child: inProgress
                    ? CustomCircularProgressIndicator(
                        color: AppColors.whiteColors,
                      )
                    : null,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: context.colorScheme.blackColor.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 6),
        CustomText(
          label,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: context.colorScheme.blackColor.withValues(alpha: 0.5),
        ),
      ],
    );
  }

  Widget _buildStatusCard(VerificationStatusModel status) {
    switch (status.status) {
      case VerificationRequestStatus.approved:
        return _statusCard(
          icon: Icons.verified_rounded,
          color: Colors.green,
          title: 'verifiedLbl'.translate(context: context),
          message: 'providerVerifiedMessage'.translate(context: context),
        );
      case VerificationRequestStatus.pending:
        return _statusCard(
          icon: Icons.hourglass_top_rounded,
          color: Colors.orange,
          title: 'verificationPendingLbl'.translate(context: context),
          message: 'providerVerificationPendingMessage'.translate(
            context: context,
          ),
        );
      case VerificationRequestStatus.disapproved:
        return _statusCard(
          icon: Icons.cancel_outlined,
          color: Colors.red,
          title: 'verificationRejectedLbl'.translate(context: context),
          message: status.rejectionReason?.trim().isNotEmpty == true
              ? status.rejectionReason!.trim()
              : 'providerVerificationRejectedMessage'.translate(
                  context: context,
                ),
        );
      case VerificationRequestStatus.none:
        return _statusCard(
          icon: Icons.info_outline_rounded,
          color: context.colorScheme.accentColor,
          title: 'completeVerificationLbl'.translate(context: context),
          message: 'providerVerificationInfoMessage'.translate(
            context: context,
          ),
        );
    }
  }

  Widget _statusCard({
    required IconData icon,
    required Color color,
    required String title,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title,
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                const SizedBox(height: 3),
                CustomText(
                  message,
                  color: context.colorScheme.blackColor,
                  fontSize: 12.5,
                  maxLines: 6,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
