import 'package:edemand_partner/app/appAssets.dart';

enum MessageType {
  // noDataFound("Server Error Occurred", AppAssets.noDataFound),
  noBookmark("noBookmarkFound", AppAssets.noBooking),
  noAddress("noAddressFound", AppAssets.noAddresses),
  pageNotFound("pageNotFound", AppAssets.pageNotFound),
  noChat("noChatsFound", AppAssets.noChat),
  noChatHistory("noChatHistoryFound", AppAssets.noChat),
  noSearchResult("noProviderFound", AppAssets.noSearchResult);

  final String message;
  final String image;

  const MessageType(this.message, this.image);

  static String getImageFromMessage(String msg) {
    for (var type in MessageType.values) {
      if (type.message == msg) {
        return type.image;
      }
    }
    return AppAssets.noDataFound; // Default image if no match found
  }
}
