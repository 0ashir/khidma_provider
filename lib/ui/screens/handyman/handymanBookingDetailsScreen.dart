import 'package:flutter/material.dart';

import '../../../app/generalImports.dart';
import '../../../ui/widgets/bottomSheets/layouts/additionalChargesBottomSheet.dart';
import '../../../ui/widgets/dialog/layouts/verifyOTPDialog.dart';
import '../../../utils/checkURLType.dart';
import '../booking/widgets/expandableChargeRow.dart';
import '../booking/widgets/notesWidget.dart';
import '../booking/widgets/taxBreakdownRows.dart';

class HandymanBookingDetailsScreen extends StatefulWidget {
  const HandymanBookingDetailsScreen({super.key, required this.orderId});

  final String orderId;

  static Route route(RouteSettings settings) => CupertinoPageRoute(
    builder: (_) =>
        HandymanBookingDetailsScreen(orderId: settings.arguments as String),
  );

  @override
  State<HandymanBookingDetailsScreen> createState() =>
      _HandymanBookingDetailsScreenState();
}

class _HandymanBookingDetailsScreenState
    extends State<HandymanBookingDetailsScreen> {
  static const Map<String, String> _actionLabels = {
    'accepted': 'accept',
    'rejected': 'reject',
    'on_the_way': 'on_the_way',
    'arrived': 'arrived',
    'started': 'started',
    'booking_ended': 'booking_ended',
    'completed': 'complete',
  };

  ValueNotifier<bool> isBillDetailsCollapsed = ValueNotifier(true);
  ValueNotifier<bool> isAdditionalChargesCollapsed = ValueNotifier(true);
  List<Map<String, dynamic>>? additionalCharged;
  HandymanBookingDetail? _cachedDetail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HandymanBookingDetailCubit>().fetchBookingDetail(
        widget.orderId,
      );
    });
  }

  @override
  void dispose() {
    isBillDetailsCollapsed.dispose();
    isAdditionalChargesCollapsed.dispose();
    super.dispose();
  }

  Future<void> _startTracking(BuildContext context, String bookingId) async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      final requested = await Geolocator.requestPermission();
      if (requested == LocationPermission.denied ||
          requested == LocationPermission.deniedForever) {
        if (!context.mounted) return;
        UiUtils.showMessage(
          context,
          'locationPermissionRequired'.translate(context: context),
          ToastificationType.error,
        );
        return;
      }
    }
    if (!context.mounted) return;
    context.read<HandymanLiveTrackingCubit>().startTracking(
      bookingId: bookingId,
    );
  }

  Future<void> _handleStatusAction(
    BuildContext context,
    HandymanBookingDetail detail,
    String status,
  ) async {
    switch (status) {
      case 'accepted':
        _callUpdateStatus(context, status);
        break;

      case 'rejected':
        final reason = await _showInputDialog(
          context,
          title: 'rejectBooking'.translate(context: context),
          hint: 'enterRejectionReason'.translate(context: context),
        );
        if (reason == null || reason.trim().isEmpty) return;
        _callUpdateStatus(context, status, rejectedReason: reason.trim());
        break;

      case 'on_the_way':
        _callUpdateStatus(context, status);
        break;

      case 'arrived':
        final confirmed = await UiUtils.showAnimatedDialog(
          context: context,
          child: ConfirmationDialog(
            title: 'arrived',
            description: 'arrivedTrackingStopMessage',
            confirmButtonName: 'confirm',
            confirmButtonBackgroundColor: context.colorScheme.accentColor,
            confirmButtonPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        );
        if (confirmed != true) return;
        if (!context.mounted) return;
        context.read<HandymanLiveTrackingCubit>().stopTracking();
        _callUpdateStatus(context, status);
        break;

      case 'started':
        final proofResult = await UiUtils.showModelBottomSheets(
          context: context,
          child: const UploadProofBottomSheet(),
        );
        if (!context.mounted) return;
        final proofFiles = proofResult is List
            ? List<Map<String, dynamic>>.from(proofResult)
            : <Map<String, dynamic>>[];
        _callUpdateStatus(
          context,
          status,
          workProof: proofFiles.isEmpty ? null : proofFiles,
        );
        break;

      case 'booking_ended':
        final proofResult = await UiUtils.showModelBottomSheets(
          context: context,
          child: const UploadProofBottomSheet(),
        );
        if (!context.mounted) return;
        if (proofResult == null) return;
        final proofFiles = proofResult is List
            ? List<Map<String, dynamic>>.from(proofResult)
            : <Map<String, dynamic>>[];

        final chargesResult = await UiUtils.showModelBottomSheets(
          context: context,
          child: AdditionalChargesBottomSheet(
            additionalCharges: additionalCharged,
          ),
        );
        if (!context.mounted) return;
        if (chargesResult == null) return;
        additionalCharged = List<Map<String, dynamic>>.from(chargesResult);

        _callUpdateStatus(
          context,
          status,
          workProof: proofFiles.isEmpty ? null : proofFiles,
          additionalCharges: additionalCharged,
        );
        break;

      case 'completed':
        if (_isAdditionalChargesPaymentBlocked(detail)) {
          await _showPaymentNotSelectedDialog(context);
          return;
        }
        final bool isOtpEnabled = context
            .read<FetchSystemSettingsCubit>()
            .isOrderOTPConfirmationEnable;
        String? otp;
        if (isOtpEnabled) {
          final dialogResult = await UiUtils.showAnimatedDialog(
            context: context,
            child: VerifyOTPDialog(userId: detail.customerId),
          );
          if (!context.mounted) return;
          if (dialogResult == null) return;
          otp = dialogResult.toString();
          if (otp.trim().isEmpty) return;
        }

        if (detail.paymentMethod == 'cod') {
          if (!context.mounted) return;
          final cashDialogResult = await UiUtils.showAnimatedDialog(
            context: context,
            child: CustomDialogLayout(
              title: isOtpEnabled ? 'collectCashFromCustomer' : 'collectdCash',
              confirmButtonName: 'okay',
              cancelButtonName: 'cancel',
              confirmButtonBackgroundColor: context.colorScheme.accentColor,
              cancelButtonBackgroundColor: context.colorScheme.secondaryColor,
              showProgressIndicator: false,
              cancelButtonPressed: () => Navigator.pop(context, false),
              confirmButtonPressed: () => Navigator.pop(context, true),
            ),
          );
          if (!context.mounted) return;
          if (cashDialogResult != true) return;
        }

        _callUpdateStatus(context, status, otp: otp?.trim());
        break;

      default:
        _callUpdateStatus(context, status);
    }
  }

  bool _isAdditionalChargesPaymentBlocked(HandymanBookingDetail detail) {
    final double totalAdditional =
        double.tryParse(detail.totalAdditionalCharge.replaceAll(',', '')) ?? 0;
    if (totalAdditional <= 0) return false;

    final String method = detail.paymentMethodOfAdditionalCharge
        .trim()
        .toLowerCase();
    if (method.isEmpty) return true;
    if (method == 'cod') return false;

    final String status = detail.paymentStatusOfAdditionalCharge
        .trim()
        .toLowerCase();
    return status == '0' ||
        status == 'pending' ||
        status == '2' ||
        status == 'failed';
  }

  Future<void> _showPaymentNotSelectedDialog(BuildContext context) {
    return UiUtils.showAnimatedDialog(
      context: context,
      child: CustomDialogLayout(
        title: 'paymentNotSelectedTitle',
        description: 'paymentNotSelectedMessage',
        confirmButtonName: 'okay',
        cancelButtonName: 'cancel',
        confirmButtonBackgroundColor: context.colorScheme.accentColor,
        cancelButtonBackgroundColor: context.colorScheme.secondaryColor,
        showProgressIndicator: false,
        cancelButtonPressed: () => Navigator.pop(context),
        confirmButtonPressed: () => Navigator.pop(context),
      ),
    );
  }

  void _callUpdateStatus(
    BuildContext context,
    String status, {
    String? rejectedReason,
    String? otp,
    List<Map<String, dynamic>>? additionalCharges,
    List<Map<String, dynamic>>? workProof,
  }) {
    context.read<HandymanBookingStatusCubit>().updateStatus(
      bookingId: widget.orderId,
      status: status,
      rejectedReason: rejectedReason,
      otp: otp,
      additionalCharges: additionalCharges,
      workProof: workProof,
    );
  }

  Future<String?> _showInputDialog(
    BuildContext context, {
    required String title,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hint),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('cancel'.translate(context: ctx)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: Text(
              'confirm'.translate(context: ctx),
              style: TextStyle(
                color: ctx.colorScheme.accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // Date/time format comes from the country settings; rebuild when they load.
    context.watch<FetchCountrySettingsCubit>();
    return MultiBlocListener(
      listeners: [
        BlocListener<HandymanBookingStatusCubit, HandymanBookingStatusState>(
          listener: (context, state) {
            if (state is HandymanBookingStatusSuccess) {
              context.read<HandymanBookingDetailCubit>().fetchBookingDetail(
                widget.orderId,
              );

              context.read<HandymanBookingsCubit>().updateBookingLocally(
                bookingId: widget.orderId,
                newStatus: state.result.newStatus,
                orderStatus: state.result.newStatus,
                transalatedOrderStatus: state.result.newStatus.translate(
                  context: context,
                ),
              );

              UiUtils.showMessage(
                context,
                state.result.message,
                ToastificationType.success,
              );
            } else if (state is HandymanBookingStatusFailure) {
              UiUtils.showMessage(
                context,
                state.errorMessage.translate(context: context),
                ToastificationType.error,
              );
            }
          },
        ),
        BlocListener<HandymanLiveTrackingCubit, HandymanLiveTrackingState>(
          listener: (context, state) {
            if (state is HandymanLiveTrackingFailure) {
              UiUtils.showMessage(
                context,
                state.errorMessage.translate(context: context),
                ToastificationType.error,
              );
            }
          },
        ),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: UiUtils.getSystemUiOverlayStyle(context: context),
        child:
            BlocBuilder<HandymanBookingDetailCubit, HandymanBookingDetailState>(
              builder: (context, state) {
                if (state is HandymanBookingDetailSuccess) {
                  _cachedDetail = state.detail;
                }
                final HandymanBookingDetail? detail = _cachedDetail;

                final bool isUpdating =
                    context.watch<HandymanBookingStatusCubit>().state
                        is HandymanBookingStatusInProgress;

                return PopScope(
                  canPop: !isUpdating,
                  child: Scaffold(
                    backgroundColor: context.colorScheme.primaryColor,
                    appBar: UiUtils.getSimpleAppBar(
                      context: context,
                      isLeadingIconEnable: !isUpdating,
                      title: 'bookingInformation'.translate(context: context),
                    ),
                    body: _buildBody(state, detail),
                    bottomNavigationBar: detail != null
                        ? _buildBottomNavigationBar(detail)
                        : null,
                  ),
                );
              },
            ),
      ),
    );
  }

  Widget _buildBody(
    HandymanBookingDetailState state,
    HandymanBookingDetail? cachedDetail,
  ) {
    if (cachedDetail != null) {
      return _buildContent(cachedDetail);
    }

    if (state is HandymanBookingDetailFailure) {
      return Center(
        child: ErrorContainer(
          errorMessage: state.errorMessage.translate(context: context),
          onTapRetry: () {
            context.read<HandymanBookingDetailCubit>().fetchBookingDetail(
              widget.orderId,
            );
          },
        ),
      );
    }

    return _buildShimmer();
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      itemCount: 5,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: ShimmerLoadingContainer(
          child: CustomShimmerContainer(height: 100),
        ),
      ),
    );
  }

  Widget _buildContent(HandymanBookingDetail detail) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomerWidget(detail),
          const SizedBox(height: 10),
          _buildStatusWidget(detail),
          const SizedBox(height: 10),
          if (detail.isLead && detail.handymanStatus == 'on_the_way') ...[
            _buildTrackingSection(detail),
            const SizedBox(height: 10),
          ],
          _buildDateAndTimeWidget(detail),
          if (detail.services.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildServiceDetailsWidget(detail),
          ],
          _buildAssignedHandymenWidget(detail),
          _buildUploadedProofWidget(
            'workStartedProof',
            detail.workStartedProof,
          ),
          _buildUploadedProofWidget(
            'workCompletedProof',
            detail.workCompletedProof,
          ),
          NotesWidget(remarks: detail.remarks),
          _buildPriceSectionWidget(detail),
          if (detail.isPaymentPending) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _warningBanner(
                'paymentPendingMessage'.translate(context: context),
                color: Colors.orange,
              ),
            ),
          ] else if (!detail.isLead &&
              detail.orderStatus.toLowerCase() != "completed") ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _warningBanner(
                'onlyLeadHandymanCanUpdate'.translate(context: context),
                color: context.colorScheme.accentColor,
                icon: Icons.info_outline,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomerWidget(HandymanBookingDetail detail) {
    final bool phoneAndChatStatusActive =
        detail.orderStatus == "cancelled" || detail.orderStatus == "completed"
        ? false
        : true;

    final state = context.watch<FetchSystemSettingsCubit>().state;
    final bool systemWisePostbooking = (state is FetchSystemSettingsSuccess)
        ? state.chatSettings.isPostBookingChatAllowed
        : false;

    final bool systemWisePrebooking = (state is FetchSystemSettingsSuccess)
        ? state.chatSettings.isPreBookingChatAllowed
        : false;

    final bool shouldShowChat =
        detail.isLead && (systemWisePrebooking || systemWisePostbooking);

    return CustomContainer(
      borderRadius: 0,
      color: Theme.of(context).colorScheme.secondaryColor,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: CustomText(
              'customer'.translate(context: context),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.lightGreyColor,
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomContainer(
                      height: 50,
                      width: 50,
                      shape: BoxShape.circle,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          UiUtils.borderRadiusOf50,
                        ),
                        child: detail.profileImage.isNotEmpty
                            ? CustomCachedNetworkImage(
                                imageUrl: detail.profileImage,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.person,
                                color: context.colorScheme.accentColor,
                                size: 22,
                              ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            detail.customer,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.blackColor,
                          ),
                          if (detail.customerNo.isNotEmpty)
                            CustomInkWellContainer(
                              onTap: () {
                                try {
                                  launchUrl(
                                    Uri.parse("tel:${detail.customerNo}"),
                                  );
                                } catch (e) {
                                  UiUtils.showMessage(
                                    context,
                                    "somethingWentWrongTitle",
                                    ToastificationType.error,
                                  );
                                }
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomText(
                                      detail.customerNo,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: context.colorScheme.lightGreyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (detail.customerNo.isNotEmpty) ...[
                      const SizedBox(width: 15),
                      CustomInkWellContainer(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          if (!phoneAndChatStatusActive) {
                            return;
                          } else {
                            try {
                              launchUrl(Uri.parse("tel:${detail.customerNo}"));
                            } catch (e) {
                              UiUtils.showMessage(
                                context,
                                'somethingWentWrongTitle',
                                ToastificationType.error,
                              );
                            }
                          }
                        },
                        child: CustomContainer(
                          height: 40,
                          width: 40,
                          borderRadius: UiUtils.borderRadiusOf5,
                          padding: const EdgeInsets.all(10),
                          color: !phoneAndChatStatusActive
                              ? Theme.of(context).colorScheme.lightGreyColor
                                    .withValues(alpha: 0.1)
                              : Theme.of(context).colorScheme.accentColor
                                    .withValues(alpha: 0.1),
                          child: CustomSvgPicture(
                            svgImage: AppAssets.call,
                            color: !phoneAndChatStatusActive
                                ? Theme.of(context).colorScheme.lightGreyColor
                                : Theme.of(context).colorScheme.accentColor,
                          ),
                        ),
                      ),
                    ],
                    if (shouldShowChat) ...[
                      const SizedBox(width: 10),
                      CustomInkWellContainer(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          if (!phoneAndChatStatusActive) {
                            return;
                          } else {
                            Navigator.pushNamed(
                              context,
                              Routes.chatMessages,
                              arguments: {
                                "chatUser": ChatUser(
                                  customerId: detail.customerId,
                                  bookingId: detail.id,
                                  bookingStatus: detail.orderStatus,
                                  bookingTranslatedStatus: detail.orderStatus
                                      .capitalize(),
                                  customerName: detail.customer,
                                  chatUserType: ChatUserType.providerBooking,
                                  unReadChats: 0,
                                  image: detail.profileImage,
                                ),
                              },
                            );
                          }
                        },
                        child: CustomContainer(
                          height: 40,
                          width: 40,
                          borderRadius: UiUtils.borderRadiusOf5,
                          padding: const EdgeInsets.all(10),
                          color: !phoneAndChatStatusActive
                              ? Theme.of(context).colorScheme.lightGreyColor
                                    .withValues(alpha: 0.1)
                              : Theme.of(context).colorScheme.accentColor
                                    .withValues(alpha: 0.1),
                          child: CustomSvgPicture(
                            svgImage: AppAssets.drChat,
                            color: !phoneAndChatStatusActive
                                ? Theme.of(context).colorScheme.lightGreyColor
                                : Theme.of(context).colorScheme.accentColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (detail.customerEmail.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  CustomInkWellContainer(
                    onTap: () {
                      try {
                        launchUrl(Uri.parse("mailto:${detail.customerEmail}"));
                      } catch (e) {
                        UiUtils.showMessage(
                          context,
                          "somethingWentWrongTitle",
                          ToastificationType.error,
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomSvgPicture(
                              svgImage: AppAssets.letter,
                              color: context.colorScheme.accentColor,
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(width: 5),
                            CustomText(
                              detail.customerEmail,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        CustomSvgPicture(
                          svgImage: AppAssets.arrowNext,
                          color: context.colorScheme.accentColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildStatusWidget(HandymanBookingDetail detail) {
    final statusColor = UiUtils.getStatusColor(
      context: context,
      statusVal: detail.orderStatus.toLowerCase(),
    );
    return CustomContainer(
      border: Border(
        bottom: BorderSide(color: statusColor, width: 0.5),
        top: BorderSide(color: statusColor, width: 0.5),
      ),
      color: context.colorScheme.secondaryColor,
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: CustomText(
                    "${'statusLbl'.translate(context: context)}:",
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 5),
                CustomText(
                  detail.transalatedOrderStatus!,
                  maxLines: 2,
                  color: statusColor,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: CustomText(
                    'invoiceNumber'.translate(context: context),
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 5),
                CustomText(
                  detail.invoiceNo!,
                  maxLines: 2,
                  color: UiUtils.getStatusColor(
                    context: context,
                    statusVal: detail.orderStatus.toLowerCase(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateAndTimeWidget(HandymanBookingDetail detail) {
    return CustomContainer(
      color: context.colorScheme.secondaryColor,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                'bookingAt'.translate(context: context),
                color: context.colorScheme.lightGreyColor,
              ),
              CustomText(
                detail.isAtStore
                    ? 'store'.translate(context: context)
                    : "doorstep".translate(context: context),
                color: context.colorScheme.accentColor,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          const SizedBox(height: 5),
          if (detail.address.isNotEmpty)
            CustomInkWellContainer(
              showSplashEffect: false,
              onTap: () => _handleAddressTap(detail.address),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSvgPicture(
                    svgImage: AppAssets.mapPic,
                    color: context.colorScheme.accentColor,
                    height: 16,
                    width: 16,
                  ),
                  const SizedBox(width: 5),
                  Expanded(child: CustomText(detail.address)),
                ],
              ),
            ),
          const SizedBox(height: 8),
          if (detail.customerNo.isNotEmpty) ...[
            CustomInkWellContainer(
              showSplashEffect: false,
              onTap: () async {
                final Uri url = Uri.parse("tel:${detail.customerNo}");
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSvgPicture(
                    svgImage: AppAssets.call,
                    color: context.colorScheme.accentColor,
                    height: 16,
                    width: 16,
                  ),
                  const SizedBox(width: 5),
                  Expanded(child: CustomText(detail.customerNo)),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          _buildDateAndTimeBox(detail),
        ],
      ),
    );
  }

  Widget _buildDateAndTimeBox(HandymanBookingDetail detail) {
    if (detail.multipleDaysBooking != null) {
      return MultiDayDateAndTime(booking: detail.multipleDaysBooking!);
    }

    return IntrinsicHeight(
      child: Row(
        children: [
          CustomSvgPicture(
            svgImage: AppAssets.bCalender,
            height: 16,
            width: 16,
            color: context.colorScheme.accentColor,
          ),
          const SizedBox(width: 5),
          CustomText(
            detail.dateOfService.formatDate(withTime: detail.startingTime),
            fontSize: 14,
            color: context.colorScheme.blackColor,
            fontWeight: FontWeight.w600,
          ),
          VerticalDivider(
            color: context.colorScheme.lightGreyColor,
            thickness: 0.2,
          ),
          CustomSvgPicture(
            svgImage: AppAssets.bClock,
            height: 16,
            width: 16,
            color: context.colorScheme.accentColor,
          ),
          const SizedBox(width: 5),
          CustomText(
            detail.startingTime.formatTime(onDate: detail.dateOfService),
            fontSize: 14,
            color: context.colorScheme.blackColor,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Future<void> _handleAddressTap(String address) async {
    final String query = Uri.encodeComponent(address);
    final Uri googleMapsUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$query",
    );
    final Uri appleMapsUrl = Uri.parse("https://maps.apple.com/?q=$query");

    if (Platform.isIOS) {
      if (await canLaunchUrl(appleMapsUrl)) {
        await launchUrl(appleMapsUrl, mode: LaunchMode.externalApplication);
        return;
      }
    }
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      UiUtils.showMessage(
        context,
        'somethingWentWrong',
        ToastificationType.error,
      );
    }
  }

  Widget _buildServiceDetailsWidget(HandymanBookingDetail detail) {
    return CustomContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      color: Theme.of(context).colorScheme.secondaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'serviceDetailsLbl'.translate(context: context),
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: context.colorScheme.blackColor,
          ),
          const SizedBox(height: 10),
          ...detail.services.map((service) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomContainer(
                    height: 44,
                    width: 44,
                    borderRadius: UiUtils.borderRadiusOf5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        UiUtils.borderRadiusOf5,
                      ),
                      child: service.image.isNotEmpty
                          ? CustomCachedNetworkImage(
                              imageUrl: service.image,
                              height: 44,
                              width: 44,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.home_repair_service,
                              color: context.colorScheme.accentColor,
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          service.title,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: context.colorScheme.blackColor,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 2),
                        CustomText(
                          '${"qtyLbl".translate(context: context)} ${service.quantity}',
                          fontSize: 12,
                          color: context.colorScheme.lightGreyColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    service.price
                        .replaceAll(',', '')
                        .priceFormat(
                          context,
                          currencySymbol: detail.currency,
                          decimalPlaces: detail.currencyDecimalPlaces,
                        ),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.colorScheme.blackColor,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAssignedHandymenWidget(HandymanBookingDetail detail) {
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
          if (detail.assignedHandymen.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CustomText(
                'noHandymenAssigned'.translate(context: context),
                color: context.colorScheme.lightGreyColor,
                fontSize: 14,
              ),
            )
          else
            ...detail.assignedHandymen.map((h) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.accentColor,
                      child: ClipOval(
                        child: h.profileImage.isNotEmpty
                            ? CustomCachedNetworkImage(
                                imageUrl: h.profileImage,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                              )
                            : CustomText(
                                h.displayName.isNotEmpty
                                    ? h.displayName[0].toUpperCase()
                                    : '?',
                                color: AppColors.whiteColors,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            h.displayName,
                            color: context.colorScheme.blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                    if (h.isLead) ...[
                      const SizedBox(width: 4),
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
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildUploadedProofWidget(String title, List<dynamic> proofData) {
    if (proofData.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        const SizedBox(height: 10),
        CustomContainer(
          color: Theme.of(context).colorScheme.secondaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title.translate(context: context),
                      maxLines: 1,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.blackColor,
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(proofData.length, (int index) {
                          return CustomContainer(
                            height: 50,
                            width: 50,
                            margin: const EdgeInsetsDirectional.only(end: 10),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.lightGreyColor,
                            ),
                            child: CustomInkWellContainer(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.imagePreviewScreen,
                                  arguments: {
                                    'startFrom': index,
                                    'isReviewType': false,
                                    'dataURL': proofData,
                                  },
                                ).then((Object? value) {
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.portraitUp,
                                    DeviceOrientation.portraitDown,
                                  ]);
                                });
                              },
                              child:
                                  UrlTypeHelper.getType(proofData[index]) ==
                                      UrlType.image
                                  ? CustomCachedNetworkImage(
                                      imageUrl: proofData[index],
                                      height: 50,
                                      width: 50,
                                    )
                                  : UrlTypeHelper.getType(proofData[index]) ==
                                        UrlType.video
                                  ? Center(
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.accentColor,
                                      ),
                                    )
                                  : const CustomContainer(),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 0.5,
                color: Theme.of(context).colorScheme.lightGreyColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSectionWidget(HandymanBookingDetail detail) {
    return CustomContainer(
      color: context.colorScheme.secondaryColor,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          _buildBillDetailsSection(detail),
          const SizedBox(height: 10),
          _getPriceSectionTile(
            context: context,
            fontSize: 20,
            heading:
                (detail.paymentMethod == "cod"
                        ? "totalAmount".translate(context: context)
                        : 'paidAmount'.translate(context: context))
                    .translate(context: context),
            subHeading: detail.finalTotal.priceFormat(
              context,
              currencySymbol: detail.currency,
              decimalPlaces: detail.currencyDecimalPlaces,
            ),
            textColor: context.colorScheme.blackColor,
            fontWeight: FontWeight.w700,
            subHeadingTextColor: context.colorScheme.accentColor,
          ),
          const SizedBox(height: 10),
          Divider(
            color: context.colorScheme.lightGreyColor,
            thickness: 0.5,
            height: 0.5,
          ),
          const SizedBox(height: 10),
          _buildPaymentModeWidget(detail),
        ],
      ),
    );
  }

  Widget _buildBillDetailsSection(HandymanBookingDetail detail) {
    return ValueListenableBuilder(
      valueListenable: isBillDetailsCollapsed,
      builder: (context, bool isCollapsed, _) {
        return Column(
          children: [
            CustomInkWellContainer(
              onTap: () {
                isBillDetailsCollapsed.value = !isBillDetailsCollapsed.value;
              },
              child: Row(
                children: [
                  Expanded(
                    child: CustomText(
                      "billDetails".translate(context: context),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: context.colorScheme.lightGreyColor,
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isCollapsed
                        ? Icon(
                            Icons.arrow_drop_down_sharp,
                            color: context.colorScheme.accentColor,
                            size: 24,
                          )
                        : Icon(
                            Icons.arrow_drop_up_sharp,
                            color: context.colorScheme.accentColor,
                            size: 24,
                          ),
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: CustomContainer(
                constraints: isCollapsed
                    ? const BoxConstraints(maxHeight: 0.0)
                    : const BoxConstraints(
                        maxHeight: double.infinity,
                        maxWidth: double.maxFinite,
                      ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    if (detail.taxBreakdown?.groups.isNotEmpty ?? false)
                      TaxBreakdownRows(
                        breakdown: detail.taxBreakdown!,
                        fees: detail.fees,
                        visitingCharges: detail.visitingCharges,
                        currencySymbol: detail.currency,
                        decimalPlaces: detail.currencyDecimalPlaces,
                      )
                    else ...[
                      _setServiceRowValues(
                        currencySymbol: detail.currency,
                        decimalPlaces: detail.currencyDecimalPlaces,
                        title: 'totalServiceChargesLbl'.translate(
                          context: context,
                        ),
                        quantity: '',
                        price:
                            (double.tryParse(
                                      detail.total.replaceAll(",", ''),
                                    ) ??
                                    0.0)
                                .toString(),
                      ),
                      if (detail.taxAmount.isNotEmpty &&
                          detail.taxAmount != "0" &&
                          detail.taxAmount != "0.00") ...[
                        const SizedBox(height: 5),
                        _setServiceRowValues(
                          currencySymbol: detail.currency,
                          decimalPlaces: detail.currencyDecimalPlaces,
                          title: detail.taxType == 'included'
                              ? "${"taxLbl".translate(context: context)} (${"included".translate(context: context)})"
                              : "taxLbl".translate(context: context),
                          price: detail.taxAmount,
                          quantity: '',
                          pricePrefix: detail.taxType == 'included'
                              ? null
                              : "+",
                        ),
                      ],
                      if (detail.visitingCharges != "0") ...[
                        const SizedBox(height: 5),
                        _setServiceRowValues(
                          currencySymbol: detail.currency,
                          decimalPlaces: detail.currencyDecimalPlaces,
                          title: 'visitingCharge'.translate(context: context),
                          quantity: '',
                          price:
                              (double.tryParse(
                                        detail.visitingCharges.replaceAll(
                                          ",",
                                          '',
                                        ),
                                      ) ??
                                      0.0)
                                  .toString(),
                        ),
                      ],
                      if (detail.fees != null && detail.fees!.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        ...detail.fees!.map(
                          (fee) => Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: _setServiceRowValues(
                              currencySymbol: detail.currency,
                              decimalPlaces: detail.currencyDecimalPlaces,
                              title: fee.title ?? '',
                              quantity: '',
                              price: fee.calculatedAmount ?? '0',
                            ),
                          ),
                        ),
                      ],
                    ],
                    if (detail.totalAdditionalCharge != "0") ...[
                      const SizedBox(height: 5),
                      ValueListenableBuilder(
                        valueListenable: isAdditionalChargesCollapsed,
                        builder: (context, bool isChargesCollapsed, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomInkWellContainer(
                                onTap: () {
                                  isAdditionalChargesCollapsed.value =
                                      !isAdditionalChargesCollapsed.value;
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _setServiceRowValues(
                                        currencySymbol: detail.currency,
                                        decimalPlaces:
                                            detail.currencyDecimalPlaces,
                                        title: 'totalAdditionServiceChargesLbl'
                                            .translate(context: context),
                                        quantity: '',
                                        price:
                                            (double.tryParse(
                                                      detail
                                                          .totalAdditionalCharge
                                                          .replaceAll(",", ''),
                                                    ) ??
                                                    0.0)
                                                .toString(),
                                      ),
                                    ),
                                    AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: isChargesCollapsed
                                          ? Icon(
                                              Icons.arrow_drop_down_sharp,
                                              color: context
                                                  .colorScheme
                                                  .accentColor,
                                              size: 24,
                                            )
                                          : Icon(
                                              Icons.arrow_drop_up_sharp,
                                              color: context
                                                  .colorScheme
                                                  .accentColor,
                                              size: 24,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                child: CustomContainer(
                                  constraints: isChargesCollapsed
                                      ? const BoxConstraints(maxHeight: 0.0)
                                      : const BoxConstraints(
                                          maxHeight: double.infinity,
                                          maxWidth: double.maxFinite,
                                        ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        for (
                                          int i = 0;
                                          i < detail.additionalCharges.length;
                                          i++
                                        ) ...[
                                          const SizedBox(height: 5),
                                          _setServiceRowValues(
                                            currencySymbol: detail.currency,
                                            decimalPlaces:
                                                detail.currencyDecimalPlaces,
                                            title: detail
                                                .additionalCharges[i]['name']
                                                .toString(),
                                            quantity: '',
                                            price: detail
                                                .additionalCharges[i]['charge']
                                                .toString(),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                    ..._buildPromoRow(detail),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Promo comes off the price before tax, so the tax drops too: one row for the
  // total saving, its arrow explains the split.
  List<Widget> _buildPromoRow(HandymanBookingDetail detail) {
    final discount =
        double.tryParse(detail.promoDiscount.replaceAll(',', '')) ?? 0;
    if (discount <= 0) return const [];
    final promoTax =
        double.tryParse(detail.promoTaxReduction.replaceAll(',', '')) ?? 0;

    String money(double amount) => amount.toString().priceFormat(
      context,
      currencySymbol: detail.currency,
      decimalPlaces: detail.currencyDecimalPlaces,
    );

    final label =
        '${'couponDiscLbl'.translate(context: context)}'
        '${detail.promoCode.isEmpty ? '' : ' (${detail.promoCode})'}';

    return [
      const SizedBox(height: 5),
      promoTax > 0
          ? ExpandableChargeRow(
              key: const ValueKey('promo'),
              title: label,
              amount: '- ${money(discount + promoTax)}',
              details: [
                ChargeDetailRow(
                  label: 'discountLbl'.translate(context: context),
                  amount: '- ${money(discount)}',
                ),
                ChargeDetailRow(
                  label: 'promoTaxReduction'.translate(context: context),
                  amount: '- ${money(promoTax)}',
                ),
              ],
            )
          : _setServiceRowValues(
              currencySymbol: detail.currency,
              decimalPlaces: detail.currencyDecimalPlaces,
              title: label,
              quantity: '',
              price: discount.toString(),
              pricePrefix: '-',
            ),
    ];
  }

  Widget _setServiceRowValues({
    required String title,
    required String quantity,
    required String price,
    String? pricePrefix,
    bool? isTitleBold,
    FontWeight? priceFontWeight,
    String? currencySymbol,
    int? decimalPlaces,
  }) {
    return Builder(
      builder: (context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: CustomText(
              title,
              fontSize: 14,
              fontWeight: (isTitleBold ?? false)
                  ? FontWeight.bold
                  : ((title != 'serviceDetailsLbl'.translate(context: context))
                        ? FontWeight.w400
                        : FontWeight.w700),
              color: Theme.of(context).colorScheme.blackColor,
              maxLines: 1,
            ),
          ),
          if (quantity != '')
            Flexible(
              child: CustomText(
                (title == 'totalPriceLbl'.translate(context: context) ||
                        title ==
                            'totalServicePriceLbl'.translate(context: context))
                    ? "${"totalQtyLbl".translate(context: context)} $quantity"
                    : (title == 'gstLbl'.translate(context: context) ||
                          title == 'taxLbl'.translate(context: context))
                    ? quantity.formatPercentage()
                    : (title == 'couponDiscLbl'.translate(context: context))
                    ? "${quantity.formatPercentage()} ${"offLbl".translate(context: context)}"
                    : "${"qtyLbl".translate(context: context)} $quantity",
                fontSize: 14,
                textAlign: TextAlign.end,
                color: Theme.of(context).colorScheme.lightGreyColor,
              ),
            )
          else
            const SizedBox(),
          if (price != '')
            CustomText(
              pricePrefix != null
                  ? "$pricePrefix ${price.replaceAll(',', '').priceFormat(context, currencySymbol: currencySymbol, decimalPlaces: decimalPlaces)}"
                  : price
                        .replaceAll(',', '')
                        .priceFormat(
                          context,
                          currencySymbol: currencySymbol,
                          decimalPlaces: decimalPlaces,
                        ),
              textAlign: TextAlign.end,
              fontSize: 14,
              fontWeight: priceFontWeight ?? FontWeight.w500,
              color: Theme.of(context).colorScheme.blackColor,
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }

  Widget _getPriceSectionTile({
    required final BuildContext context,
    required final String heading,
    required final String subHeading,
    required final Color textColor,
    final Color? subHeadingTextColor,
    required final double fontSize,
    final FontWeight? fontWeight,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Expanded(
          child: CustomText(
            heading,
            color: textColor,
            maxLines: 1,
            fontWeight: fontWeight,
            fontSize: fontSize,
          ),
        ),
        CustomText(
          subHeading,
          color: subHeadingTextColor ?? textColor,
          fontWeight: fontWeight,
          maxLines: 1,
          fontSize: fontSize,
        ),
      ],
    ),
  );

  Widget _buildPaymentModeWidget(HandymanBookingDetail detail) {
    return Column(
      children: [
        Row(
          children: [
            CustomContainer(
              height: 44,
              width: 44,
              borderRadius: UiUtils.borderRadiusOf5,
              child: CustomSvgPicture(
                svgImage: _getPaymentGatewayDetails(
                  paymentMethod: detail.paymentMethod,
                ).paymentImage,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomText(
                    "paymentMode".translate(context: context),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: context.colorScheme.blackColor,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: CustomText(
                          _getPaymentGatewayDetails(
                            paymentMethod: detail.paymentMethod,
                          ).paymentType.translate(context: context),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: context.colorScheme.accentColor,
                        ),
                      ),
                      CustomText(
                        UiUtils.getPaymentStatus(
                          detail.paymentStatus,
                        ).translate(context: context),
                        color: UiUtils.getPaymentStatusColor(
                          paymentStatus: detail.paymentStatus.toLowerCase(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  PaymentGatewayDetails _getPaymentGatewayDetails({
    required String paymentMethod,
  }) {
    switch (paymentMethod) {
      case "cod":
        return (paymentType: "cod", paymentImage: AppAssets.cod);
      case "stripe":
        return (paymentType: "stripe", paymentImage: AppAssets.icStripe);
      case "razorpay":
        return (paymentType: "razorpay", paymentImage: AppAssets.icRazorpay);
      case "paystack":
        return (paymentType: "paystack", paymentImage: AppAssets.icPaystack);
      case "paypal":
        return (paymentType: "paypal", paymentImage: AppAssets.icPaypal);
      case "xendit":
        return (paymentType: "xendit", paymentImage: AppAssets.icXendit);
      case "flutterwave":
        return (
          paymentType: "flutterwave",
          paymentImage: AppAssets.icFlutterwave,
        );
      case "cashfree":
        return (paymentType: "cashfree", paymentImage: AppAssets.icCashfree);
      default:
        return (paymentType: "cod", paymentImage: AppAssets.cod);
    }
  }

  Widget _buildTrackingSection(HandymanBookingDetail detail) {
    return BlocBuilder<HandymanLiveTrackingCubit, HandymanLiveTrackingState>(
      builder: (context, trackingState) {
        if (trackingState is HandymanLiveTrackingActive &&
            trackingState.hasPosition) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: MiniMapWidget(
              orderId: detail.id,
              handymanLat: trackingState.latitude!,
              handymanLng: trackingState.longitude!,
              orderLat: detail.latitude,
              orderLng: detail.longitude,
              isHandymanMode: true,
            ),
          );
        }
        if (trackingState is HandymanLiveTrackingActive) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CustomCircularProgressIndicator(
                    color: context.colorScheme.accentColor,
                  ),
                ),
                const SizedBox(width: 10),
                CustomText(
                  'waitingForLocation'.translate(context: context),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.lightGreyColor,
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CustomRoundedButton(
            showBorder: false,
            buttonTitle: 'startTracking'.translate(context: context),
            backgroundColor: context.colorScheme.accentColor,
            widthPercentage: 1,
            height: 48,
            textSize: 14,
            onTap: () => _startTracking(context, detail.id),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(HandymanBookingDetail detail) {
    if (detail.isPaymentPending ||
        !detail.isLead ||
        detail.nextStatuses.isEmpty) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<HandymanBookingStatusCubit, HandymanBookingStatusState>(
      builder: (context, statusState) {
        final bool isUpdating = statusState is HandymanBookingStatusInProgress;

        return CustomContainer(
          color: Theme.of(context).colorScheme.secondaryColor,
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: 15,
              end: 15,
              top: 10,
              bottom: 10 + MediaQuery.of(context).padding.bottom,
            ),
            child: detail.nextStatuses.length == 1
                ? CustomRoundedButton(
                    showBorder: false,
                    buttonTitle:
                        _actionLabels[detail.nextStatuses[0]]?.translate(
                          context: context,
                        ) ??
                        detail.nextStatuses[0].capitalize(),
                    backgroundColor: detail.nextStatuses[0] == 'rejected'
                        ? AppColors.redColor
                        : Theme.of(context).colorScheme.accentColor,
                    widthPercentage: 1,
                    height: 50,
                    textSize: 14,
                    onTap: isUpdating
                        ? null
                        : () => _handleStatusAction(
                            context,
                            detail,
                            detail.nextStatuses[0],
                          ),
                    child: isUpdating
                        ? CustomCircularProgressIndicator(
                            color: AppColors.whiteColors,
                          )
                        : null,
                  )
                : Row(
                    children: detail.nextStatuses.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final String status = entry.value;
                      final bool isReject = status == 'rejected';

                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: index < detail.nextStatuses.length - 1
                                ? 5
                                : 0,
                            left: index > 0 ? 5 : 0,
                          ),
                          child: CustomRoundedButton(
                            showBorder: false,
                            buttonTitle:
                                _actionLabels[status]?.translate(
                                  context: context,
                                ) ??
                                status.capitalize(),
                            backgroundColor: isReject
                                ? AppColors.redColor
                                : Theme.of(context).colorScheme.accentColor,
                            widthPercentage: 1,
                            height: 50,
                            textSize: 14,
                            onTap: isUpdating
                                ? null
                                : () => _handleStatusAction(
                                    context,
                                    detail,
                                    status,
                                  ),
                            child: isUpdating
                                ? CustomCircularProgressIndicator(
                                    color: AppColors.whiteColors,
                                  )
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        );
      },
    );
  }

  Widget _warningBanner(
    String message, {
    Color? color,
    IconData icon = Icons.warning_amber_rounded,
  }) {
    final bannerColor = color ?? AppColors.redColor;
    return CustomContainer(
      padding: const EdgeInsets.all(14),
      borderRadius: UiUtils.borderRadiusOf10,
      color: bannerColor.withValues(alpha: 0.1),
      border: Border.all(color: bannerColor.withValues(alpha: 0.3)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: bannerColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: CustomText(message, fontSize: 13, color: bannerColor),
          ),
        ],
      ),
    );
  }
}
