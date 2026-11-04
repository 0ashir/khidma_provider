import 'handymanBookingListItem.dart';
import 'handymanBookingServiceItem.dart';
import '../booking/assignedHandymanModel.dart';
import '../bookingModel.dart';
import '../taxBreakdownModel.dart';

class HandymanBookingDetail extends HandymanBookingListItem {
  final String remarks;
  final String otp;
  final String total;
  final String taxAmount;
  final List<String> nextStatuses;
  final List<AssignedHandymanModel> assignedHandymen;
  final bool isPaymentPending;
  final List<dynamic> workStartedProof;
  final List<dynamic> workCompletedProof;
  final List<dynamic> additionalCharges;
  final String paymentStatus;
  final List<HandymanBookingServiceItem> services;
  final String visitingCharges;
  final String taxType;
  final String totalAdditionalCharge;
  final String paymentMethodOfAdditionalCharge;
  final String paymentStatusOfAdditionalCharge;
  final List<BookingFee>? fees;
  final TaxBreakdown? taxBreakdown;
  final String promoCode;
  final String promoDiscount;
  final String promoTaxReduction;

  /// Null for a single-day booking.
  final MultipleDaysBooking? multipleDaysBooking;

  const HandymanBookingDetail({
    required super.id,
    required super.customer,
    required super.customerId,
    required super.customerNo,
    required super.customerEmail,
    required super.profileImage,
    required super.address,
    required super.dateOfService,
    required super.startingTime,
    required super.endingTime,
    required super.finalTotal,
    required super.paymentMethod,
    required super.orderStatus,
    required super.handymanStatus,
    required super.isLead,
    super.latitude,
    super.longitude,
    required this.remarks,
    required this.otp,
    required this.total,
    required this.taxAmount,
    required this.nextStatuses,
    required this.assignedHandymen,
    required this.isPaymentPending,
    required this.workStartedProof,
    required this.workCompletedProof,
    required this.additionalCharges,
    required super.isAtStore,
    required super.transalatedOrderStatus,
    required super.transalatedHandymanStatus,
    required super.invoiceNo,
    required this.paymentStatus,
    required this.services,
    required super.currency,
    required this.visitingCharges,
    required this.taxType,
    required this.totalAdditionalCharge,
    required this.paymentMethodOfAdditionalCharge,
    required this.paymentStatusOfAdditionalCharge,
    this.fees,
    this.taxBreakdown,
    this.promoCode = '',
    this.promoDiscount = '0',
    this.promoTaxReduction = '0',
    this.multipleDaysBooking,
    super.currencyDecimalPlaces,
  });

  factory HandymanBookingDetail.fromJson(Map<String, dynamic> json) {
    return HandymanBookingDetail(
      id: json['order_id']?.toString() ?? json['id']?.toString() ?? '',
      customer:
          json['customer_name']?.toString() ??
          json['customer']?.toString() ??
          '',
      customerId: json['customer_id']?.toString() ?? '',
      customerNo:
          json['customer_phone']?.toString() ??
          json['customer_no']?.toString() ??
          '',
      customerEmail: json['customer_email']?.toString() ?? '',
      profileImage:
          json['profile_image']?.toString() ??
          json['customer_profile_image']?.toString() ??
          '',
      address: json['address']?.toString() ?? '',
      dateOfService: json['date_of_service']?.toString() ?? '',
      startingTime: json['starting_time']?.toString() ?? '',
      endingTime: json['ending_time']?.toString() ?? '',
      finalTotal: json['final_total']?.toString() ?? '',
      paymentMethod: json['payment_method']?.toString() ?? '',
      orderStatus: json['order_status']?.toString() ?? '',
      handymanStatus: json['handyman_status']?.toString() ?? '',
      isLead:
          json['is_lead'] == true ||
          json['is_lead']?.toString() == '1' ||
          json['is_lead'] == 1,
      latitude: double.tryParse(json['latitude']?.toString() ?? ''),
      longitude: double.tryParse(json['longitude']?.toString() ?? ''),
      remarks: json['remarks']?.toString() ?? '',
      otp: json['otp']?.toString() ?? '',
      total: json['total']?.toString() ?? '',
      taxAmount: json['tax_amount']?.toString() ?? '',
      nextStatuses:
          (json['next_statuses'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      assignedHandymen:
          (json['assigned_handymen'] as List?)
              ?.map(
                (e) => AssignedHandymanModel.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList() ??
          [],
      isPaymentPending:
          json['is_payment_pending'] == true ||
          json['is_payment_pending']?.toString() == '1' ||
          json['is_payment_pending'] == 1,
      workStartedProof: json['work_started_proof'] as List? ?? [],
      workCompletedProof: json['work_completed_proof'] as List? ?? [],
      additionalCharges: json['additional_charges'] as List? ?? [],
      isAtStore:
          json['is_at_store'] == true ||
          json['is_at_store']?.toString() == '1' ||
          json['is_at_store'] == 1,
      transalatedOrderStatus: json['translated_order_status']?.toString() ?? '',
      transalatedHandymanStatus:
          json['translated_handyman_status']?.toString() ?? '',
      invoiceNo: json['invoice_no']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      services:
          (json['services'] as List?)
              ?.map(
                (e) => HandymanBookingServiceItem.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList() ??
          [],
      currency: json['currency']?.toString() ?? '',
      visitingCharges: json['visiting_charges']?.toString() ?? '',
      taxType: json['tax_type']?.toString() ?? '',
      totalAdditionalCharge: json['total_additional_charge']?.toString() ?? '',
      paymentMethodOfAdditionalCharge:
          json['payment_method_of_additional_charge']?.toString() ?? '',
      paymentStatusOfAdditionalCharge:
          json['payment_status_of_additional_charge']?.toString() ?? '',
      fees:
          (json['fees'] as List?)
              ?.map((e) => BookingFee.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      taxBreakdown: json['tax_breakdown'] is Map
          ? TaxBreakdown.fromJson(
              Map<String, dynamic>.from(json['tax_breakdown'] as Map),
            )
          : null,
      promoCode: json['promo_code']?.toString() ?? '',
      promoDiscount: json['promo_discount']?.toString() ?? '0',
      promoTaxReduction: json['promo_tax_reduction']?.toString() ?? '0',
      multipleDaysBooking: MultipleDaysBooking.tryParse(
        json['multiple_days_booking'],
      ),
      currencyDecimalPlaces: int.tryParse(
        json['currency_decimal_places']?.toString() ?? '',
      ),
    );
  }
}
