import 'package:edemand_partner/app/generalImports.dart';

abstract class FetchCustomPagesState {}

class FetchCustomPagesInitial extends FetchCustomPagesState {}

class FetchCustomPagesInProgress extends FetchCustomPagesState {}

class FetchCustomPagesSuccess extends FetchCustomPagesState {
  final List<CustomPageModel> customPages;
  FetchCustomPagesSuccess({required this.customPages});
}

class FetchCustomPagesFailure extends FetchCustomPagesState {
  final String errorMessage;
  FetchCustomPagesFailure({required this.errorMessage});
}

class FetchCustomPagesCubit extends Cubit<FetchCustomPagesState> {
  final CustomPageRepository customPageRepository;

  FetchCustomPagesCubit(this.customPageRepository)
    : super(FetchCustomPagesInitial());

  Future<void> fetchCustomPages() async {
    try {
      emit(FetchCustomPagesInProgress());
      final List<CustomPageModel> customPages = await customPageRepository
          .getCustomPages();
      emit(FetchCustomPagesSuccess(customPages: customPages));
    } catch (e) {
      emit(FetchCustomPagesFailure(errorMessage: e.toString()));
    }
  }
}
