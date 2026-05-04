import 'package:camera/camera.dart';
import 'package:fixit_provider/model/dash_board_model.dart';

import '../config.dart' hide Data;
import '../model/advertisement_model.dart';
import '../model/service_add_ons_model.dart';
import '../screens/app_pages_screens/boost_screen/boost_bill_summary.dart';

bool isFreelancer = false,
    isLogin = false,
    isServiceman = false,
    isSubscription = false,isProvider = false;

List<CameraDescription> cameras = [];
List<AdvertisementModel> advertisementList = [];

UserModel? userModel;
var settingAdvertisementModel;

PrimaryAddress? userPrimaryAddress;

ProviderModel? provider;

String zoneIds = "";

String? currentAddress, street;

LatLng? position;

int? setPrimaryAddress;

SubscriptionModel? userSubscribe;

ActiveSubscription? activeSubscription;

StatisticModel? statisticModel;
DashboardModel? dashBoardModel;
List<dynamic> booking = [];
// LatestServiceRequest? latestServiceRequest;

BankDetailModel? bankDetailModel;

List<Services> popularServiceList = [];
List<PopularService> popularServiceHome = [];

List<Services> allServices = [];

List<ServicePackageModel> servicePackageList = [];
List<ServiceAddOnsModel> serviceAddOns = [];

List<ProviderDocumentModel> providerDocumentList = [];

List<NotificationModel> notificationList = [];

List<DocumentModel> notUpdateDocumentList = [];

List<PrimaryAddress> addressList = [];

List<Services> allServiceList = [];
List<LatestBlog> latestBlogs = [];

List<Reviews> reviewList = [];

List<JobRequestModel> jobRequestList = [];
List<LatestServiceRequest> latestServiceRequest = [];

Chart? chart;

CommissionHistoryModel? commissionList;

TotalEarningModel? totalEarningModel;
