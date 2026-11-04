import 'package:edemand_partner/ui/widgets/bottomSheets/layouts/additionalChargesBottomSheet.dart';
import 'package:edemand_partner/ui/widgets/bottomSheets/layouts/cancelReasonBottomSheet.dart';
import 'package:edemand_partner/ui/widgets/dialog/layouts/verifyOTPDialog.dart';
import 'package:edemand_partner/ui/screens/booking/widgets/customerInfoWidget.dart';
import 'package:edemand_partner/ui/screens/booking/widgets/statusAndInvoiceWidget.dart';
import 'package:edemand_partner/ui/screens/booking/widgets/bookingDateAndTimeWidget.dart';
import 'package:edemand_partner/ui/screens/booking/widgets/uploadedProofWidget.dart';
import 'package:edemand_partner/ui/screens/booking/widgets/serviceDetailsWidget.dart';
import 'package:edemand_partner/ui/screens/booking/widgets/notesWidget.dart';
import 'package:edemand_partner/ui/screens/booking/widgets/cancelReasonWidget.dart';
import 'package:edemand_partner/ui/screens/booking/widgets/priceSectionWidget.dart';
import 'package:edemand_partner/ui/screens/booking/widgets/bookingDetailsShimmer.dart';
import 'package:flutter/material.dart';
import '../../../app/generalImports.dart';
import '../../../cubits/downloadInvoiceCubit.dart';
import '../../../cubits/getLiveTrackingDataCubit.dart';

typedef PaymentGatewayDetails = ({String paymentType, String paymentImage});

class BookingDetails extends StatefulWidget {
  const BookingDetails({super.key, this.bookingsModel, this.bookingId})
    : assert(
        bookingsModel != null || bookingId != null,
        'Either bookingsModel or bookingId must be provided',
      );

  final BookingsModel? bookingsModel;
  final String? bookingId;

  @override
  BookingDetailsState createState() => BookingDetailsState();

  static Route<BookingDetails> route(RouteSettings routeSettings) {
    final Map arguments = routeSettings.arguments as Map;

    // Check if we have a bookingsModel or just bookingId
    final BookingsModel? bookingsModel = arguments['bookingsModel'];
    final String? bookingId = arguments['bookingId'];

    if (bookingsModel != null) {
      // Existing flow - model is passed directly
      return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: arguments['cubit'] as UpdateBookingStatusCubit,
            ),
            BlocProvider(create: (_) => GetLiveTrackingDataCubit()),
          ],
          child: BookingDetails(bookingsModel: bookingsModel),
        ),
      );
    } else {
      // New flow - only bookingId is passed, need to fetch details
      return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => UpdateBookingStatusCubit()),
            BlocProvider(create: (_) => GetLiveTrackingDataCubit()),
          ],
          child: BookingDetails(bookingId: bookingId),
        ),
      );
    }
  }
}

class BookingDetailsState extends State<BookingDetails> {
  Map<String, String>? currentStatusOfBooking;
  Map<String, String>? temporarySelectedStatusOfBooking;
  int totalServiceQuantity = 0;
  BookingsModel? currentBookingModel;

  DateTime? selectedRescheduleDate;
  String? selectedRescheduleTime;
  List<Map<String, String>> filters = [];
  List<Map<String, dynamic>>? selectedProofFiles;
  List<Map<String, dynamic>>? additionalCharged;
  ValueNotifier<bool> isBillDetailsCollapsed = ValueNotifier(true);
  String? otpFromProvider;
  String? _loadingButtonValue;
  String? _cancelReasonId;
  String? _cancelAdditionalInfo;
  GetLiveTrackingDataCubit? _liveTrackingCubit;

