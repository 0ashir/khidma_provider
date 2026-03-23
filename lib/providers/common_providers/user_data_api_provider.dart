import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:fixit_provider/model/service_add_ons_model.dart';
import 'package:fixit_provider/utils/toast_utils.dart';

import '../../config.dart';

class UserDataApiProvider extends ChangeNotifier {
  // StatisticModel? statisticModel;
  //home statistic
  /*
  homeStatisticApi() async {
    try {
      await apiServices
          .getApi(api.statisticCount, [], isToken: true)
          .then((value) {
        if (value.isSuccess!) {
          statisticModel = StatisticModel.fromJson(value.data);

          if (isServiceman) {
            appArray.serviceManEarningList.asMap().entries.forEach((element) {
              if (element.value['title'] == translations!.totalEarning) {
                element.value["price"] =
                    statisticModel!.totalRevenue!.toString();
              }
              if (element.value['title'] == translations!.totalBooking) {
                element.value["price"] =
                    statisticModel!.totalBookings.toString();
              }
              if (element.value['title'] == translations!.totalService) {
                element.value["price"] =
                    statisticModel!.totalServices.toString();
              }

              log("HOME L${element.value["price"]}");
              notifyListeners();
            });
          } else {
            appArray.earningList.asMap().entries.forEach((element) {
              if (element.value['title'] == translations!.totalEarning) {
                element.value["price"] =
                    statisticModel!.totalRevenue!.toString();
              }
              if (element.value['title'] == translations!.totalBooking) {
                element.value["price"] =
                    statisticModel!.totalBookings.toString();
              }
              if (element.value['title'] == translations!.totalService) {
                element.value["price"] =
                    statisticModel!.totalServices.toString();
              }
              if (element.value['title'] == translations!.totalCategory) {
                element.value["price"] =
                    statisticModel!.totalCategories.toString();
              }
              if (element.value['title'] == translations!.totalServiceman) {
                element.value["price"] =
                    statisticModel!.totalCategories.toString();
              }
              notifyListeners();
            });
          }
          notifyListeners();
        }
      });
    } catch (e) {
      log("EEE homeStatisticApi :$e");
      notifyListeners();
    }
  }
*/

  //get serviceman by provider
  Future<void> getServicemenByProviderId() async {
    try {
      await apiServices.getApi(
          "${api.serviceman}?provider_id=${userModel?.id}", []).then((value) {
        if (value.isSuccess!) {
          List data = value.data;
          // log("data : $data");

          servicemanList = [];
          for (var list in data) {
            if (!servicemanList.contains(ServicemanModel.fromJson(list))) {
              servicemanList.add(ServicemanModel.fromJson(list));
            }
            notifyListeners();
          }
        } else {
          log("API ERROR : ${value.message}");
        }
        notifyListeners();
        // log("serviceManList : ${servicemanList.length}");
      });
    } catch (e) {
      log("ERRROEEE getServicemenByProviderId : $e");
      notifyListeners();
    }
  }

  //provider bank detail
  getBankDetails() async {
    try {
      log("BANK DETAIL");
      await apiServices.getApi(api.bankDetail, [], isToken: true).then((value) {
        bankDetailModel = null;
        log("BACKNK :${value.data}");
        if (value.isSuccess!) {
          log("BACKNK :${value.data}");

          bankDetailModel = BankDetailModel.fromJson(value.data);
          log("BACKNK :${bankDetailModel}");
          notifyListeners();
        } else {
          log("API ERROR : ${value}");
        }
        notifyListeners();
      });
    } catch (e) {
      log("ERRROEEE getBankDetails : $e");
      notifyListeners();
    }
  }

  //all job request list
  getJobRequest(context) async {
    showLoading(context);
    notifyListeners();
    try {
      await apiServices.getApi(api.serviceRequest, [], isToken: true).then((
        value,
      ) {
        if (value.isSuccess!) {
          hideLoading(context);
          List category = value.data;
          log("category :$category");
          jobRequestList = [];
          notifyListeners();
          for (var data in category.reversed.toList()) {
            JobRequestModel jobRequestModel = JobRequestModel.fromJson(data);
            if (!jobRequestList.contains(jobRequestModel)) {
              jobRequestList.add(jobRequestModel);
              notifyListeners();
            }

            notifyListeners();
          }
          notifyListeners();
          log("ajkshdajksd ${jobRequestList.length}");
        }
      });
      notifyListeners();
    } catch (e, s) {
      hideLoading(context);
      log("EEEE AllCategory:::$e=====> $s");
      notifyListeners();
    }
  }

