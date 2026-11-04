import 'package:edemand_partner/app/generalImports.dart';
import 'package:edemand_partner/data/repository/jobRequestRepository.dart';

abstract class FetchJobRequestState {}

class FetchJobRequestInitial extends FetchJobRequestState {}

class FetchJobRequestInProgress extends FetchJobRequestState {}

class FetchJobRequestSuccess extends FetchJobRequestState {
  final bool isLoadingMoreJobRequest;
  final bool loadingMoreJobRequestError;
  final List<JobRequestModel> jobRequest;
  final int offset;
  final int total;

  FetchJobRequestSuccess({
    required this.isLoadingMoreJobRequest,
    required this.loadingMoreJobRequestError,
    required this.jobRequest,
    required this.offset,
    required this.total,
  });

  FetchJobRequestSuccess copyWith({
    bool? isLoadingMoreJobRequest,
    bool? loadingMoreJobRequestError,
    List<JobRequestModel>? jobRequest,
    int? offset,
    int? total,
  }) {
    return FetchJobRequestSuccess(
      isLoadingMoreJobRequest:
          isLoadingMoreJobRequest ?? this.isLoadingMoreJobRequest,
      loadingMoreJobRequestError:
          loadingMoreJobRequestError ?? this.loadingMoreJobRequestError,
      jobRequest: jobRequest ?? this.jobRequest,
      offset: offset ?? this.offset,
      total: total ?? this.total,
    );
  }
}

class FetchJobRequestFailure extends FetchJobRequestState {
  final String errorMessage;

  FetchJobRequestFailure(this.errorMessage);
}

class FetchJobRequestCubit extends Cubit<FetchJobRequestState> {
  final _jonRequestRepository = jobRequestRepository();

  FetchJobRequestCubit() : super(FetchJobRequestInitial());

  Future<void> FetchJobRequest({required String? jobType, String? id}) async {
    try {
      emit(FetchJobRequestInProgress());

      final DataOutput<JobRequestModel> result = await _jonRequestRepository
          .fetchCustomJobRequest(offset: 0, jobType: jobType, id: id);

      emit(
        FetchJobRequestSuccess(
          jobRequest: result.modelList,
          isLoadingMoreJobRequest: false,
          loadingMoreJobRequestError: false,
          offset: 0,
          total: result.total,
        ),
      );
    } catch (e) {
      emit(FetchJobRequestFailure(e.toString()));
    }
  }

  Future<void> fetchMoreJobRequest(String? jobType) async {
    try {
      if (state is FetchJobRequestSuccess) {
        if ((state as FetchJobRequestSuccess).isLoadingMoreJobRequest) {
          return;
        }
        emit(
          (state as FetchJobRequestSuccess).copyWith(
            isLoadingMoreJobRequest: true,
          ),
        );

        final DataOutput<JobRequestModel> result = await _jonRequestRepository
            .fetchCustomJobRequest(
              offset: (state as FetchJobRequestSuccess).offset + UiUtils.limit,
              jobType: jobType,
            );

        final FetchJobRequestSuccess jobRquestState =
            state as FetchJobRequestSuccess;
        jobRquestState.jobRequest.addAll(result.modelList);

        emit(
          FetchJobRequestSuccess(
            isLoadingMoreJobRequest: false,
            loadingMoreJobRequestError: false,
            jobRequest: jobRquestState.jobRequest,
            offset: (state as FetchJobRequestSuccess).offset + UiUtils.limit,
            total: result.total,
          ),
        );
      }
    } catch (e) {
      emit(
        (state as FetchJobRequestSuccess).copyWith(
          isLoadingMoreJobRequest: false,
          loadingMoreJobRequestError: true,
        ),
      );
    }
  }

  bool hasMoreJobRequest() {
    if (state is FetchJobRequestSuccess) {
      return (state as FetchJobRequestSuccess).offset <
          (state as FetchJobRequestSuccess).total;
    }
    return false;
  }

  Future<void> deleteOpenJobRequest(String? id, String? jobType) async {
    if (state is FetchJobRequestSuccess) {
      final List<JobRequestModel> currentAddress =
          (state as FetchJobRequestSuccess).jobRequest;
      currentAddress.removeWhere((element) => element.id == id);

      emit(
        FetchJobRequestSuccess(
          isLoadingMoreJobRequest: false,
          loadingMoreJobRequestError: false,
          jobRequest: List<JobRequestModel>.from(currentAddress),
          offset: 0,
          total: (state as FetchJobRequestSuccess).total,
        ),
      );
    }
  }
}

class FetchJobRequestAppliedJobCubit extends FetchJobRequestCubit {
  FetchJobRequestAppliedJobCubit() : super();
}
