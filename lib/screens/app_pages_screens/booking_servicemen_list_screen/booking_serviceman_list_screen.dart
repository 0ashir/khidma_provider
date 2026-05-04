import '../../../config.dart';

class BookingServicemenListScreen extends StatelessWidget {
  const BookingServicemenListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingServicemenListProvider>(
        builder: (context1, value, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(
              const Duration(microseconds: 20), () => value.onReady(context)),
          child: LoadingComponent(
              child: Scaffold(
                  appBar: AppBarCommon(title: translations!.servicemanList),
                  body: Stack(children: [
                    SingleChildScrollView(
                            child: Column(children: [
                      SearchTextFieldCommon(
                          focusNode: value.searchFocus,
                          controller: value.searchCtrl,
                          onTap: () {
                            value.isTap = true;
                            value.notifyListeners();
                          },
                          suffixIcon: FilterIconCommon(
                            selectedFilter: "0",
                            onTap: () => value
                                .onTapFilter(context), /* selectedFilter: "0" */
                          ),
                          onChanged: (v) => value.onSearchSubmit(context, v),
                          onFieldSubmitted: (v) => value
                              .getServicemenByProviderId(context, search: v)),
                      const VSpace(Sizes.s25),
                      value.searchCtrl.text.isNotEmpty
                          ? Column(
                              children: value.searchList
                                  .asMap()
                                  .entries
                                  .map((e) => BookingServicemenListLayout(
                                          list: value.required,
                                          selectedIndex: value.selectedIndex,
                                          onTapRadio: () =>
                                              value.onTapRadio(e.key, e.value),
                                          data: e.value,
                                          selList: value.selectService,
                                          index: e.key,
                                          onTap: () =>
                                              value.onTapRadio(e.key, e.value))
                                      .inkWell(
                                          onTap: () =>
                                              value.onTapRadio(e.key, e.value)))
                                  .toList())
                          : Column(
                              children: servicemanList
                                  .asMap()
                                  .entries
                                  .map((e) => BookingServicemenListLayout(list: value.required, selectedIndex: value.selectedIndex, onTapRadio: () => value.onTapRadio(e.key, e.value), data: e.value, selList: value.selectService, index: e.key, onTap: () => value.onTapRadio(e.key, e.value)).inkWell(onTap: () => value.onTapRadio(e.key, e.value)))
                                  .toList())
                    ]).padding(
                                horizontal: Insets.i20,
                                top: Insets.i20,
                                bottom: Insets.i110))
                        .height(MediaQuery.of(context).size.height),
                    if (!value.isTap)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ButtonCommon(
                                title: translations!.assignBooking,
                                onTap: () => value.onAssignBooking(context))
                            .paddingOnly(
                                left: Insets.i20,
                                right: Insets.i20,
                                bottom: Insets.i20),
                      )
                  ]))));
    });
  }
}