  //provider document detail
  bool getDocument = false;

  Future<void> getDocumentDetails() async {
    getDocument = true;
    try {
      await apiServices
          .getApi("${api.userDocuments}/${userModel!.id}", [], isToken: true)
          .then((value) {
        providerDocumentList = [];
        notUpdateDocumentList = [];
        notifyListeners();
        if (value.isSuccess!) {
          log("message=-=--=-==-getDocumentDetails : ${value.data}");

          for (var data in value.data) {
            providerDocumentList.add(ProviderDocumentModel.fromJson(data));
            notifyListeners();
          }
          notifyListeners();

          for (var d in documentList) {
            int index = providerDocumentList.indexWhere(
              (element) => element.documentId.toString() == d.id.toString(),
            );
            log("index :$index");
            if (index == -1) {
              notUpdateDocumentList.add(d);
            }
            notifyListeners();
          }
          getDocument = false;
          notifyListeners();
        }
        notifyListeners();
      });
    } catch (e, s) {
      getDocument = false;
      log("ERRROEEE getDocumentDetails : $e===> $s");
      notifyListeners();
    }
  }

  //notification list
  bool isNotificationLoader = false;

  getNotificationList() async {
    try {
      isNotificationLoader = true;
      await apiServices.getApi(api.notifications, [], isToken: true).then((
        value,
      ) {
        if (value.isSuccess!) {
          List address = value.data;

          notificationList = [];
          isNotificationLoader = false;
          for (var data in address.toList()) {
            if (!notificationList.contains(NotificationModel.fromJson(data))) {
              notificationList.add(NotificationModel.fromJson(data));
              log("noti : ${value.data}");
            }
            notifyListeners();
          }
        }
      });
    } catch (e, s) {
      isNotificationLoader = false;
      log("EEEE Notification::$e==> $s");
      notifyListeners();
    }
  }

  // provider address List
  Future<void> getAddressList(context) async {
    try {
      await apiServices.getApi(api.address, [], isToken: true).then((value) {
        if (value.isSuccess!) {
          addressList = [];

          List address = value.data['data'];
          log("address :$address");
          final locationVal = Provider.of<NewLocationProvider>(
            context,
            listen: false,
          );
          locationVal.locationList = [];
          for (var data in address.reversed.toList()) {
            if (!addressList.contains(PrimaryAddress.fromJson(data))) {
              addressList.add(PrimaryAddress.fromJson(data));
            }
            notifyListeners();
          }
          for (var d in addressList) {
            var body = {
              "latitude": d.latitude,
              "longitude": d.longitude,
              "type": d.type,
              "address": d.address,
              "country_id": d.countryId,
              "state_id": d.stateId,
              "city": d.city,
              "area": d.area,
              "postal_code": d.code,
              "is_primary": d.isPrimary,
              "role_type": "provider",
              "status": d.status,
              "availability_radius": d.availabilityRadius,
            };

            locationVal.locationList.add(body);
            log(
              "locationVal:::${locationVal.latitudeCtrl.text}//${locationVal.longitudeCtrl.text}///${locationVal.countryCtrl.text}//${locationVal.cityCtrl.text}",
            );

            log("addressList 1:${locationVal.locationList.last}");
          }
          notifyListeners();
        }
      });
    } catch (e) {
      notifyListeners();
      log("EEEE getLocationList: $e");
    }
  }

  //get popular service list
  Future<void> getPopularServiceList({search, isPopular = 1}) async {
    // notifyListeners();
    try {
      String apiUrl = api.providerServices;
      if (search != null) {
        apiUrl = "${api.providerServices}?search=$search";
      } else if (search != null && isPopular == 1) {
        apiUrl =
            "${api.providerServices}?search=$search&popular_service=$isPopular";
      }
      /* else {
        apiUrl = "${api.providerServices}?popular_service=$isPopular";
      } */

      await apiServices.getApi(apiUrl, [], isToken: true).then((value) {
        popularServiceList = [];
        if (value.isSuccess!) {
          List service = value.data;
          notifyListeners();
          for (var data in service.reversed.toList()) {
            if (!popularServiceList.contains(Services.fromJson(data))) {
              popularServiceList.add(Services.fromJson(data));
              notifyListeners();
            }
            notifyListeners();
          }
        }
      });
    } catch (e) {
      log("EEEE getPopularServiceList: $e");
      notifyListeners();
    }
  }

