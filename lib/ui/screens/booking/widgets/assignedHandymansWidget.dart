import 'package:edemand_partner/ui/widgets/customWarningBottomSheet.dart';
import 'package:flutter/material.dart';
import '../../../../app/generalImports.dart';

class AssignedHandymansWidget extends StatelessWidget {
  const AssignedHandymansWidget({super.key, required this.bookingsModel});

  final BookingsModel bookingsModel;

  bool get _canAssign {
    final bool statusAllowed = const [
      'confirmed',
      'started',
      'rescheduled',
    ].contains(bookingsModel.status);

    if (!statusAllowed) return false;

    final List<AssignedHandymanModel> assignedHandymen =
        bookingsModel.assignedHandymen ?? [];
    final List<AssignedHandymanModel> assignableHandymen =
        bookingsModel.assignableHandymen ?? [];

    if (assignableHandymen.isEmpty) return false;

    final Set<String> assignedIds = assignedHandymen.map((h) => h.id).toSet();
    final bool hasUnassignedHandyman = assignableHandymen.any(
      (h) => !assignedIds.contains(h.id),
    );

    return hasUnassignedHandyman;
  }

  bool get _canUnassign =>
      const ['confirmed', 'rescheduled'].contains(bookingsModel.status);

  bool get _canSetLead => !const [
    'on_the_way',
    'arrived',
    'started',
    'completed',
    'cancelled',
  ].contains(bookingsModel.status);

  @override
  Widget build(BuildContext context) {
    final List<AssignedHandymanModel> assignedHandymen =
        bookingsModel.assignedHandymen ?? [];
    final List<AssignedHandymanModel> assignableHandymen =
        bookingsModel.assignableHandymen ?? [];

    return CustomContainer(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(15),
      color: Theme.of(context).colorScheme.secondaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'assignedHandymen'.translate(context: context),
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: context.colorScheme.blackColor,
          ),
          const SizedBox(height: 10),
          if (assignedHandymen.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CustomText(
                'noHandymenAssigned'.translate(context: context),
                color: context.colorScheme.lightGreyColor,
                fontSize: 14,
              ),
            )
          else
            ...assignedHandymen.map(
              (h) => _HandymanRow(
                handyman: h,
                bookingId: bookingsModel.id ?? '',
                canUnassign: _canUnassign,
                canSetLead: _canSetLead,
              ),
            ),
          if (_canAssign) ...[
            const SizedBox(height: 12),
            CustomRoundedButton(
              showBorder: true,
              borderColor: Theme.of(context).colorScheme.accentColor,
              backgroundColor: Theme.of(context).colorScheme.secondaryColor,
              buttonTitle: '+ ${'assignHandyman'.translate(context: context)}',
              titleColor: Theme.of(context).colorScheme.accentColor,
              widthPercentage: 1,
              height: 44,
              textSize: 14,
              onTap: () {
                UiUtils.showModelBottomSheets(
                  context: context,
                  child: AssignHandymanBottomSheet(
                    orderId: bookingsModel.id ?? '',
                    assignableHandymen: assignableHandymen,
                    alreadyAssignedIds: assignedHandymen
                        .map((h) => h.id)
                        .toList(),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _HandymanRow extends StatelessWidget {
  const _HandymanRow({
    required this.handyman,
    required this.bookingId,
    required this.canUnassign,
    required this.canSetLead,
  });

  final AssignedHandymanModel handyman;
  final String bookingId;
  final bool canUnassign;
  final bool canSetLead;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnassignHandymanCubit, UnassignHandymanState>(
      builder: (context, unassignState) {
        final bool isUnassigning =
            unassignState is UnassignHandymanInProgress &&
            unassignState.handymanId == handyman.id;

        return BlocBuilder<SetLeadHandymanCubit, SetLeadHandymanState>(
          builder: (context, leadState) {
            final bool isSettingLead = leadState is SetLeadHandymanInProgress;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(context).colorScheme.accentColor,
                    child: CustomText(
                      handyman.username.isNotEmpty
                          ? handyman.username[0].toUpperCase()
                          : '?',
                      color: AppColors.whiteColors,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          handyman.username,
                          color: context.colorScheme.blackColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        if (handyman.isLead)
                          CustomContainer(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            color: Theme.of(
                              context,
                            ).colorScheme.accentColor.withValues(alpha: 0.15),
                            borderRadius: UiUtils.borderRadiusOf5,
                            child: CustomText(
                              'lead'.translate(context: context),
                              color: Theme.of(context).colorScheme.accentColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (canSetLead && !handyman.isLead) ...[
                    CustomInkWellContainer(
                      onTap: isSettingLead
                          ? null
                          : () {
                              context.read<SetLeadHandymanCubit>().setLead(
                                orderId: bookingId,
                                handymanId: handyman.id,
                              );
                            },
                      child: isSettingLead
                          ? const ShimmerLoadingContainer(
                              child: CustomShimmerContainer(
                                height: 16,
                                width: 80,
                                borderRadius: 4,
                              ),
                            )
                          : CustomContainer(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              color: Theme.of(
                                context,
                              ).colorScheme.accentColor.withValues(alpha: 0.15),
                              borderRadius: UiUtils.borderRadiusOf5,
                              child: CustomText(
                                'setAsLead'.translate(context: context),
                                color: Theme.of(
                                  context,
                                ).colorScheme.accentColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (canUnassign)
                    isUnassigning
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: Padding(
                              padding: EdgeInsets.all(2),
                              child: CustomCircularProgressIndicator(),
                            ),
                          )
                        : CustomInkWellContainer(
                            onTap: () {
                              UiUtils.showModelBottomSheets(
                                context: context,
                                child: CustomWarningBottomSheet(
                                  conformText: 'continue'.translate(
                                    context: context,
                                  ),
                                  onTapConformText: () {
                                    Navigator.pop(context);
                                    context
                                        .read<UnassignHandymanCubit>()
                                        .unassign(
                                          orderId: bookingId,
                                          handymanId: handyman.id,
                                        );
                                  },
                                  closeText: 'notYet'.translate(
                                    context: context,
                                  ),
                                  onTapCloseText: () => Navigator.pop(context),
                                  detailsWarningMessage:
                                      'unassignHandymanWarning'.translate(
                                        context: context,
                                      ),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              child: CustomSvgPicture(
                                svgImage: AppAssets.drDeleteAccount,
                                height: 20,
                              ),
                            ),
                          ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
