import '../../app/generalImports.dart';

abstract class FetchServicesState {}

class FetchServicesInitial extends FetchServicesState {}

class FetchServicesInProgress extends FetchServicesState {}

class FetchServicesSuccess extends FetchServicesState {
  final bool isLoadingMoreServices;
  final bool loadingMoreServicesError;
  final List<ServiceModel> services;

  final int total;
  final double minFilterRange;
  final double maxFilterRange;

  FetchServicesSuccess({
    required this.isLoadingMoreServices,
    required this.loadingMoreServicesError,
    required this.services,
    required this.total,
    required this.minFilterRange,
    required this.maxFilterRange,
  });

  FetchServicesSuccess copyWith({
    bool? isLoadingMoreServices,
    bool? loadingMoreServicesError,
    List<ServiceModel>? services,
    int? offset,
    int? total,
    double? minFilterRange,
    double? maxFilterRange,
  }) {
    return FetchServicesSuccess(
      isLoadingMoreServices:
          isLoadingMoreServices ?? this.isLoadingMoreServices,
      loadingMoreServicesError:
          loadingMoreServicesError ?? this.loadingMoreServicesError,
      services: services ?? this.services,
      total: total ?? this.total,
      minFilterRange: minFilterRange ?? this.minFilterRange,
      maxFilterRange: maxFilterRange ?? this.maxFilterRange,
    );
  }
}

class FetchServicesFailure extends FetchServicesState {
  final String errorMessage;

  FetchServicesFailure(this.errorMessage);
}

class FetchServicesCubit extends Cubit<FetchServicesState> {
  final ServiceRepository _serviceRepository = ServiceRepository();

  FetchServicesCubit() : super(FetchServicesInitial());
  double maxFilterRange = 0;
  double minFilterRange = 0;
  double maxDiscountPriceFilterRange = 0;
  double minDiscountPriceFilterRange = 0;

  Future<void> fetchServices({
    String? order,
    String? sort,
    int? serviceId,
  }) async {
    try {
      emit(FetchServicesInProgress());
      final DataOutput<ServiceModel> result = await _serviceRepository
          .fetchService(
            offset: 0,
            order: order,
            sort: sort,
            serviceId: serviceId,
          );

      maxFilterRange = double.parse(result.extraData?.data['max_price'] ?? '0');
      minFilterRange = double.parse(result.extraData?.data['min_price'] ?? '0');
      maxDiscountPriceFilterRange = double.parse(
        result.extraData?.data['max_discount_price'] ?? '0',
      );
      minDiscountPriceFilterRange = double.parse(
        result.extraData?.data['min_discount_price'] ?? '0',
      );

      emit(
        FetchServicesSuccess(
          services: result.modelList,
          isLoadingMoreServices: false,
          loadingMoreServicesError: false,
          total: result.total,
          maxFilterRange: maxFilterRange > maxDiscountPriceFilterRange
              ? maxFilterRange
              : maxDiscountPriceFilterRange,
          minFilterRange: minFilterRange < minDiscountPriceFilterRange
              ? minFilterRange
              : minDiscountPriceFilterRange,
        ),
      );
    } catch (e) {
      emit(FetchServicesFailure(e.toString()));
    }
  }

  Future<void> fetchMoreServices({
    String? order,
    String? sort,
    int? serviceId,
  }) async {
    try {
      if (state is FetchServicesSuccess) {
        if ((state as FetchServicesSuccess).isLoadingMoreServices) {
          return;
        }
        emit(
          (state as FetchServicesSuccess).copyWith(isLoadingMoreServices: true),
        );

        final DataOutput<ServiceModel> result = await _serviceRepository
            .fetchService(
              offset: (state as FetchServicesSuccess).services.length,
              order: order,
              sort: sort,
              serviceId: serviceId,
            );

        final FetchServicesSuccess bookingsState =
            state as FetchServicesSuccess;
        bookingsState.services.addAll(result.modelList);

        emit(
          FetchServicesSuccess(
            isLoadingMoreServices: false,
            loadingMoreServicesError: false,
            services: bookingsState.services,
            // offset: (state as FetchServicesSuccess).offset + UiUtils.limit,
            total: result.total,
            maxFilterRange: (state as FetchServicesSuccess).maxFilterRange,
            minFilterRange: (state as FetchServicesSuccess).minFilterRange,
          ),
        );
      }
    } catch (e) {
      emit(
        (state as FetchServicesSuccess).copyWith(
          isLoadingMoreServices: false,
          loadingMoreServicesError: true,
        ),
      );
    }
  }

  Future<void> searchService(
    String query, {
    String? order,
    String? sort,
    int? serviceId,
  }) async {
    try {
      emit(FetchServicesInProgress());

      final DataOutput<ServiceModel> result = await _serviceRepository
          .fetchService(
            offset: 0,
            searchQuery: query,
            order: order,
            sort: sort,
            serviceId: serviceId,
          );

      emit(
        FetchServicesSuccess(
          services: result.modelList,
          isLoadingMoreServices: false,
          loadingMoreServicesError: false,
          total: result.total,
          maxFilterRange: double.parse(result.extraData?.data['max'] ?? '0'),
          minFilterRange: double.parse(result.extraData?.data['min'] ?? '0'),
        ),
      );
    } catch (e) {
      emit(FetchServicesFailure(e.toString()));
    }
  }

  bool hasMoreServices() {
    if (state is FetchServicesSuccess) {
      return (state as FetchServicesSuccess).services.length <
          (state as FetchServicesSuccess).total;
    }
    return false;
  }

  void addServiceToCubit(ServiceModel model) {
    if (state is FetchServicesSuccess) {
      final List<ServiceModel> services =
          (state as FetchServicesSuccess).services;

      services.insert(0, model);
      emit(
        FetchServicesSuccess(
          services: services,
          isLoadingMoreServices: false,
          loadingMoreServicesError: false,
          total: (state as FetchServicesSuccess).total + 1,
          maxFilterRange: (state as FetchServicesSuccess).maxFilterRange,
          minFilterRange: (state as FetchServicesSuccess).minFilterRange,
        ),
      );
    }
  }

  void editService(ServiceModel updatedModel) {
    if (state is FetchServicesSuccess) {
      final List<ServiceModel> services = List.from(
        (state as FetchServicesSuccess).services,
      );

      final int index = services.indexWhere(
        (service) => service.id == updatedModel.id,
      );

      if (index != -1) {
        services[index] = updatedModel;

        emit(
          FetchServicesSuccess(
            services: services,
            isLoadingMoreServices: false,
            loadingMoreServicesError: false,
            total: (state as FetchServicesSuccess).total,
            maxFilterRange: (state as FetchServicesSuccess).maxFilterRange,
            minFilterRange: (state as FetchServicesSuccess).minFilterRange,
          ),
        );
      }
    }
  }

  void deleteServiceFromCubit(int id) {
    final List<ServiceModel> services =
        (state as FetchServicesSuccess).services;

    services.removeWhere((ServiceModel element) => element.id == id.toString());

    emit(
      FetchServicesSuccess(
        services: services,
        isLoadingMoreServices: false,
        loadingMoreServicesError: false,
        total: (state as FetchServicesSuccess).total - 1,
        minFilterRange: (state as FetchServicesSuccess).minFilterRange,
        maxFilterRange: (state as FetchServicesSuccess).maxFilterRange,
      ),
    );
  }
}