  //update active status of service
  updateActiveStatusService(
    BuildContext context,
    id,
    bool val,
    int index,
  ) async {
    // Optimistically update UI
    int newStatus = val ? 1 : 0;
    popularServiceList[index].status = newStatus;
    notifyListeners(); // update UI instantly

    var body = {"status": newStatus.toString(), "_method": "PUT"};
    dio.FormData formData = dio.FormData.fromMap(body);

    try {
      final value = await apiServices.postApi(
        "${api.service}/$id",
        formData,
        isToken: true,
      );

      if (value.isSuccess!) {
        showSuccessToast(context, value.message);
        // Optionally refresh list if needed
        Provider.of<UserDataApiProvider>(
          context,
          listen: false,
        ).getPopularServiceList();
      } else {
        // Revert status on failure
        popularServiceList[index].status = newStatus == 1 ? 0 : 1;
        notifyListeners();

        showErrorToast(context, value.message);
      }
    } catch (e) {
      // Revert status on error
      popularServiceList[index].status = newStatus == 1 ? 0 : 1;
      notifyListeners();

      showErrorToast(context, "Failed to update status. Please try again.");
      /* snackBarMessengers(context,
          color: appColor(context).appTheme.red,
          message: "Failed to update status. Please try again."); */
      log("Error updateActiveStatusService: $e");
    }
  }

  //delete Address
  deleteAddress(context, id, {isBack = false}) async {
    showLoading(context);
    route.pop(context);

    log("DELETE ADDRESSS ::::");

    try {
      await apiServices.deleteApi("${api.address}/$id", {}, isToken: true).then(
        (value) {
          hideLoading(context);
          notifyListeners();
          if (value.isSuccess!) {
            final common = Provider.of<UserDataApiProvider>(
              context,
              listen: false,
            );
            common.getAddressList(context);
            final delete = Provider.of<DeleteDialogProvider>(
              context,
              listen: false,
            );
            delete.onResetPass(
              context,
              language(context, translations!.hurrayLocationDelete),
              language(context, translations!.okay),
              () {
                route.pop(context);
              },
              title: translations!.deleteSuccessfully,
            );
            final userApi = Provider.of<UserDataApiProvider>(
              context,
              listen: false,
            );
            userApi.getAddressList(context);
          } else {
            snackBarMessengers(
              context,
              color: appColor(context).appTheme.red,
              message: value.message,
            );
          }
        },
      );
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      log("EEEE deleteAddress : $e");
    }
  }

  //get service package list
  bool isPackageLoader = false;

  Future<void> getServicePackageList({search}) async {
    isPackageLoader = true;
    try {
      String apiUrl = api.servicePackages;
      if (search != null) {
        apiUrl = "${api.servicePackages}?search=$search";
      } else {
        apiUrl = api.servicePackages;
      }

      await apiServices.getApi(apiUrl, [], isToken: true).then((value) {
        servicePackageList = [];
        if (value.isSuccess!) {
          List service = value.data;
          log("VALUE :${value.data}");
          for (var data in service.reversed.toList()) {
            // log("VALUE :${data['provider_id']}");
            if (!servicePackageList.contains(
              ServicePackageModel.fromJson(data),
            )) {
              servicePackageList.add(ServicePackageModel.fromJson(data));
            }
            // log("servicePackageList::${servicePackageList}");
            isPackageLoader = false;
            notifyListeners();
          }
          isPackageLoader = false;
          notifyListeners();
        }
      });
    } catch (e) {
      isPackageLoader = false;
      log("EEEE getServicePackageList: $e");
      notifyListeners();
    }
  }

  Future<void> getServiceAddOnsList() async {
    try {
      await apiServices.getApi(api.additionalService, [], isToken: true).then((
        value,
      ) {
        serviceAddOns = [];
        if (value.isSuccess!) {
          // log("AKSDJASJKLDFA ${value.data}");
          // serviceAddOns.add(ServiceAddOnsModel.fromJson(value.data));

          // log("serviceAddOns $serviceAddOns");

          List addons = value.data;
          log("VALUE :${value.data}");
          for (var data in addons.reversed.toList()) {
            // log("VALUE :${data['provider_id']}");
            if (!serviceAddOns.contains(ServiceAddOnsModel.fromJson(data))) {
              serviceAddOns.add(ServiceAddOnsModel.fromJson(data));
            }
            // log("servicePackageList::${servicePackageList}");
            isPackageLoader = false;
            notifyListeners();
          }

          notifyListeners();
        }
      });
    } catch (e, s) {
      log("EEEE getServiceAddOnsList: $e====$s");
      notifyListeners();
    }
  }