  @override
  void initState() {
    super.initState();
    currentBookingModel = widget.bookingsModel;

    if (currentBookingModel != null) {
      _initializeWithModel();
    }

    // Always fetch to load assigned_handymen/assignable_handymen (only in single-order response)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bookingId = widget.bookingId ?? widget.bookingsModel?.id;
      if (bookingId != null) {
        context.read<FetchBookingsDetailsCubit>().fetchBookingDetails(
          bookingId: bookingId,
        );
      }
      _liveTrackingCubit = context.read<GetLiveTrackingDataCubit>();
      _maybeStartPolling();
    });

    Future.delayed(Duration.zero, () {
      filters = [
        {'value': '1', 'title': 'awaiting'.translate(context: context)},
        {'value': '2', 'title': 'confirmed'.translate(context: context)},
        {'value': '3', 'title': 'started'.translate(context: context)},
        {'value': '4', 'title': 'rescheduled'.translate(context: context)},
        {'value': '5', 'title': 'booking_ended'.translate(context: context)},
        {'value': '6', 'title': 'completed'.translate(context: context)},
        {'value': '7', 'title': 'cancelled'.translate(context: context)},
      ];
    });
  }

  void _initializeWithModel() {
    _getTotalQuantity();
    _getTranslatedInitialStatus();
    _maybeStartPolling();
  }

  void _maybeStartPolling() {
    final model = bookingModel;
    if (model == null || model.status != 'on_the_way') return;
    final id = model.id;
    if (id == null) return;
    _liveTrackingCubit?.startPolling(orderId: id);
  }

  @override
  void dispose() {
    _liveTrackingCubit?.stopPolling();
    super.dispose();
  }

  BookingsModel? get bookingModel =>
      currentBookingModel ?? widget.bookingsModel;

  void _getTotalQuantity() {
    final model = bookingModel;
    if (model == null) return;
    totalServiceQuantity = 0;
    model.services?.forEach((Services service) {
      totalServiceQuantity += int.parse(service.quantity!);
    });
    setState(() {});
  }

  void _getTranslatedInitialStatus() {
    Future.delayed(Duration.zero, () {
      final model = bookingModel;
      if (model == null) return;
      final String? initialStatusValue = _getStatusValueFromTitle(model.status);
      if (initialStatusValue != null) {
        currentStatusOfBooking = filters.where((Map<String, String> element) {
          return element['value'] == initialStatusValue;
        }).toList()[0];
      }

      setState(() {});
    });
  }

  // Don't translate this because we need to send this title in api;
  List<Map<String, String>> getStatusForApi = [
    {'value': '1', 'title': 'awaiting'},
    {'value': '2', 'title': 'confirmed'},
    {'value': '3', 'title': 'on_the_way'},
    {'value': '4', 'title': 'arrived'},
    {'value': '5', 'title': 'started'},
    {'value': '6', 'title': 'rescheduled'},
    {'value': '7', 'title': 'booking_ended'},
    {'value': '8', 'title': 'completed'},
    {'value': '9', 'title': 'cancelled'},
  ];

  // Helper method to get status value from status title
  String? _getStatusValueFromTitle(String? statusTitle) {
    if (statusTitle == null) return null;
    final status = getStatusForApi.firstWhere(
      (e) => e['title'] == statusTitle,
      orElse: () => {},
    );
    return status['value'];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FetchBookingsDetailsCubit, FetchBookingsState>(
      listener: (context, state) {
        if (state is FetchBookingsSuccess && state.bookings.isNotEmpty) {
          currentBookingModel = state.bookings.first;
          _initializeWithModel();
          setState(() {});
        }
      },
      builder: (context, fetchState) {
        // Show shimmer/error only when we have no model at all (bookingId-only flow)
        if (currentBookingModel == null) {
          if (fetchState is FetchBookingsFailure) {
            return _buildScaffold(
              context,
              body: Center(
                child: ErrorContainer(
                  errorMessage: fetchState.errorMessage,
                  onTapRetry: () {
                    final bookingId =
                        widget.bookingId ?? widget.bookingsModel?.id;
                    if (bookingId != null) {
                      context
                          .read<FetchBookingsDetailsCubit>()
                          .fetchBookingDetails(bookingId: bookingId);
                    }
                  },
                ),
              ),
              showBottomBar: false,
            );
          }
          return _buildScaffold(
            context,
            body: const BookingDetailsShimmer(),
            showBottomBar: false,
          );
        }
        return _buildMainContent(context);
      },
    );
  }

  Widget _buildScaffold(
    BuildContext context, {
    required Widget body,
    bool showBottomBar = true,
  }) {
    return PopScope(
      canPop:
          context.watch<UpdateBookingStatusCubit>().state
              is! UpdateBookingStatusInProgress,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        appBar: AppBar(
          surfaceTintColor: Theme.of(context).colorScheme.secondaryColor,
          backgroundColor: Theme.of(context).colorScheme.secondaryColor,
          elevation: 10,
          leading: CustomBackArrow(
            canGoBack:
                context.watch<UpdateBookingStatusCubit>().state
                    is! UpdateBookingStatusInProgress,
          ),
          title: CustomText(
            'bookingInformation'.translate(context: context),
            color: context.colorScheme.blackColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        body: body,
        bottomNavigationBar: showBottomBar ? bottomBarWidget() : null,
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final model = bookingModel;
    if (model == null) {
      return _buildScaffold(
        context,
        body: const BookingDetailsShimmer(),
        showBottomBar: false,
      );
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<AssignHandymanCubit, AssignHandymanState>(
          listener: (context, state) {
            if (state is AssignHandymanSuccess) {
              UiUtils.showMessage(
                context,
                'handymanAssignedSuccessfully'.translate(context: context),
                ToastificationType.success,
              );
              context.read<FetchBookingsDetailsCubit>().fetchBookingDetails(
                bookingId: model.id!,
              );
            } else if (state is AssignHandymanFailure) {
              UiUtils.showMessage(
                context,
                state.errorMessage,
                ToastificationType.error,
              );
            }
          },
        ),
        BlocListener<UnassignHandymanCubit, UnassignHandymanState>(
          listener: (context, state) {
            if (state is UnassignHandymanSuccess) {
              UiUtils.showMessage(
                context,
                'handymanUnassignedSuccessfully'.translate(context: context),
                ToastificationType.success,
              );
              context.read<FetchBookingsDetailsCubit>().fetchBookingDetails(
                bookingId: model.id!,
              );
            } else if (state is UnassignHandymanFailure) {
              UiUtils.showMessage(
                context,
                state.errorMessage,
                ToastificationType.error,
              );
            }
          },
        ),
        BlocListener<SetLeadHandymanCubit, SetLeadHandymanState>(
          listener: (context, state) {
            if (state is SetLeadHandymanSuccess) {
              UiUtils.showMessage(
                context,
                'leadHandymanSetSuccessfully'.translate(context: context),
                ToastificationType.success,
              );
              context.read<FetchBookingsDetailsCubit>().fetchBookingDetails(
                bookingId: model.id!,
              );
            } else if (state is SetLeadHandymanFailure) {
              UiUtils.showMessage(
                context,
                state.errorMessage,
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
      child: PopScope(
        canPop:
            context.watch<UpdateBookingStatusCubit>().state
                is! UpdateBookingStatusInProgress,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primaryColor,
          appBar: AppBar(
            surfaceTintColor: Theme.of(context).colorScheme.secondaryColor,
            backgroundColor: Theme.of(context).colorScheme.secondaryColor,
            elevation: 10,
            leading: CustomBackArrow(
              canGoBack:
                  context.watch<UpdateBookingStatusCubit>().state
                      is! UpdateBookingStatusInProgress,
            ),
            title: Column(
              children: [
                CustomText(
                  'bookingInformation'.translate(context: context),
                  color: context.colorScheme.blackColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                if (model.customJobRequestId != null)
                  CustomText(
                    'customServiceRequest'.translate(context: context),
                    color: context.colorScheme.lightGreyColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
              ],
            ),
          ),
          body: mainWidget(),
          bottomNavigationBar: bottomBarWidget(),
        ),
      ),
    );
  }

  Widget onMapsBtn() {
    final model = bookingModel;
    if (model == null) return const SizedBox.shrink();
    return CustomInkWellContainer(
      onTap: () async {
        UiUtils.openMap(
          context,
          latitude: model.latitude,
          longitude: model.longitude,
        );
      },
      child: CustomContainer(
        padding: const EdgeInsets.all(10),
        color: Theme.of(context).colorScheme.accentColor.withValues(alpha: 0.3),
        borderRadius: UiUtils.borderRadiusOf5,
        child: Text(
          'onMapsLbl'.translate(context: context),
          style: TextStyle(color: Theme.of(context).colorScheme.accentColor),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getStatusButtonsForValue(
    String? currentStatusValue,
    bool isDoorstep,
  ) {
    switch (currentStatusValue) {
      case '1': // awaiting
        return [
          {'value': '2', 'title': 'confirm'.translate(context: context)},
          {'value': '9', 'title': 'cancel'.translate(context: context)},
        ];
      case '2': // confirmed
        return [
          if (isDoorstep)
            {'value': '3', 'title': 'on_the_way'.translate(context: context)}
          else
            {'value': '5', 'title': 'start'.translate(context: context)},
          {'value': '6', 'title': 'reschedule'.translate(context: context)},
          {'value': '9', 'title': 'cancel'.translate(context: context)},
        ];
      case '3': // on_the_way
        return isDoorstep
            ? [
                {'value': '4', 'title': 'arrived'.translate(context: context)},
              ]
            : [
                {'value': '5', 'title': 'start'.translate(context: context)},
              ];
      case '4': // arrived
        return [
          {'value': '5', 'title': 'start'.translate(context: context)},
        ];
      case '6': // rescheduled
        return [
          {'value': '5', 'title': 'start'.translate(context: context)},
          {'value': '9', 'title': 'cancel'.translate(context: context)},
        ];
      case '5': // started
        return [
          {'value': '7', 'title': 'booking_ended'.translate(context: context)},
          {'value': '8', 'title': 'complete'.translate(context: context)},
        ];
      case '7': // booking_ended
        return [
          {'value': '8', 'title': 'complete'.translate(context: context)},
        ];
      case '8': // completed
        return [
          {
            'value': 'invoice',
            'title': 'downloadInvoice'.translate(context: context),
          },
        ];
      case '9': // cancelled
      default:
        return [];
    }
  }

  bool _isAdditionalChargesPaymentBlocked(BookingsModel model) {
    final BookingsModel effective = currentBookingModel ?? model;
    final double totalAdditional = effective.totalAdditionalChargeDouble ?? 0;
    if (totalAdditional <= 0) return false;

    final String method = (effective.paymentMethodOfAdditionalCharge ?? '')
        .trim()
        .toLowerCase();
    if (method.isEmpty) return true;
    if (method == 'cod') return false;

    final String status = (effective.paymentStatusOfAdditionalCharge ?? '')
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
        confirmButtonBackgroundColor: Theme.of(context).colorScheme.accentColor,
        cancelButtonBackgroundColor: Theme.of(
          context,
        ).colorScheme.secondaryColor,
        showProgressIndicator: false,
        cancelButtonPressed: () => Navigator.pop(context),
        confirmButtonPressed: () => Navigator.pop(context),
      ),
    );
  }

  Future<void> _handleStatusUpdate(String statusValue) async {
    final model = bookingModel;
    if (model == null) return;

    if (statusValue == 'invoice') {
      context.read<DownloadInvoiceCubit>().downloadInvoice(
        bookingId: model.id ?? '',
        buttonScreenName: 'bookingDetails',
      );
      return;
    }

    final UpdateBookingStatusState currentState = context
        .read<UpdateBookingStatusCubit>()
        .state;
    if (currentState is UpdateBookingStatusInProgress) {
      return;
    }

    setState(() {
      _loadingButtonValue = statusValue;
    });

    Map<String, String>? bookingStatus;
    final List<Map<String, String>> selectedBookingStatus = getStatusForApi
        .where((Map<String, String> element) {
          return element['value'] == statusValue;
        })
        .toList();

    if (selectedBookingStatus.isNotEmpty) {
      bookingStatus = selectedBookingStatus[0];
    }
    if (statusValue == '5') {
      final proofResult = await UiUtils.showModelBottomSheets(
        context: context,
        child: UploadProofBottomSheet(preSelectedFiles: selectedProofFiles),
      );
      if (proofResult == null) {
        setState(() => _loadingButtonValue = null);
        return;
      }

      selectedProofFiles = proofResult;
      setState(() {});
    } else if (statusValue == '7') {
      final proofResult = await UiUtils.showModelBottomSheets(
        context: context,
        child: UploadProofBottomSheet(preSelectedFiles: selectedProofFiles),
      );
      if (proofResult == null) {
        setState(() => _loadingButtonValue = null);
        return;
      }

      selectedProofFiles = proofResult;
      setState(() {});

      final chargesResult = await UiUtils.showModelBottomSheets(
        context: context,
        useSafeArea: true,
        child: AdditionalChargesBottomSheet(
          additionalCharges: additionalCharged,
        ),
      );
      if (chargesResult == null) {
        setState(() => _loadingButtonValue = null);
        return;
      }

      additionalCharged = chargesResult;
      setState(() {});
    } else if (statusValue == '9') {
      final reasons = await BookingsRepository().getCancellationReasons();
      if (reasons.isNotEmpty) {
        final Map? cancelResult = await UiUtils.showModelBottomSheets(
          context: context,
          enableDrag: true,
          child: const CancelReasonBottomSheet(),
        );
        if (cancelResult == null) {
          setState(() => _loadingButtonValue = null);
          return;
        }
        _cancelReasonId = cancelResult['reasonId'] as String?;
        _cancelAdditionalInfo = cancelResult['additionalInfo'] as String?;
      }
    } else if (statusValue == '6') {
      final Map? result = await UiUtils.showModelBottomSheets(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        child: CustomContainer(
          height: context.screenHeight * 0.7,
          borderRadiusStyle: const BorderRadius.only(
            topRight: Radius.circular(UiUtils.borderRadiusOf20),
            topLeft: Radius.circular(UiUtils.borderRadiusOf20),
          ),
          child: CalenderBottomSheet(
            advanceBookingDays: model.advanceBookingDays!,
            customJobRequestId: model.customJobRequestId,
          ),
        ),
      );

      selectedRescheduleDate = result?['selectedDate'];
      selectedRescheduleTime = result?['selectedTime'];
      if (selectedRescheduleDate == null || selectedRescheduleTime == null) {
        setState(() => _loadingButtonValue = null);
        return;
      }
    }
    if (statusValue == '8' && _isAdditionalChargesPaymentBlocked(model)) {
      await _showPaymentNotSelectedDialog(context);
      setState(() => _loadingButtonValue = null);
      return;
    }

    if (statusValue == '8' &&
        context.read<FetchSystemSettingsCubit>().isOrderOTPConfirmationEnable) {
      if (otpFromProvider == null || otpFromProvider!.trim().isEmpty) {
        final dialogResult = await UiUtils.showAnimatedDialog(
          context: context,
          child: VerifyOTPDialog(userId: model.customerId ?? ''),
        );

        if (dialogResult != null) {
          otpFromProvider = dialogResult.toString();
        } else {
          otpFromProvider = '';
          setState(() => _loadingButtonValue = null);
          return;
        }
      }
    }

    if (statusValue == '8' && model.paymentMethod == "cod") {
      final bool isOtpEnabled = context
          .read<FetchSystemSettingsCubit>()
          .isOrderOTPConfirmationEnable;
      final cashDialogResult = await UiUtils.showAnimatedDialog(
        context: context,
        child: CustomDialogLayout(
          title: isOtpEnabled ? "collectCashFromCustomer" : "collectdCash",
          confirmButtonName: "okay",
          cancelButtonName: "cancel",
          confirmButtonBackgroundColor: Theme.of(
            context,
          ).colorScheme.accentColor,
          cancelButtonBackgroundColor: Theme.of(
            context,
          ).colorScheme.secondaryColor,
          showProgressIndicator: false,
          cancelButtonPressed: () => Navigator.pop(context, false),
          confirmButtonPressed: () => Navigator.pop(context, true),
        ),
      );
      if (!context.mounted) return;
      if (cashDialogResult != true) {
        setState(() => _loadingButtonValue = null);
        return;
      }
    }
    final String translatedStatus = (bookingStatus?['title'] ?? model.status!)
        .translate(context: context);

    context.read<UpdateBookingStatusCubit>().updateBookingStatus(
      orderId: int.parse(model.id!),
      customerId: int.parse(model.customerId!),
      status: bookingStatus?['title'] ?? model.status!,
      translatedStatus: translatedStatus,
      otp: otpFromProvider ?? '',
      date: selectedRescheduleDate?.toString().split(' ')[0],
      time: selectedRescheduleTime,
      proofData: selectedProofFiles,
      additionalCharges: additionalCharged,
      cancelReasonId: _cancelReasonId,
      additionalInfo: _cancelAdditionalInfo,
    );
  }

  Widget bottomBarWidget() {
    final model = bookingModel;
    if (model == null) return const SizedBox.shrink();

    return BlocConsumer<DownloadInvoiceCubit, DownloadInvoiceState>(
      listener: (BuildContext context, DownloadInvoiceState downloadState) async {
        if (downloadState is DownloadInvoiceSuccess) {
          if (downloadState.bookingId == model.id &&
              downloadState.buttonScreenName == 'bookingDetails') {
            try {
              final appDocDirPath =
                  (await getApplicationDocumentsDirectory()).path;
              final targetFileName =
                  "$appName-${"invoice".translate(context: context)}-${model.id}.pdf";
              final File file = File("$appDocDirPath/$targetFileName");

              await file.writeAsBytes(downloadState.invoiceData).then((
                final value,
              ) {
                OpenFile.open(file.path);
              });
            } catch (e) {
              UiUtils.showMessage(
                context,
                'somethingWentWrongTitle'.translate(context: context),
                ToastificationType.error,
              );
            }
          }
        } else if (downloadState is DownloadInvoiceFailure) {
          if (downloadState.bookingId == model.id) {
            UiUtils.showMessage(
              context,
              downloadState.errorMessage,
              ToastificationType.error,
            );
          }
        }
      },
      builder: (BuildContext context, DownloadInvoiceState downloadState) {
        return BlocConsumer<UpdateBookingStatusCubit, UpdateBookingStatusState>(
          listener: (BuildContext context, UpdateBookingStatusState state) {
            if (state is UpdateBookingStatusSuccess) {
              _loadingButtonValue = null;
              if (state.error == 'true') {
                UiUtils.showMessage(
                  context,
                  state.message,
                  ToastificationType.error,
                );
                return;
              }
              selectedProofFiles = [];
              additionalCharged = [];
              _cancelReasonId = null;
              _cancelAdditionalInfo = null;
              context.read<FetchBookingsCubit>().updateBookingDetailsLocally(
                bookingID: state.orderId.toString(),
                bookingStatus: state.status,
                listOfUploadedImages: state.imagesList,
                listOfAdditionalCharged: state.additionalCharges,
                bookingTranslatedStatus: state.translatedStatus,
              );

              if (currentBookingModel != null) {
                currentBookingModel!.status = state.status;
                currentBookingModel!.translatedStatus = state.translatedStatus;

                final String? statusValue = _getStatusValueFromTitle(
                  state.status,
                );
                if (statusValue == '5') {
                  currentBookingModel!.workStartedProof = state.imagesList;
                } else if (statusValue == '7') {
                  currentBookingModel!.workCompletedProof = state.imagesList;
                  currentBookingModel!.additionalCharges =
                      state.additionalCharges;
                }
                setState(() {});
              }

              UiUtils.showMessage(
                context,
                'updatedSuccessfully',
                ToastificationType.success,
              );
            } else if (state is UpdateBookingStatusFailure) {
              _loadingButtonValue = null;
            }
          },
          builder: (BuildContext context, UpdateBookingStatusState state) {
            final String paymentStatus =
                (currentBookingModel?.paymentStatus ??
                        model.paymentStatus ??
                        '')
                    .toLowerCase();
            // COD bookings sit at "pending" until settled on delivery, so
            // only block for online payments that are genuinely pending/failed.
            final bool isPaymentBlocking =
                model.paymentMethod?.toLowerCase() != 'cod' &&
                (paymentStatus == 'pending' ||
                    paymentStatus == 'failed' ||
                    paymentStatus == '0' ||
                    paymentStatus == '2');

            if (isPaymentBlocking) {
              return CustomContainer(
                color: Theme.of(context).colorScheme.secondaryColor,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: 15,
                    end: 15,
                    top: 10,
                    bottom: 10 + MediaQuery.of(context).padding.bottom,
                  ),
                  child: _paymentStatusWarning(paymentStatus),
                ),
              );
            }

            final bool isLoading = state is UpdateBookingStatusInProgress;
            final String? statusToUse = _getStatusValueFromTitle(
              isLoading
                  ? model.status
                  : (currentBookingModel?.status ?? model.status),
            );
            final List<Map<String, dynamic>> buttons =
                _getStatusButtonsForValue(statusToUse, model.addressId != "0");

            if (buttons.isEmpty) {
              return const SizedBox.shrink();
            }

            final downloadState = context.watch<DownloadInvoiceCubit>().state;
            final bool isInvoiceDownloading =
                downloadState is DownloadInvoiceInProgress &&
                downloadState.bookingId == model.id &&
                downloadState.buttonScreenName == 'bookingDetails';

            return CustomContainer(
              color: Theme.of(context).colorScheme.secondaryColor,
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 15,
                  end: 15,
                  top: 10,
                  bottom: 10 + MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedRescheduleDate != null &&
                        selectedRescheduleTime != null) ...[
                      SizedBox(
                        height: 70,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'selectedDate'.translate(context: context),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: context.colorScheme.blackColor,
                                    ),
                                  ),
                                  Text(
                                    selectedRescheduleDate
                                        .toString()
                                        .split(' ')[0]
                                        .formatDate(),
                                    style: TextStyle(
                                      color: context.colorScheme.blackColor
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'selectedTime'.translate(context: context),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: context.colorScheme.blackColor,
                                    ),
                                  ),
                                  Text(
                                    (selectedRescheduleTime ?? '').formatTime(),
                                    style: TextStyle(
                                      color: context.colorScheme.blackColor
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    buttons.length == 1
                        ? CustomRoundedButton(
                            showBorder: false,
                            buttonTitle: buttons[0]['title'] as String,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.accentColor,
                            widthPercentage: 1,
                            height: 50,
                            textSize: 14,
                            onTap: () {
                              if (isLoading ||
                                  (isInvoiceDownloading &&
                                      buttons[0]['value'] == 'invoice')) {
                                return;
                              }
                              _handleStatusUpdate(
                                buttons[0]['value'] as String,
                              );
                            },
                            child:
                                ((_loadingButtonValue == buttons[0]['value'] &&
                                        isLoading) ||
                                    (isInvoiceDownloading &&
                                        buttons[0]['value'] == 'invoice'))
                                ? CustomCircularProgressIndicator(
                                    color: AppColors.whiteColors,
                                  )
                                : null,
                          )
                        : Row(
                            children: buttons.asMap().entries.map((entry) {
                              final int index = entry.key;
                              final Map<String, dynamic> button = entry.value;
                              final bool isThisButtonLoading =
                                  _loadingButtonValue == button['value'] &&
                                  isLoading;
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: index < buttons.length - 1 ? 5 : 0,
                                    left: index > 0 ? 5 : 0,
                                  ),
                                  child: CustomRoundedButton(
                                    showBorder: false,
                                    buttonTitle: button['title'] as String,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.accentColor,
                                    widthPercentage: 1,
                                    height: 50,
                                    textSize: 14,
                                    onTap: () {
                                      if (isLoading ||
                                          (isInvoiceDownloading &&
                                              button['value'] == 'invoice')) {
                                        return;
                                      }
                                      _handleStatusUpdate(
                                        button['value'] as String,
                                      );
                                    },
                                    child:
                                        (isThisButtonLoading ||
                                            (isInvoiceDownloading &&
                                                button['value'] == 'invoice'))
                                        ? CustomCircularProgressIndicator(
                                            color: AppColors.whiteColors,
                                          )
                                        : null,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _paymentStatusWarning(String paymentStatus) {
    final bool isFailed = paymentStatus == 'failed' || paymentStatus == '2';
    final Color warningColor = isFailed
        ? AppColors.failedPaymentStatusColor
        : AppColors.pendingPaymentStatusColor;
    return CustomContainer(
      padding: const EdgeInsets.all(14),
      borderRadius: UiUtils.borderRadiusOf10,
      color: warningColor.withValues(alpha: 0.1),
      border: Border.all(color: warningColor.withValues(alpha: 0.3)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: warningColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: CustomText(
              (isFailed
                      ? 'statusUpdateBlockedByFailedPaymentMessage'
                      : 'statusUpdateBlockedByPendingPaymentMessage')
                  .translate(context: context),
              fontSize: 13,
              color: warningColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget mainWidget() {
    final model = bookingModel;
    if (model == null) {
      return const BookingDetailsShimmer();
    }
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomerInfoWidget(bookingsModel: model),
          const SizedBox(height: 10),
          StatusAndInvoiceWidget(bookingsModel: model),
          if (model.status == 'on_the_way') _buildTrackingSection(model),
          CancelReasonWidget(bookingsModel: model),
          const SizedBox(height: 10),
          BookingDateAndTimeWidget(bookingsModel: model),
          AssignedHandymansWidget(bookingsModel: model),
          Visibility(
            visible: model.workStartedProof?.isNotEmpty ?? false,
            child: UploadedProofWidget(
              title: 'workStartedProof',
              proofData: model.workStartedProof!,
            ),
          ),
          Visibility(
            visible: model.workCompletedProof?.isNotEmpty ?? false,
            child: UploadedProofWidget(
              title: 'workCompletedProof',
              proofData: model.workCompletedProof!,
            ),
          ),
          NotesWidget(remarks: model.remarks ?? ''),
          ServiceDetailsWidget(bookingsModel: model),
          PriceSectionWidget(
            bookingsModel: model,
            isBillDetailsCollapsed: isBillDetailsCollapsed,
          ),
        ],
      ),
    );
  }

  Future<void> _startProviderTracking(
    BuildContext context,
    String orderId,
  ) async {
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
    context.read<HandymanLiveTrackingCubit>().startTracking(bookingId: orderId);
  }

  bool _hasLeadHandyman(BookingsModel model) {
    final isLead = (model.assignedHandymen ?? []).any((h) => h.isLead);
    return isLead;
  }

  Widget _buildTrackingSection(BookingsModel model) {
    return BlocBuilder<HandymanLiveTrackingCubit, HandymanLiveTrackingState>(
      builder: (context, sharingState) {
        final bool isSharing = sharingState is HandymanLiveTrackingActive;

        return BlocBuilder<GetLiveTrackingDataCubit, GetLiveTrackingDataState>(
          builder: (context, liveState) {
            final liveData = liveState is GetLiveTrackingDataSuccess
                ? liveState.data
                : null;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!_hasLeadHandyman(model))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CustomRoundedButton(
                        showBorder: !isSharing,
                        buttonTitle: isSharing
                            ? 'stopLocationSharing'.translate(context: context)
                            : 'startLocationSharing'.translate(
                                context: context,
                              ),
                        backgroundColor: isSharing
                            ? Colors.red
                            : context.colorScheme.accentColor,
                        widthPercentage: 1,
                        height: 48,
                        textSize: 14,
                        onTap: () {
                          if (isSharing) {
                            context
                                .read<HandymanLiveTrackingCubit>()
                                .stopTracking();
                          } else {
                            _startProviderTracking(context, model.id ?? '');
                          }
                        },
                      ),
                    ),
                  if (liveData != null && liveData.hasHandymanLocation)
                    MiniMapWidget(
                      orderId: model.id ?? '',
                      handymanLat: liveData.handymanLat!,
                      handymanLng: liveData.handymanLng!,
                      orderLat: liveData.orderLat,
                      orderLng: liveData.orderLng,
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
