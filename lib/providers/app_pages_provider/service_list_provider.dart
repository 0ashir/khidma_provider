import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:fixit_provider/utils/toast_utils.dart';
import '../../config.dart';
import '../../model/category_service_model.dart';
import '../../services/environment.dart';

class ServiceListProvider with ChangeNotifier {
  List<CategoryModel> newCategoryList = [];
  int selectedIndex = 0;
  double widget1Opacity = 0.0;
  int tabIndex = 0;
  List<Services> serviceList = [];
  List<CategoryService> cachedServiceList = [];
  List<Widget> serviceWidgetList = [];
  bool isLoading = false;
  List dataLocalList = [];
  List<CategoryServicesCategory> demoList = [
    CategoryServicesCategory(
        id: 0, title: 'All', isChild: false, servicesCount: 0, media: [])
  ];
  List<Service> serviceDemo = [];
  CategoryServices? categoryService;
  bool isAlert = false;
  bool isProviderLoading = false;
  bool isLoader = false;
  var dioo = Dio();

  Future<void> getCategoryService(context,
      {int? id, bool? isAllService = false}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final zoneId = pref.getString(session.zoneIds);
    String? token = pref.getString(session.accessToken);

    final lang = Provider.of<LanguageProvider>(context, listen: false);

    log("message=-=-=--=-=-ZONE IDS ${isAllService}");

    try {
      demoList = [];
      isLoading = true;
      notifyListeners();
      // ${pref.getString(session.zoneIds) ?? 1}
      // Log the API URL for debugging
      final url = isAllService == true
          ? '${api.categoryService}?providerIds=${userModel!.id}'
          : '${api.categoryService}?category_id=${id}&providerIds=${userModel!.id}';
      log('Fetching category service: $url');

// Make the API call using Dio
      final response = await dioo.get(
        url,
        options: Options(
            headers: headersToken(
          token,
          localLang: lang.selectedLocaleService,
          isLang: false,
        )),
      );

// Check if the response is successful
      if (response.statusCode == 200) {
        log("CATEGORY SERVICE DATA : ${response.data}");
        // Parse the response data into the CategoryServices model
        categoryService = CategoryServices.fromJson(response.data);

        // Initialize demoList as empty

        // Filter child categories
        final validCategories = categoryService?.categories
            /*  ?.where((category) => category.isChild == true) */
            ?.toList();

        // Only add "All" category if there are valid subcategories
        if (validCategories != null && validCategories.isNotEmpty) {
          demoList.add(
            CategoryServicesCategory(
                id: 0,
                title: 'All',
                isChild: false,
                servicesCount: 0,
                media: []),
          );

          demoList.addAll(validCategories);
          log('Filtered categories added: ${validCategories.map((c) => c.title).toList()}');
          log("First sub-category: ${demoList[1].title}");
        } else {
          isLoading = false;
          log('No valid child categories found. Skipping "All" category.');
        }
        isLoading = false;
        log('Category service fetched successfully: ${categoryService!.categories!.map((c) => c.title).toList()}');
      } else {
        log('Failed to fetch category service: ${response.statusCode}');
        showErrorToast(context, response.statusMessage!);
        throw Exception(
            'Failed to fetch category service: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      isLoading = false;
      log('Error fetching category service: $e',
          error: e, stackTrace: stackTrace);
      throw e;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

//   Future<void> getCategoryService(context,
//       {int? id, bool? isAllService = false}) async
//   {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     final zoneId = pref.getString(session.zoneIds);
//     String? token = pref.getString(session.accessToken);
//     log("message=-=-=--=-=-ZONE IDS ${isAllService}");
//     final lang = Provider.of<LanguageProvider>(context, listen: false);
//     try {
//       demoList = [];
//       isLoading = true;
//       notifyListeners();
//       // ${pref.getString(session.zoneIds) ?? 1}
//       // Log the API URL for debugging
//       final url = isAllService == true
//           ? '${api.categoryService}?providerIds=${userModel!.id}'
//           : '${api.categoryService}?category_id=${id}&providerIds=${userModel!.id}';
//       log('Fetching category service: $url');
//
// // Make the API call using Dio
//       final response = await dioo.get(
//         url,
//         options: Options(
//             headers: headersToken(
//           token,
//           localLang: /* local */ lang.selectedLocaleService,
//           isLang: false,
//         )),
//       );
//
// // Check if the response is successful
//       if (response.statusCode == 200) {
//         // log("=-=-=-=-=-=-=-=-=-=SERVICE DATA : ${response.data}");
//         // Parse the response data into the CategoryServices model
//         categoryService = CategoryServices.fromJson(response.data);
//
//         // Initialize demoList as empty
//
//         // Filter child categories
//         final validCategories = categoryService?.categories
//             /*  ?.where((category) => category.isChild == true) */
//             ?.toList();
//
//         // Only add "All" category if there are valid subcategories
//         if (validCategories != null && validCategories.isNotEmpty) {
//           demoList.add(
//             CategoryServicesCategory(
//                 id: 0,
//                 title: 'All',
//                 isChild: false,
//                 servicesCount: 0,
//                 media: []),
//           );
//
//           demoList.addAll(validCategories);
//           log('Filtered categories added: ${validCategories.map((c) => c.title).toList()}');
//           log("First sub-category: ${demoList[1].title}");
//         } else {
//           isLoading = false;
//           log('No valid child categories found. Skipping "All" category.');
//         }
//         isLoading = false;
//         log('Category service fetched successfully: ${categoryService!.categories!.map((c) => c.title).toList()}');
//       } else {
//         log('Failed to fetch category service: ${response.statusCode}');
//         Fluttertoast.showToast(msg: response.statusMessage!);
//         throw Exception(
//             'Failed to fetch category service: ${response.statusCode}');
//       }
//     } catch (e, stackTrace) {
//       isLoading = false;
//       log('Error fetching category service: $e',
//           error: e, stackTrace: stackTrace);
//       throw e;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

  Future<void> getService(context,
      {int? id, String? search, bool? isList = false}) async {
    try {
      isLoading = true;
      notifyListeners();
      serviceDemo.clear();

      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(session.accessToken);
      final lang = Provider.of<LanguageProvider>(context, listen: false);
      final zoneId = pref
          .getString(session.zoneIds); // Build the API URL with optional search
      log("isList::$isList");
      String url = isList == true
          ? '${api.categoryService}?providerIds=${userModel!.id}'
          : '${api.categoryService}?category_id=$id&providerIds=${userModel!.id}';
      if (search != null && search.isNotEmpty) {
        url += '&search=$search';
      }

      log('Fetching services: $url');

      final response = await dioo.get(url,
          options: Options(
              headers: headersToken(
            token,
            localLang: /* local */ lang.selectedLocaleService,
            isLang: false,
          )));

      if (response.statusCode == 200) {
        isLoading = false;
        categoryService = CategoryServices.fromJson(response.data);

        if (categoryService!.services != null) {
          serviceDemo.addAll(categoryService!.services!);
          log('Services added: ${serviceDemo.length}');
          if (serviceDemo.isNotEmpty) {
            log('First service: ${serviceDemo.first.title}');
          }
        } else {
          log('No services found.');
        }

        log('Services fetched successfully: ${serviceDemo.length}');
      } else {
        isLoading = false;
        log('Failed to fetch services: ${response.statusCode}');
        throw Exception('Failed to fetch services: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      log('Error fetching services: $e', error: e, stackTrace: stackTrace);
      throw e;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

// Service list as per subcategory tab change
  void onTapTab(BuildContext context, int val, id) {
    tabIndex = val;
    notifyListeners();

    log("cachedServiceList :${cachedServiceList.length}");

    // Store last 3 selected list data
    int index = cachedServiceList
        .indexWhere((element) => element.id.toString() == id.toString());
    log("index :$index");
    if (index >= 0) {
      serviceList = cachedServiceList[index].serviceList!;
    } else {
      getCategoryService(context, id: id);
    }

    log("categoryList[value.selectedIndex]::: $dataLocalList");

    log("Stored Last 3 Lists: ${dataLocalList.length}");
  }

  // on page init data fetch
  onReady(context, sync) async {
    notifyListeners();

    isLoading = true;
    notifyListeners();

    log("SELECT :$selectedIndex");
    log("SELECT :${tabIndex}");
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    if (data != null) {
      log("data:::$data");

      getCategoryService(context, id: data);
      getService(context, id: data);
    } else {
      await getService(context, isList: true);
      selectedIndex = 0;
    }

    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      widget1Opacity = 1;
      isLoading = false;
      log("widget1Opacity::$widget1Opacity");
      notifyListeners();
    });
  }

  bool isStatusLoader = false;
  //update active status of service
  updateActiveStatusService(context, id, val, index) async {
    log("index::$index//$val///${filteredServices[index].status}");
    filteredServices[index].status = val == true ? 1 : 0;
    notifyListeners();
    log("SS ;${filteredServices[index].status} // $id");
    isStatusLoader = true;
    var body = {"status": val == true ? 1 : 0, "_method": "PUT"};
    dio.FormData formData = dio.FormData.fromMap(body);
    try {
      await apiServices
          .postApi("${api.service}/$id", formData, isToken: true)
          .then((value) {
        hideLoading(context);

        notifyListeners();
        log("dsjf :${value.message}");
        if (value.isSuccess!) {
          isStatusLoader = false;
          showSuccessToast(context, value.message);
          final common =
              Provider.of<UserDataApiProvider>(context, listen: false);
          common.getPopularServiceList();
          getCategoryService(context, id: categoryList[selectedIndex].id);
        } else {
          isStatusLoader = false;
          showErrorToast(context, value.message);
        }
      });
    } catch (e) {
      isStatusLoader = false;
      hideLoading(context);
      notifyListeners();
    }
  }

  int? subCategoryId;
  void onSubCategories(context, index, id) {
    selectedIndex = index;
    subCategoryId = id;
    notifyListeners();
    log('Selected sub-category ID: $id, Index: $index');
  }

  List<Service> get filteredServices {
    // If no subcategory filter, return all demo services
    if (selectedIndex == 0 || subCategoryId == 0) {
      return serviceDemo;
    }

    // Else, filter demo services by selected subcategory
    return serviceDemo
        .where((service) =>
            service.categories!.any((category) => category.id == subCategoryId))
        .toList();
  }
  //service list as per category
  /* onCategories(context, index, sync) async {
    showLoading(context);
    notifyListeners();
    cachedServiceList = [];
    tabIndex = 0;

    selectedIndex = index;
    notifyListeners();

    serviceList = [];
    if (categoryList.isNotEmpty) {
      log("categoryList[selectedIndex].hasSubCategories :${categoryList[selectedIndex].hasSubCategories}");
      if (categoryList[selectedIndex].hasSubCategories != null &&
          categoryList[selectedIndex].hasSubCategories!.isNotEmpty) {
        await getServiceByCategoryId(
            context, categoryList[selectedIndex].hasSubCategories![0].id);
      } else {
        await getServiceByCategoryId(context, categoryList[selectedIndex].id);
      }
    }

    hideLoading(context);
    notifyListeners();
  }*/

  onBack(context, isBack) {
    selectedIndex = 0;
    tabIndex = 0;

    // serviceList = [];
    widget1Opacity = 0.0;
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

/*  //get service by category or sub category wise
  getServiceByCategoryId(context, id, {bool isLoader = false}) async {
    if (isLoader) {
      const CircularProgressIndicator();
    } else {
      widget1Opacity = 0.0;
    }
    notifyListeners();

    try {
      String apiUrl = "";

      apiUrl = "${api.categoryService}?category_id=$id";
      log("apiUrlapiUrlapiUrl::$apiUrl");
      await apiServices.getApi(apiUrl, [], isToken: true).then((value) {
        if (value.isSuccess!) {
          widget1Opacity = 1;
          serviceList = [];
          hideLoading(context);
          notifyListeners();
          List dataList = value.data;
          if (dataList.isNotEmpty) {
            for (var data in value.data) {
              Services services = Services.fromJson(data);
              log("CHECK :${services.id} // ${services.status}");
              if (!serviceList.contains(services)) {
                serviceList.add(services);
              }
            }
            CategoryService categoryService =
                CategoryService(id: id, serviceList: serviceList);
            log("categoryService : $categoryService");
            log("categoryService : ${cachedServiceList.isEmpty}");
            if (cachedServiceList.isNotEmpty) {
              log("AAAA1111AAAA");
              if (cachedServiceList.length > 3) {
                cachedServiceList.removeAt(0);
                cachedServiceList.add(categoryService);
              } else {
                int index = cachedServiceList.indexWhere(
                    (element) => element.id.toString() == id.toString());
                if (index >= 0) {
                  log("ssss");
                } else {
                  cachedServiceList.add(categoryService);
                  log("A00");
                }
              }
            } else {
              log("AAAAAAAA");
              cachedServiceList.add(categoryService);
            }

            notifyListeners();
          } else {
            hideLoading(context);
            notifyListeners();
          }
        } else {
          hideLoading(context);
          notifyListeners();
        }

        notifyListeners();
      });
      log("serviceList:${serviceList.length}");
    } catch (e, s) {
      log("EEEE getServiceByCategoryId : $e==> $s");
      notifyListeners();
    }
  }*/
}