  //get all service list
  Future<void> getAllServiceList({search}) async {
    // notifyListeners();
    // log("EEEE getAllServiceList: azdasd");
    try {
      String apiUrl = api.providerServices;
      if (search != null) {
        apiUrl = "${api.providerServices}?search=$search";
      } else {
        apiUrl = api.providerServices;
      }

      await apiServices.getApi(apiUrl, [], isToken: true).then((value) {
        allServiceList = [];
        if (value.isSuccess!) {
          List service = value.data;
          // log("EEEE getAllServiceList: $service");
          for (var data in service.reversed.toList()) {
            if (!allServiceList.contains(Services.fromJson(data))) {
              allServiceList.add(Services.fromJson(data));
            }

            log("message");

            notifyListeners();
          }
          // log("EEEE getAllServiceList: $allServiceList");
        }
      });
    } catch (e, s) {
      log("EEEE getAllServiceList: $e ===> $s");
      notifyListeners();
    }
  }

  bool isLoadingForBookingHistory = false;
  bool isBookingLoading = false;
  int bookingPage = 1;

  //booking history list
  // Future getBookingHistory(BuildContext context,
  //     {String? search, bool isLoadMore = false}) async {
  //   final booking = Provider.of<BookingProvider>(context, listen: false);
  //   // final bokkingProvider = Provider.of<BookingProvider>(context,listen: false);
  //   // Early return if no more data or already loading more
  //   if (isLoadMore && (!booking.hasMoreData || booking.isLoadingMore)) return;

  //   // Set loading states
  //   if (isLoadMore) {
  //     booking.setLoadingMore(true);
  //   } else {
  //     booking.resetPagination(
  //         clearList: true); // ✅ only clear when not loading more
  //     isBookingLoading = true;
  //     isLoadingForBookingHistory = true;
  //   }
  //   notifyListeners();

  //   try {
  //     // Prepare query parameters
  //     Map<String, dynamic> data = {
  //       "page": booking.currentPage.toString(),
  //       "paginate": "5",
  //       if (search != null && search.isNotEmpty) "search": search,
  //     };

  //     // Show loading only for initial fetch
  //     if (!isLoadMore) showLoading(context);

  //     // Make API call
  //     final response = await apiServices.getApi(
  //       "${api.booking}?page=${(bookingPage).toString() /* booking.currentPage.toString() */ /*  + 1.toString() */}?paginate=5",
  //       data,
  //       isToken: true,
  //     );

  //     if (response.isSuccess!) {
  //       bookingPage = booking.currentPage + 1;
  //       notifyListeners();
  //       log("message PAGE FOR BOOKING : $bookingPage");
  //       booking.resetPagination();
  //       List<BookingModel> newBookings = (response.data as List)
  //           .map((json) => BookingModel.fromJson(json))
  //           .toList();
  //       booking.isLoadingForBookingHistory = false;
  //       // Update booking list
  //       if (isLoadMore || booking.bookingList.isNotEmpty) {
  //         booking.bookingList.addAll(newBookings);
  //       } else {
  //         booking.bookingList = newBookings;
  //       }

  //       // Update pagination state
  //       // booking.currentPage++;
  //       booking.hasMoreData =
  //           newBookings.length == 5; // Assume full page means more data exists

  //       // Save to local storage
  //       await saveBookingsToLocal(booking.bookingList);
  //     } else {
  //       booking.isLoadingForBookingHistory = false;
  //       // Handle unsuccessful response
  //       if (!isLoadMore) booking.bookingList = [];
  //       booking.hasMoreData = false;
  //       if (context.mounted) {
  //         Fluttertoast.showToast(
  //             msg: "Failed to fetch bookings", backgroundColor: Colors.red);
  //         // ScaffoldMessenger.of(context).showSnackBar(
  //         //   const SnackBar(content: Text("Failed to fetch bookings")),
  //         // );
  //       }
  //     }
  //   } catch (e, s) {
  //     booking.isLoadingForBookingHistory = false;
  //     debugPrint("Error in getBookingHistory: $e\n$s");
  //     if (!isLoadMore) booking.bookingList = [];
  //     booking.hasMoreData = false;
  //     if (context.mounted) {
  //       Fluttertoast.showToast(
  //           msg: "An error occurred", backgroundColor: Colors.red);
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   const SnackBar(content: Text("An error occurred")),
  //       // );
  //     }
  //   } finally {
  //     isBookingLoading = false;
  //     isLoadingForBookingHistory = false;
  //     booking.setLoadingMore(false);
  //     booking.setInitialLoading(false);
  //     if (context.mounted && !isLoadMore) hideLoading(context);
  //     booking.widget1Opacity = 1;
  //     notifyListeners();
  //     booking.notifyListeners();
  //   }
  // }

