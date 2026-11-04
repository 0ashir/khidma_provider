import '../../app/generalImports.dart';

abstract class FetchBookingsState {}

class FetchBookingsInitial extends FetchBookingsState {}

class FetchBookingsInProgress extends FetchBookingsState {}

class FetchBookingsSuccess extends FetchBookingsState {
  final bool isLoadingMoreBookings;
  final bool loadingMoreBookingsError;
  final List<BookingsModel> bookings;
  final int offset;
  final int total;

  FetchBookingsSuccess({
    required this.isLoadingMoreBookings,
    required this.loadingMoreBookingsError,
    required this.bookings,
    required this.offset,
    required this.total,
  });

  FetchBookingsSuccess copyWith({
    bool? isLoadingMoreBookings,
    bool? loadingMoreBookingsError,
    List<BookingsModel>? bookings,
    int? offset,
    int? total,
  }) {
    return FetchBookingsSuccess(
      isLoadingMoreBookings:
          isLoadingMoreBookings ?? this.isLoadingMoreBookings,
      loadingMoreBookingsError:
          loadingMoreBookingsError ?? this.loadingMoreBookingsError,
      bookings: bookings ?? this.bookings,
      offset: offset ?? this.offset,
      total: total ?? this.total,
    );
  }
}

class FetchBookingsFailure extends FetchBookingsState {
  final String errorMessage;

  FetchBookingsFailure(this.errorMessage);
}

class FetchBookingsCubit extends Cubit<FetchBookingsState> {
  FetchBookingsCubit() : super(FetchBookingsInitial());
  final BookingsRepository _bookingsRepository = BookingsRepository();

  Future<void> fetchBookings({
    String? status,
    String? customRequestOrder,
    String? fetchBothBookings,
  }) async {
    try {
      emit(FetchBookingsInProgress());

      final DataOutput<BookingsModel> result = await _bookingsRepository
          .fetchBooking(
            offset: 0,
            status: status,
            customRequestOrder: customRequestOrder,
            fetchBothBookings: fetchBothBookings,
          );

      emit(
        FetchBookingsSuccess(
          isLoadingMoreBookings: false,
          loadingMoreBookingsError: false,
          bookings: result.modelList,
          offset: 0,
          total: result.total,
        ),
      );
    } catch (e) {
      emit(FetchBookingsFailure(e.toString()));
    }
  }

  Future<void> fetchMoreBookings({
    String? status,
    String? customRequestOrder,
    String? fetchBothBookings,
  }) async {
    try {
      if (state is FetchBookingsSuccess) {
        if ((state as FetchBookingsSuccess).isLoadingMoreBookings) {
          return;
        }
        emit(
          (state as FetchBookingsSuccess).copyWith(isLoadingMoreBookings: true),
        );
        final DataOutput<BookingsModel> result = await _bookingsRepository
            .fetchBooking(
              offset: (state as FetchBookingsSuccess).offset + UiUtils.limit,
              status: status,
              customRequestOrder: customRequestOrder,
            );

        final FetchBookingsSuccess bookingsState =
            state as FetchBookingsSuccess;
        bookingsState.bookings.addAll(result.modelList);
        emit(
          FetchBookingsSuccess(
            isLoadingMoreBookings: false,
            loadingMoreBookingsError: false,
            bookings: bookingsState.bookings,
            offset: (state as FetchBookingsSuccess).offset + UiUtils.limit,
            total: result.total,
          ),
        );
      }
    } catch (e) {
      emit(
        (state as FetchBookingsSuccess).copyWith(
          isLoadingMoreBookings: false,
          loadingMoreBookingsError: true,
        ),
      );
    }
  }

  void updateBookingDetailsLocally({
    required String bookingID,
    required String bookingStatus,
    required String bookingTranslatedStatus,
    List<dynamic>? listOfUploadedImages,
    List<dynamic>? listOfAdditionalCharged,
  }) {
    if (state is FetchBookingsSuccess) {
      final List<BookingsModel> bookings =
          (state as FetchBookingsSuccess).bookings;
      final int indexInList = bookings.indexWhere((BookingsModel element) {
        return element.id == bookingID;
      });

      if (indexInList == -1) {
        return;
      }

      bookings[indexInList].status = bookingStatus;
      bookings[indexInList].translatedStatus = bookingTranslatedStatus;
      if (bookingStatus == 'started') {
        bookings[indexInList].workStartedProof = listOfUploadedImages ?? [];
      } else if (bookingStatus == 'booking_ended') {
        bookings[indexInList].workCompletedProof = listOfUploadedImages ?? [];
        bookings[indexInList].additionalCharges = listOfAdditionalCharged ?? [];

        double totalAdditionalChargesValue = 0;
        for (var charge in (listOfAdditionalCharged ?? [])) {
          totalAdditionalChargesValue +=
              double.tryParse(charge['charge'].toString()) ?? 0;
        }
        bookings[indexInList].totalAdditionalCharges =
            totalAdditionalChargesValue.toString();

        final double currentFinalTotal =
            double.tryParse(
              bookings[indexInList].finalTotal?.toString().replaceAll(
                    ",",
                    "",
                  ) ??
                  "0",
            ) ??
            0;
        bookings[indexInList].finalTotal =
            (currentFinalTotal + totalAdditionalChargesValue).toString();
      }

      emit((state as FetchBookingsSuccess).copyWith(bookings: bookings));
    }
  }

  bool hasMoreData() {
    if (state is FetchBookingsSuccess) {
      return (state as FetchBookingsSuccess).offset <
          (state as FetchBookingsSuccess).total;
    }
    return false;
  }
}

// Single Booking States

class FetchBookingsDetailsCubit extends FetchBookingsCubit {
  FetchBookingsDetailsCubit() : super();

  Future<void> fetchBookingDetails({required String bookingId}) async {
    try {
      emit(FetchBookingsInProgress());

      //  check we have this booking in our current state
      if (state is FetchBookingsSuccess) {
        final currentBookings = (state as FetchBookingsSuccess).bookings;
        final existingBooking = currentBookings.firstWhere(
          (booking) => booking.id == bookingId,
          orElse: () => BookingsModel(),
        );

        if (existingBooking.id != null && existingBooking.id!.isNotEmpty) {
          emit(
            FetchBookingsSuccess(
              isLoadingMoreBookings: false,
              loadingMoreBookingsError: false,
              bookings: [existingBooking],
              offset: 0,
              total: 1,
            ),
          );
          return;
        }
      }

      // If not found in current state, fetch from API
      final BookingsModel? booking = await _bookingsRepository
          .fetchSingleBookingById(bookingId: bookingId);

      if (booking != null) {
        emit(
          FetchBookingsSuccess(
            isLoadingMoreBookings: false,
            loadingMoreBookingsError: false,
            bookings: [booking],
            offset: 0,
            total: 1,
          ),
        );
      } else {
        emit(FetchBookingsFailure('Booking not found'));
      }
    } catch (e) {
      emit(FetchBookingsFailure(e.toString()));
    }
  }

  /// Get current single booking if available
  BookingsModel? get currentSingleBooking {
    if (state is FetchBookingsSuccess) {
      final bookings = (state as FetchBookingsSuccess).bookings;
      return bookings.isNotEmpty ? bookings.first : null;
    }
    return null;
  }

  /// Check if currently loading a single booking
  bool get isLoadingSingleBooking => state is FetchBookingsInProgress;

  /// Check if there's an error with single booking fetch
  bool get hasSingleBookingError => state is FetchBookingsFailure;
}