  Future getBookingHistory(
    BuildContext context, {
    String? search,
    bool isLoadMore = false,
    String? timeFilter,
  }) async {
    final booking = Provider.of<BookingProvider>(context, listen: false);

    if (isLoadMore && (!booking.hasMoreData || booking.isLoadingMore)) return;

    if (isLoadMore) {
      booking.setLoadingMore(true);
    } else {
      booking.resetPagination(clearList: true);
      isBookingLoading = true;
      isLoadingForBookingHistory = true;
    }

    notifyListeners();

    try {
      Map<String, dynamic> queryParams = {
        // "page": bookingPage.toString(),
        // "paginate": "5",
        if (search != null && search.isNotEmpty) "search": search,
      };

      if (!isLoadMore) showLoading(context);

      log("message FOR QUERY PARAMS : $queryParams");

      final response = await apiServices.getApi(
        timeFilter != null
            ? "${api.booking}?time_filter=${timeFilter.toLowerCase()}"
            : "${api.booking}",
        queryParams,
        isToken: true,
      );

      if (response.isSuccess!) {
        log("message RESPONSE FOR BOOKING : ${response.data}");
        List<BookingModel> newBookings = (response.data as List)
            .map((json) => BookingModel.fromJson(json))
            .toList();

        if (isLoadMore) {
          booking.bookingList.addAll(newBookings); // ✅ Append new data
          notifyListeners();
        } else {
          booking.bookingList.clear();
          booking.bookingList = newBookings; // ✅ Replace on initial load
          notifyListeners();
        }

        //   log("message FOR BOOKING : ${booking.bookingList}");

        booking.hasMoreData =
            newBookings.length == 5; // Check if more data exists

        if (booking.hasMoreData) {
          bookingPage++; // ✅ Increment only if more data
        }
        isLoadingForBookingHistory = false;
        booking.isLoadingForBookingHistory = false;
        notifyListeners();
        await saveBookingsToLocal(booking.bookingList);
      } else {
        if (!isLoadMore) booking.bookingList = [];
        booking.hasMoreData = false;
        if (context.mounted) {
          showErrorToast(context, "Failed to fetch bookings");
        }
        isLoadingForBookingHistory = false;
        booking.isLoadingForBookingHistory = false;
        notifyListeners();
      }
    } catch (e, s) {
      if (!isLoadMore) booking.bookingList = [];
      booking.hasMoreData = false;
      debugPrint("Error in getBookingHistory: $e\n$s");
      if (context.mounted) {
  
        showErrorToast(context, "An error occurred");
      }
      isLoadingForBookingHistory = false;
      booking.isLoadingForBookingHistory = false;
      notifyListeners();
    } finally {
      isBookingLoading = false;
      isLoadingForBookingHistory = false;
      booking.isLoadingForBookingHistory = false;
      booking.setLoadingMore(false);
      booking.setInitialLoading(false);
      if (context.mounted && !isLoadMore) hideLoading(context);
      booking.widget1Opacity = 1;
      notifyListeners();
      booking.notifyListeners();
    }
  }

  //   Future<void> getBookingHistory(BuildContext context,
  //       {String? search, bool isLoadMore = false}) async
  //   {
  //     final booking = Provider.of<BookingProvider>(context, listen: false);
  //
  //     if (isLoadMore && !booking.hasMoreData) return;
  //
  //     if (!isLoadMore) {
  //       booking.resetPagination();
  //     }
  //
  //     Map<String, dynamic> data = {};
  //     if (search != null) {
  //       data["search"] = search;
  //     }
  //
  //     data["page"] = booking.currentPage.toString();
  //     var paginate = data["paginate"] = "5";
  //
  //     isLoadingForBookingHistory = true;
  //     notifyListeners();
  //     DateTime startTime = DateTime.now();
  //
  //     try {
  //       final response = await apiServices
  //           .getApi("${api.booking}?paginate=5", data, isToken: true);
  //       // ✅ End time after API call
  //       DateTime endTime = DateTime.now();
  //
  //       // ✅ Calculate duration
  //       Duration apiDuration = endTime.difference(startTime);
  //       // log("API call took: ${apiDuration.inSeconds} seconds");
  //       if (response.isSuccess!) {
  //         log("message apiDuration : ${apiDuration.inSeconds}");
  //         log("message apiDuration AAA: ${apiDuration.inSeconds}");
  //         List<BookingModel> newBookings = (response.data as List)
  //             .map((json) => BookingModel.fromJson(json))
  //             .toList();
  //
  //         if (newBookings.isNotEmpty) {
  //           if (isLoadMore) {
  //             booking.bookingList.addAll(newBookings);
  //           } else {
  //             booking.bookingList = newBookings;
  //           }
  //           booking.currentPage++;
  //           isLoadingForBookingHistory = false;
  //           // ✅ Save bookings to SharedPreferences
  //           await saveBookingsToLocal(booking.bookingList);
  //         } else {
  //           booking.hasMoreData = false;
  //         }
  //         // log("userApi.getBookingHistory(context);");
  //       } else if (response.message.toLowerCase() == "unauthenticated.") {
  //         SharedPreferences pref = await SharedPreferences.getInstance();
  //
  //         final dash = Provider.of<DashboardProvider>(context, listen: false);
  //         dash.selectIndex = 0;
  //         dash.notifyListeners();
  //         pref.clear();
  //         userModel = null;
  //         // Clear other session data...
  //         notifyListeners();
  //         route.pushNamedAndRemoveUntil(context, routeName.intro);
  //       } else {
  // isLoadingForBookingHistory =false;
  //         snackBarMessengers(context, message: response.message);
  //       }
  //     } catch (e, s) {
  //       log("Error fetching booking history: $s");
  //       log("Error fetching booking history: $e======>$s");
  //     } finally {
  //       isLoadingForBookingHistory = false;
  //       notifyListeners();
  //     }
  //   }

  /// Save bookings to SharedPreferences
  Future<void> saveBookingsToLocal(List<BookingModel> bookings) async {
    final prefs = await SharedPreferences.getInstance();
    String bookingsJson = jsonEncode(bookings.map((b) => b.toJson()).toList());
    await prefs.setString('booking_history', bookingsJson);
  }

  Future<void> loadBookingsFromLocal(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final booking = Provider.of<BookingProvider>(context, listen: false);

    String? bookingsJson = prefs.getString('booking_history');
    if (bookingsJson != null) {
      List<dynamic> decodedList = jsonDecode(bookingsJson);
      List<BookingModel> storedBookings =
          decodedList.map((json) => BookingModel.fromJson(json)).toList();

      booking.bookingList = storedBookings;
      // log("booking.bookingList::${booking.bookingList}");
      notifyListeners();
    }
  }

  /*
  //booking history list
  getBookingHistory(context, {search}) async {
    final booking = Provider.of<BookingProvider>(context, listen: false);
    dynamic data;
    if (search != null) {
      data = {"search": search};
    } else if (booking.selectedCategoryList.isNotEmpty &&
        booking.rangeStart != null &&
        booking.statusIndex != null) {
      data = {
        "status": bookingStatusList[booking.statusIndex!].name,
        "start_date": booking.rangeStart,
        "end_date": booking.rangeEnd,
        "category_ids": booking.selectedCategoryList,
        "search": search
      };
    } else if (booking.selectedCategoryList.isNotEmpty &&
        booking.rangeStart != null) {
      data = {
        "start_date": booking.rangeStart,
        "end_date": booking.rangeEnd,
        "category_ids": booking.selectedCategoryList,
        "search": search
      };
    } else if (booking.selectedCategoryList.isNotEmpty) {
      data = {"category_ids": booking.selectedCategoryList};
    } else if (booking.selectedCategoryList.isNotEmpty &&
        booking.statusIndex != null) {
      data = {
        "status": bookingStatusList[booking.statusIndex!].name,
        "category_ids": booking.selectedCategoryList,
        "search": search
      };
    } else if (booking.statusIndex != null) {
      data = {
        "status": bookingStatusList[booking.statusIndex!].name,
      };
    } else if (booking.rangeStart != null && booking.statusIndex != null) {
      data = {
        "status": bookingStatusList[booking.statusIndex!].name,
        "start_date": booking.rangeStart,
        "end_date": booking.rangeEnd,
        "search": search
      };
    } else if (booking.rangeStart != null) {
      data = {
        "start_date": booking.rangeStart.toString(),
        "end_date": booking.rangeEnd.toString(),
        // "search": search ?? ""
      };
    }
    isLoadingForBookingHistory = false; // showLoading(context);

    // Start measuring API response time
    DateTime startTime = DateTime.now();
    try {
      // showLoading(context);
      isLoadingForBookingHistory =true;
      log("BODU :$data");
      await apiServices
          .getApi("${api.booking}?paginate=5", data ?? [], isToken: true)
          .then((value) {
        DateTime endTime = DateTime.now();
        Duration responseTime = endTime.difference(startTime);

        log("API Response Time: ${responseTime.inSeconds} ms");
        // log("value.isSuccess!:${api.booking}?paginate=5");
        if (value.isSuccess!) {
          isLoadingForBookingHistory = false;
          // hideLoading(context);
          booking.bookingList = [];
          for (var data in value.data) {
            if (!booking.bookingList.contains(BookingModel.fromJson(data))) {
              booking.bookingList.add(BookingModel.fromJson(data));
            }
            booking.notifyListeners();
          }
          if (booking.bookingList.isEmpty) {
            booking.isSearchData = true;
            // booking.searchCtrl.text = "";
            booking.notifyListeners();
          } else {
            booking.isSearchData = false;
          }
          booking.notifyListeners();
        }
        isLoadingForBookingHistory = false;
        // hideLoading(context);
      });

      log("STATYS BIIk L ${booking.bookingList.length}");
    } catch (e, s) {
      // hideLoading(context);
      isLoadingForBookingHistory = false;
      log("EEEE getBookingHistory ::$e");
      log("EEEE getBookingHistory ::$s");
      notifyListeners();
    }
  }*/

  //getWallet list
  Future<void> getWalletList(context) async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    try {
      await apiServices
          .getApi(api.walletProvider, [], isToken: true, isData: true)
          .then((value) {
        //log("WALLLL :${value.data} //${value.message}");
        log("walletProvider Provider::${walletProvider.wallet}");
        if (value.isSuccess!) {
          walletProvider.providerWalletModel = ProviderWalletModel.fromJson(
            value.data,
          );
          walletProvider.balance = double.parse(
            value.data['balance'].toString(),
          );
          notifyListeners();
          walletProvider.notifyListeners();
        } else {}
      });
    } catch (e) {
      log("ERRROEEE getWalletList : $e");
      notifyListeners();
    }
  }

  //getWallet list
  getServicemanWalletList(context) async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    walletProvider.isLoadingForWallet = true;
    try {
      await apiServices
          .getApi(api.walletServiceman, [], isToken: true, isData: true)
          .then((value) {
        // log("WALLLL :${value.data} //${value.message}");

        if (value.isSuccess!) {
          walletProvider.isLoadingForWallet = false;
          walletProvider.servicemanWalletModel =
              ServicemanWalletModel.fromJson(value.data);

          walletProvider.balance = double.parse(
            value.data['balance'].toString(),
          );
          notifyListeners();
          walletProvider.notifyListeners();
        } else {
          snackBarMessengers(context, message: value.message);
          walletProvider.isLoadingForWallet = false;
        }
      });
    } catch (e) {
      walletProvider.isLoadingForWallet = true;
      log("ERRROEEE getWalletList : $e");
      notifyListeners();
    }
  }

  //statistic detail chart list
  /* statisticDetailChart() async {
    try {
      await apiServices
          .getApi(api.homeChart, [], isToken: true, isData: true)
          .then((value) {
        if (value.isSuccess!) {
          revenueModel = RevenueModel.fromJson(value.data);
          notifyListeners();
          appArray.weekData = [];
          appArray.monthData = [];
          appArray.yearData = [];
          for (var d in revenueModel!.weekdayRevenues) {
            appArray.weekData.add(ChartData(x: d.x, y: d.y!));
          }
          for (var d in revenueModel!.monthlyRevenues) {
            appArray.monthData.add(ChartData(x: d.x, y: d.y!));
          }
          for (var d in revenueModel!.yearlyRevenues) {
            appArray.yearData.add(ChartData(x: d.x, y: d.y!));
          }
          notifyListeners();
        }
      });
    } catch (e) {
      log("ERRROEEE statisticDetailChart : $e");
      notifyListeners();
    }
  }*/

  //total earning by category
  bool isEarningLoader = false;

  getTotalEarningByCategory(context) async {
    try {
      isEarningLoader = true;
      await apiServices
          .getApi(
        api.getTotalEarningByCategory,
        [],
        isToken: true,
        isData: true,
      )
          .then((value) {
        if (value.isSuccess!) {
          isEarningLoader = false;
          log("VALUES ::${value.data} // ${value.message}");
          appArray.earningChartData.clear();
          totalEarningModel = TotalEarningModel.fromJson(value.data);
          notifyListeners();
          totalEarningModel!.categoryEarnings!.asMap().entries.forEach((d) {
            appArray.earningChartData.add(
              ChartDataColor(
                d.value.categoryName!,
                d.value.percentage!,
                d.key == 0
                    ? appColor(context).appTheme.primary
                    : d.key == 1
                        ? const Color(0xFF7482FD)
                        : d.key == 2
                            ? const Color(0xFF949FFC)
                            : d.key == 3
                                ? const Color(0xFFB5BCFA)
                                : const Color(0xFFB5BCFA),
              ),
            );
          });

          notifyListeners();
        } else {
          isEarningLoader = false;
          notifyListeners();
        }
      });
    } catch (e) {
      isEarningLoader = false;
      log("EEEE getTotalEarningByCategory: $e");
      notifyListeners();
    }
  }

  bool isLodingForCommissionHistory = false;

  //commission history
  bool isCommissionLoader = false;

  commissionHistory(isCompletedMe, context) async {
    try {
      isCommissionLoader = true;
      await apiServices
          .getApi(
        "${api.commissionHistory}?completed_by_me=${isCompletedMe == true ? 1 : 0}",
        [],
        isData: true,
        isToken: true,
      )
          .then((value) async {
        if (value.isSuccess!) {
          isCommissionLoader = false;
          commissionList = null;

          commissionList = CommissionHistoryModel.fromJson(value.data);
          notifyListeners();
          log("commissionList ${value.data}");
        }
        notifyListeners();
      });
    } catch (e) {
      isCommissionLoader = false;
      log("EEEE commissionHistory :$e");
      isLodingForCommissionHistory = false;
      notifyListeners();
    }
  }

  //category list
  Future<void> getCategory({search}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getInt("UserId");
    // notifyListeners();
    log("userModel!.id::${userModel?.id}///${pref.getInt("UserId")}");
    try {
      String apiUrl = "${api.category}?providerId=${pref.getInt("UserId")}";
      if (search != null) {
        apiUrl =
            "${api.category}?providerId=${pref.getInt("UserId")}&search=$search";
      } else {
        apiUrl = "${api.category}?providerId=${pref.getInt("UserId")}";
      }
      log("apiUrl::$apiUrl");
      await apiServices.getApi(apiUrl, [], isToken: true).then((value) {
        // if (value.isSuccess!) {
        categoryList = [];
        List category = value.data;
        log("categorycategory :${category}");
        for (var data in category.reversed.toList()) {
          if (!categoryList.contains(CategoryModel.fromJson(data))) {
            categoryList.add(CategoryModel.fromJson(data));
          }
          notifyListeners();
        }
        // }
      });
    } catch (e) {
      log("EEEE categorycategory $e");
      notifyListeners();
    }
  }

  commonCallApi(context) async {
    /*   final provider = Provider.of<CommonApiProvider>(context); */
    await Future.wait([
      Future(() {
        // homeStatisticApi();
        final userApi = Provider.of<CommonApiProvider>(context, listen: false);
        userApi.getDashBoardApi(context);
        userApi.selfApi(context);
        // getCategory();
        /* provider.selfApi(context); */
        // statisticDetailChart();
        // getAllServiceList();
        // getPopularServiceList();
        // getDocumentDetails();
        // getBankDetails();
        // getJobRequest();
        // if (!isFreelancer) {
        //   getServicemenByProviderId();
        //
        // }
        // getServicemenByProviderId();
        // getServicePackageList();
        // getNotificationList();
        // getAddressList(context);
        // getBookingHistory(context);

        getWalletList(context);
      }),
    ]);

    // getTotalEarningByCategory();
    // getMyReview();
    // commissionHistory(false, context);
    if (isServiceman) {
      getServicemanWalletList(context);
    }
    // if (userModel != null) {
    //   getProviderById(context, userModel!.providerId);
    // }
    // }
  }

  //get provider detail id
  getProviderById(context, id) async {
    try {
      await apiServices.getApi("${api.provider}/$id", [], isData: true).then((
        value,
      ) {
        if (value.isSuccess!) {
          provider = ProviderModel.fromJson(value.data);
          notifyListeners();
        }
      });
    } catch (e) {
      log("ERRROEEE getProviderById : $e");
      notifyListeners();
    }
  }
}
