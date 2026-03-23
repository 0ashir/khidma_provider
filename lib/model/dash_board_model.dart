/* // To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

import '../screens/app_pages_screens/earning_screen/layouts/chart_class.dart';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  String? totalRevenue;
  int? totalBookings;
  int? totalServices;
  int? totalCategories;
  int? totalServicemen;
  Chart? chart;
  List<Booking>? booking;
  List<LatestServiceRequest>? latestServiceRequests;
  List<PopularService>? popularServices;
  List<LatestBlog>? latestBlogs;

  DashboardModel({
    this.totalRevenue,
    this.totalBookings,
    this.totalServices,
    this.totalCategories,
    this.totalServicemen,
    this.chart,
    this.booking,
    this.latestServiceRequests,
    this.popularServices,
    this.latestBlogs,
  });

  factory DashboardModel.fromJson(Map<dynamic, dynamic> json) => DashboardModel(
        totalRevenue: json["total_revenue"]?.toString(),
        totalBookings: json["total_Bookings"],
        totalServices: json["total_services"],
        totalCategories: json["total_categories"],
        totalServicemen: json["total_servicemen"],
        chart: json["chart"] == null ? null : Chart.fromJson(json["chart"]),
        booking: json["booking"] == null
            ? []
            : List<Booking>.from(
                json["booking"]!.map((x) => Booking.fromJson(x))),
        latestServiceRequests: json["latestServiceRequests"] == null
            ? []
            : List<LatestServiceRequest>.from(json["latestServiceRequests"]!
                .map((x) => LatestServiceRequest.fromJson(x))),
        popularServices: json["popularServices"] == null
            ? []
            : List<PopularService>.from(
                json["popularServices"].map((x) => PopularService.fromJson(x))),
        latestBlogs: json["latestBlogs"] == null
            ? []
            : List<LatestBlog>.from(
                json["latestBlogs"]!.map((x) => LatestBlog.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        "total_revenue": totalRevenue,
        "total_Bookings": totalBookings,
        "total_services": totalServices,
        "total_categories": totalCategories,
        "total_servicemen": totalServicemen,
        "chart": chart?.toJson(),
        "booking": booking == null
            ? []
            : List<dynamic>.from(booking!.map((x) => x.toJson())),
        "latestServiceRequests": latestServiceRequests == null
            ? []
            : List<dynamic>.from(latestServiceRequests!.map((x) => x.toJson())),
        "popularServices": popularServices == null
            ? []
            : List<dynamic>.from(popularServices!.map((x) => x.toJson())),
        "latestBlogs": latestBlogs == null
            ? []
            : List<dynamic>.from(latestBlogs!.map((x) => x.toJson())),
      };
}

class Booking {
  int? id;
  int? bookingNumber;
  int? parentBookingNumber;
  int? totalServicemen;
  double? total;
  Address? address;
  Service? service;
  BookingStatus? bookingStatus;
  int? requiredServicemen;
  DateTime? dateTime;
  String? paymentMethod;
  String? paymentStatus;
  Consumer? consumer;
  List<dynamic>? servicemen;
  Provider? provider;
  dynamic coupon;
  bool? isExpand;

  Booking({
    this.id,
    this.bookingNumber,
    this.parentBookingNumber,
    this.totalServicemen,
    this.total,
    this.address,
    this.service,
    this.bookingStatus,
    this.requiredServicemen,
    this.dateTime,
    this.paymentMethod,
    this.paymentStatus,
    this.consumer,
    this.servicemen,
    this.provider,
    this.coupon,
    this.isExpand,
  });

  factory Booking.fromJson(Map<dynamic, dynamic> json) => Booking(
      id: json["id"],
      bookingNumber: json["booking_number"],
      parentBookingNumber: json["parent_booking_number"],
      totalServicemen: json["total_servicemen"],
      total: json["total"]?.toDouble(),
      address:
          json["address"] == null ? null : Address.fromJson(json["address"]),
      service:
          json["service"] == null ? null : Service.fromJson(json["service"]),
      bookingStatus: json["booking_status"] == null
          ? null
          : BookingStatus.fromJson(json["booking_status"]),
      requiredServicemen: json["required_servicemen"],
      dateTime:
          json["date_time"] == null ? null : DateTime.parse(json["date_time"]),
      paymentMethod: json["payment_method"],
      paymentStatus: json["payment_status"],
      consumer:
          json["consumer"] == null ? null : Consumer.fromJson(json["consumer"]),
      servicemen: json["servicemen"] == null
          ? []
          : List<dynamic>.from(json["servicemen"]!.map((x) => x)),
      provider:
          json["provider"] == null ? null : Provider.fromJson(json["provider"]),
      coupon: json["coupon"],
      isExpand: false);

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "booking_number": bookingNumber,
        "parent_booking_number": parentBookingNumber,
        "total_servicemen": totalServicemen,
        "total": total,
        "address": address?.toJson(),
        "service": service?.toJson(),
        "booking_status": bookingStatus?.toJson(),
        "required_servicemen": requiredServicemen,
        "date_time": dateTime?.toIso8601String(),
        "payment_method": paymentMethod,
        "payment_status": paymentStatus,
        "consumer": consumer?.toJson(),
        "servicemen": servicemen == null
            ? []
            : List<dynamic>.from(servicemen!.map((x) => x)),
        "provider": provider?.toJson(),
        "coupon": coupon,
      };
}

class Address {
  int? id;
  int? userId;
  dynamic serviceId;
  int? isPrimary;
  String? latitude;
  String? longitude;
  dynamic area;
  String? postalCode;
  int? countryId;
  int? stateId;
  String? city;
  String? address;
  String? type;
  String? alternativeName;
  int? code;
  int? alternativePhone;
  int? status;
  dynamic companyId;
  dynamic availabilityRadius;
  Provider? country;
  Provider? state;

  Address({
    this.id,
    this.userId,
    this.serviceId,
    this.isPrimary,
    this.latitude,
    this.longitude,
    this.area,
    this.postalCode,
    this.countryId,
    this.stateId,
    this.city,
    this.address,
    this.type,
    this.alternativeName,
    this.code,
    this.alternativePhone,
    this.status,
    this.companyId,
    this.availabilityRadius,
    this.country,
    this.state,
  });

  factory Address.fromJson(Map<dynamic, dynamic> json) => Address(
        id: json["id"],
        userId: json["user_id"],
        serviceId: json["service_id"],
        isPrimary: json["is_primary"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        area: json["area"],
        postalCode: json["postal_code"],
        countryId: json["country_id"],
        stateId: json["state_id"],
        city: json["city"],
        address: json["address"],
        type: json["type"],
        alternativeName: json["alternative_name"],
        code: json["code"],
        alternativePhone: json["alternative_phone"],
        status: json["status"],
        companyId: json["company_id"],
        availabilityRadius: json["availability_radius"],
        country:
            json["country"] == null ? null : Provider.fromJson(json["country"]),
        state: json["state"] == null ? null : Provider.fromJson(json["state"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "service_id": serviceId,
        "is_primary": isPrimary,
        "latitude": latitude,
        "longitude": longitude,
        "area": area,
        "postal_code": postalCode,
        "country_id": countryId,
        "state_id": stateId,
        "city": city,
        "address": address,
        "type": type,
        "alternative_name": alternativeName,
        "code": code,
        "alternative_phone": alternativePhone,
        "status": status,
        "company_id": companyId,
        "availability_radius": availabilityRadius,
        "country": country?.toJson(),
        "state": state?.toJson(),
      };
}

class Provider {
  int? id;
  String? name;

  Provider({
    this.id,
    this.name,
  });

  factory Provider.fromJson(Map<dynamic, dynamic> json) => Provider(
        id: json["id"],
        name: json["name"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class BookingStatus {
  int? id;
  String? name;
  String? slug;
  String? hexaCode;

  BookingStatus({
    this.id,
    this.name,
    this.slug,
    this.hexaCode,
  });

  factory BookingStatus.fromJson(Map<dynamic, dynamic> json) => BookingStatus(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        hexaCode: json["hexa_code"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "hexa_code": hexaCode,
      };
}

class Consumer {
  int? id;
  String? name;
  List<dynamic>? media;

  Consumer({
    this.id,
    this.name,
    this.media,
  });

  factory Consumer.fromJson(Map<dynamic, dynamic> json) => Consumer(
        id: json["id"],
        name: json["name"],
        media: json["media"] == null
            ? []
            : List<dynamic>.from(json["media"]!.map((x) => x)),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "name": name,
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x)),
      };
}

class Service {
  int? id;
  String? title;
  List<ServiceMedia>? media;

  Service({
    this.id,
    this.title,
    this.media,
  });

  factory Service.fromJson(Map<dynamic, dynamic> json) => Service(
        id: json["id"],
        title: json["title"],
        media: json["media"] == null
            ? []
            : List<ServiceMedia>.from(
                json["media"]!.map((x) => ServiceMedia.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "title": title,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
      };
}

class ServiceMedia {
  int? id;
  CollectionName? collectionName;
  String? name;
  CustomProperties? customProperties;
  List<dynamic>? responsiveImages;
  DateTime? createdAt;
  String? originalUrl;

  ServiceMedia({
    this.id,
    this.collectionName,
    this.name,
    this.customProperties,
    this.responsiveImages,
    this.createdAt,
    this.originalUrl,
  });

  factory ServiceMedia.fromJson(Map<dynamic, dynamic> json) => ServiceMedia(
        id: json["id"],
        collectionName: collectionNameValues.map[json["collection_name"]]!,
        name: json["name"],
        customProperties: json["custom_properties"] == null
            ? null
            : CustomProperties.fromJson(json["custom_properties"]),
        responsiveImages: json["responsive_images"] == null
            ? []
            : List<dynamic>.from(json["responsive_images"]!.map((x) => x)),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        originalUrl: json["original_url"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "collection_name": collectionNameValues.reverse[collectionName],
        "name": name,
        "custom_properties": customProperties?.toJson(),
        "responsive_images": responsiveImages == null
            ? []
            : List<dynamic>.from(responsiveImages!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
        "original_url": originalUrl,
      };
}

enum CollectionName {
  IMAGE,
  META_IMAGE,
  THUMBNAIL,
  WEB_IMAGE,
  WEB_IMAGES,
  WEB_THUMBNAIL
}

final collectionNameValues = EnumValues({
  "image": CollectionName.IMAGE,
  "meta_image": CollectionName.META_IMAGE,
  "thumbnail": CollectionName.THUMBNAIL,
  "web_image": CollectionName.WEB_IMAGE,
  "web_images": CollectionName.WEB_IMAGES,
  "web_thumbnail": CollectionName.WEB_THUMBNAIL
});

class CustomProperties {
  Language? language;

  CustomProperties({
    this.language,
  });

  factory CustomProperties.fromJson(Map<dynamic, dynamic> json) =>
      CustomProperties(
        language: languageValues.map[json["language"]]!,
      );

  Map<dynamic, dynamic> toJson() => {
        "language": languageValues.reverse[language],
      };
}

enum Language { EN }

final languageValues = EnumValues({"en": Language.EN});

class Chart {
  List<ChartData>? monthlyRevenues = [];
  List<ChartData>? yearlyRevenues = [];
  List<ChartData>? weekdayRevenues = [];

  Chart({
    this.monthlyRevenues,
    this.yearlyRevenues,
    this.weekdayRevenues,
  });

  Chart.fromJson(Map<dynamic, dynamic> json) {
    json['yearlyRevenues'].forEach((key, n) {
      ChartData chartData = ChartData(x: key, y: double.parse(n.toString()));
      yearlyRevenues!.add(chartData);
    });
    json['monthlyRevenues'].forEach((key, n) {
      ChartData chartData = ChartData(x: key, y: double.parse(n.toString()));
      monthlyRevenues!.add(chartData);
    });
    json['weekdayRevenues'].forEach((key, n) {
      ChartData chartData = ChartData(x: key, y: double.parse(n.toString()));
      weekdayRevenues!.add(chartData);
    });
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    if (monthlyRevenues!.isNotEmpty) {
      data['monthlyRevenues'] =
          monthlyRevenues!.map((v) => v.toJson()).toList();
    }
    if (yearlyRevenues!.isNotEmpty) {
      data['yearlyRevenues'] = yearlyRevenues!.map((v) => v.toJson()).toList();
    }
    if (weekdayRevenues!.isNotEmpty) {
      data['weekdayRevenues'] =
          weekdayRevenues!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WeekdayRevenues {
  int? sunday;
  double? monday;
  int? tuesday;
  int? wednesday;
  double? thursday;
  int? friday;
  int? saturday;

  WeekdayRevenues({
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
  });

  factory WeekdayRevenues.fromJson(Map<dynamic, dynamic> json) =>
      WeekdayRevenues(
        sunday: json["Sunday"],
        monday: json["Monday"]?.toDouble(),
        tuesday: json["Tuesday"],
        wednesday: json["Wednesday"],
        thursday: json["Thursday"]?.toDouble(),
        friday: json["Friday"],
        saturday: json["Saturday"],
      );

  Map<dynamic, dynamic> toJson() => {
        "Sunday": sunday,
        "Monday": monday,
        "Tuesday": tuesday,
        "Wednesday": wednesday,
        "Thursday": thursday,
        "Friday": friday,
        "Saturday": saturday,
      };
}

class LatestBlog {
  int? id;
  String? title;
  String? description;
  DateTime? createdAt;
  String? content;
  List<LatestBlogCategory>? categories;
  CreatedBy? createdBy;
  List<Tag>? tags;
  List<ServiceMedia>? media;

  LatestBlog({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.content,
    this.categories,
    this.createdBy,
    this.tags,
    this.media,
  });

  factory LatestBlog.fromJson(Map<dynamic, dynamic> json) => LatestBlog(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        content: json["content"],
        categories: json["categories"] == null
            ? []
            : List<LatestBlogCategory>.from(
                json["categories"]!.map((x) => LatestBlogCategory.fromJson(x))),
        createdBy: json["created_by"] == null
            ? null
            : CreatedBy.fromJson(json["created_by"]),
        tags: json["tags"] == null
            ? []
            : List<Tag>.from(json["tags"]!.map((x) => Tag.fromJson(x))),
        media: json["media"] == null
            ? []
            : List<ServiceMedia>.from(
                json["media"]!.map((x) => ServiceMedia.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "content": content,
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "created_by": createdBy?.toJson(),
        "tags": tags == null
            ? []
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
      };
}

class LatestBlogCategory {
  int? id;
  String? title;
  String? slug;
  String? description;
  dynamic parentId;
  dynamic metaTitle;
  dynamic metaDescription;
  int? commission;
  int? status;
  int? isFeatured;
  Type? categoryType;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? servicesCount;
  PurplePivot? pivot;
  List<dynamic>? media;
  List<dynamic>? zones;

  LatestBlogCategory({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.parentId,
    this.metaTitle,
    this.metaDescription,
    this.commission,
    this.status,
    this.isFeatured,
    this.categoryType,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.servicesCount,
    this.pivot,
    this.media,
    this.zones,
  });

  factory LatestBlogCategory.fromJson(Map<dynamic, dynamic> json) =>
      LatestBlogCategory(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        parentId: json["parent_id"],
        metaTitle: json["meta_title"],
        metaDescription: json["meta_description"],
        commission: json["commission"],
        status: json["status"],
        isFeatured: json["is_featured"],
        categoryType: typeValues.map[json["category_type"]]!,
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        servicesCount: json["services_count"],
        pivot:
            json["pivot"] == null ? null : PurplePivot.fromJson(json["pivot"]),
        media: json["media"] == null
            ? []
            : List<dynamic>.from(json["media"]!.map((x) => x)),
        zones: json["zones"] == null
            ? []
            : List<dynamic>.from(json["zones"]!.map((x) => x)),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "description": description,
        "parent_id": parentId,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "commission": commission,
        "status": status,
        "is_featured": isFeatured,
        "category_type": typeValues.reverse[categoryType],
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "services_count": servicesCount,
        "pivot": pivot?.toJson(),
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x)),
        "zones": zones == null ? [] : List<dynamic>.from(zones!.map((x) => x)),
      };
}

enum Type { BLOG }

final typeValues = EnumValues({"blog": Type.BLOG});

class PurplePivot {
  int? blogId;
  int? categoryId;

  PurplePivot({
    this.blogId,
    this.categoryId,
  });

  factory PurplePivot.fromJson(Map<dynamic, dynamic> json) => PurplePivot(
        blogId: json["blog_id"],
        categoryId: json["category_id"],
      );

  Map<dynamic, dynamic> toJson() => {
        "blog_id": blogId,
        "category_id": categoryId,
      };
}

class CreatedBy {
  Name? name;

  CreatedBy({
    this.name,
  });

  factory CreatedBy.fromJson(Map<dynamic, dynamic> json) => CreatedBy(
        name: nameValues.map[json["name"]]!,
      );

  Map<dynamic, dynamic> toJson() => {
        "name": nameValues.reverse[name],
      };
}

enum Name { ADMIN }

final nameValues = EnumValues({"admin": Name.ADMIN});

class Tag {
  int? id;
  String? name;
  String? slug;
  Type? type;
  String? description;
  int? createdById;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  TagPivot? pivot;

  Tag({
    this.id,
    this.name,
    this.slug,
    this.type,
    this.description,
    this.createdById,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.pivot,
  });

  factory Tag.fromJson(Map<dynamic, dynamic> json) => Tag(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        type: typeValues.map[json["type"]]!,
        description: json["description"],
        createdById: json["created_by_id"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        pivot: json["pivot"] == null ? null : TagPivot.fromJson(json["pivot"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "type": typeValues.reverse[type],
        "description": description,
        "created_by_id": createdById,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "pivot": pivot?.toJson(),
      };
}

class TagPivot {
  int? blogId;
  int? tagId;

  TagPivot({
    this.blogId,
    this.tagId,
  });

  factory TagPivot.fromJson(Map<dynamic, dynamic> json) => TagPivot(
        blogId: json["blog_id"],
        tagId: json["tag_id"],
      );

  Map<dynamic, dynamic> toJson() => {
        "blog_id": blogId,
        "tag_id": tagId,
      };
}

class LatestServiceRequest {
  int? id;
  String? title;
  String? description;
  String? duration;
  String? durationUnit;
  int? requiredServicemen;
  int? initialPrice;
  dynamic finalPrice;
  String? status;
  dynamic serviceId;
  int? userId;
  dynamic providerId;
  int? createdById;
  DateTime? bookingDate;
  List<String>? categoryIds;
  dynamic locations;
  dynamic locationCoordinates;
  DateTime? createdAt;
  List<dynamic>? bids;
  List<LatestServiceRequestMedia>? media;
  User? user;
  dynamic provider;
  dynamic service;
  List<dynamic>? zones;

  LatestServiceRequest({
    this.id,
    this.title,
    this.description,
    this.duration,
    this.durationUnit,
    this.requiredServicemen,
    this.initialPrice,
    this.finalPrice,
    this.status,
    this.serviceId,
    this.userId,
    this.providerId,
    this.createdById,
    this.bookingDate,
    this.categoryIds,
    this.locations,
    this.locationCoordinates,
    this.createdAt,
    this.bids,
    this.media,
    this.user,
    this.provider,
    this.service,
    this.zones,
  });

  factory LatestServiceRequest.fromJson(Map<dynamic, dynamic> json) =>
      LatestServiceRequest(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        duration: json["duration"],
        durationUnit: json["duration_unit"],
        requiredServicemen: json["required_servicemen"],
        initialPrice: json["initial_price"],
        finalPrice: json["final_price"],
        status: json["status"],
        serviceId: json["service_id"],
        userId: json["user_id"],
        providerId: json["provider_id"],
        createdById: json["created_by_id"],
        bookingDate: json["booking_date"] == null
            ? null
            : DateTime.parse(json["booking_date"]),
        categoryIds: json["category_ids"] == null
            ? []
            : List<String>.from(json["category_ids"]!.map((x) => x)),
        locations: json["locations"],
        locationCoordinates: json["location_coordinates"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        bids: json["bids"] == null
            ? []
            : List<dynamic>.from(json["bids"]!.map((x) => x)),
        media: json["media"] == null
            ? []
            : List<LatestServiceRequestMedia>.from(json["media"]!
                .map((x) => LatestServiceRequestMedia.fromJson(x))),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        provider: json["provider"],
        service: json["service"],
        zones: json["zones"] == null
            ? []
            : List<dynamic>.from(json["zones"]!.map((x) => x)),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "duration": duration,
        "duration_unit": durationUnit,
        "required_servicemen": requiredServicemen,
        "initial_price": initialPrice,
        "final_price": finalPrice,
        "status": status,
        "service_id": serviceId,
        "user_id": userId,
        "provider_id": providerId,
        "created_by_id": createdById,
        "booking_date": bookingDate?.toIso8601String(),
        "category_ids": categoryIds == null
            ? []
            : List<dynamic>.from(categoryIds!.map((x) => x)),
        "locations": locations,
        "location_coordinates": locationCoordinates,
        "created_at": createdAt?.toIso8601String(),
        "bids": bids == null ? [] : List<dynamic>.from(bids!.map((x) => x)),
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "user": user?.toJson(),
        "provider": provider,
        "service": service,
        "zones": zones == null ? [] : List<dynamic>.from(zones!.map((x) => x)),
      };
}

class LatestServiceRequestMedia {
  int? id;
  String? modelType;
  int? modelId;
  String? uuid;
  CollectionName? collectionName;
  String? name;
  String? fileName;
  String? mimeType;
  String? disk;
  String? conversionsDisk;
  int? size;
  List<dynamic>? manipulations;
  List<dynamic>? customProperties;
  List<dynamic>? generatedConversions;
  List<dynamic>? responsiveImages;
  int? orderColumn;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? originalUrl;
  String? previewUrl;

  LatestServiceRequestMedia({
    this.id,
    this.modelType,
    this.modelId,
    this.uuid,
    this.collectionName,
    this.name,
    this.fileName,
    this.mimeType,
    this.disk,
    this.conversionsDisk,
    this.size,
    this.manipulations,
    this.customProperties,
    this.generatedConversions,
    this.responsiveImages,
    this.orderColumn,
    this.createdAt,
    this.updatedAt,
    this.originalUrl,
    this.previewUrl,
  });

  factory LatestServiceRequestMedia.fromJson(Map<dynamic, dynamic> json) =>
      LatestServiceRequestMedia(
        id: json["id"],
        modelType: json["model_type"],
        modelId: json["model_id"],
        uuid: json["uuid"],
        collectionName: collectionNameValues.map[json["collection_name"]]!,
        name: json["name"],
        fileName: json["file_name"],
        mimeType: json["mime_type"],
        disk: json["disk"],
        conversionsDisk: json["conversions_disk"],
        size: json["size"],
        manipulations: json["manipulations"] == null
            ? []
            : List<dynamic>.from(json["manipulations"]!.map((x) => x)),
        // customProperties: json["custom_properties"] == null
        //     ? []
        //     : List<dynamic>.from(json["custom_properties"]!.map((x) => x)),
        generatedConversions: json["generated_conversions"] == null
            ? []
            : List<dynamic>.from(json["generated_conversions"]!.map((x) => x)),
        responsiveImages: json["responsive_images"] == null
            ? []
            : List<dynamic>.from(json["responsive_images"]!.map((x) => x)),
        orderColumn: json["order_column"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        originalUrl: json["original_url"],
        previewUrl: json["preview_url"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "model_type": modelType,
        "model_id": modelId,
        "uuid": uuid,
        "collection_name": collectionNameValues.reverse[collectionName],
        "name": name,
        "file_name": fileName,
        "mime_type": mimeType,
        "disk": disk,
        "conversions_disk": conversionsDisk,
        "size": size,
        "manipulations": manipulations == null
            ? []
            : List<dynamic>.from(manipulations!.map((x) => x)),
        "custom_properties": customProperties == null
            ? []
            : List<dynamic>.from(customProperties!.map((x) => x)),
        "generated_conversions": generatedConversions == null
            ? []
            : List<dynamic>.from(generatedConversions!.map((x) => x)),
        "responsive_images": responsiveImages == null
            ? []
            : List<dynamic>.from(responsiveImages!.map((x) => x)),
        "order_column": orderColumn,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "original_url": originalUrl,
        "preview_url": previewUrl,
      };
}

class Bid {
  int? id;
  int? serviceRequestId;
  int? providerId;
  int? amount;
  dynamic description;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  Provider? provider;

  Bid({
    this.id,
    this.serviceRequestId,
    this.providerId,
    this.amount,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.provider,
  });

  factory Bid.fromJson(Map<dynamic, dynamic> json) => Bid(
        id: json["id"],
        serviceRequestId: json["service_request_id"],
        providerId: json["provider_id"],
        amount: json["amount"],
        description: json["description"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        provider: json["provider"] == null
            ? null
            : Provider.fromJson(json["provider"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "service_request_id": serviceRequestId,
        "provider_id": providerId,
        "amount": amount,
        "description": description,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "provider": provider?.toJson(),
      };
}

class User {
  int? id;
  String? name;
  String? slug;
  String? email;
  int? systemReserve;
  int? served;
  int? phone;
  int? code;
  dynamic providerId;
  int? status;
  int? isFeatured;
  int? isVerified;
  dynamic type;
  DateTime? emailVerifiedAt;
  String? fcmToken;
  dynamic experienceInterval;
  dynamic experienceDuration;
  dynamic description;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  dynamic companyId;
  dynamic locationCordinates;
  int? bookingsCount;
  int? reviewsCount;
  Role? role;
  int? reviewRatings;
  List<int>? providerRatingList;
  List<int>? serviceManRatingList;
  Address? primaryAddress;
  int? totalDaysExperience;
  int? servicemanReviewRatings;
  List<LatestServiceRequestMedia>? media;
  Wallet? wallet;
  dynamic providerWallet;
  dynamic servicemanWallet;
  List<dynamic>? knownLanguages;
  List<dynamic>? expertise;
  List<dynamic>? zones;
  dynamic provider;
  List<Role>? roles;
  List<dynamic>? reviews;
  List<dynamic>? servicemanreviews;

  User({
    this.id,
    this.name,
    this.slug,
    this.email,
    this.systemReserve,
    this.served,
    this.phone,
    this.code,
    this.providerId,
    this.status,
    this.isFeatured,
    this.isVerified,
    this.type,
    this.emailVerifiedAt,
    this.fcmToken,
    this.experienceInterval,
    this.experienceDuration,
    this.description,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.companyId,
    this.locationCordinates,
    this.bookingsCount,
    this.reviewsCount,
    this.role,
    this.reviewRatings,
    this.providerRatingList,
    this.serviceManRatingList,
    this.primaryAddress,
    this.totalDaysExperience,
    this.servicemanReviewRatings,
    this.media,
    this.wallet,
    this.providerWallet,
    this.servicemanWallet,
    this.knownLanguages,
    this.expertise,
    this.zones,
    this.provider,
    this.roles,
    this.reviews,
    this.servicemanreviews,
  });

  factory User.fromJson(Map<dynamic, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        email: json["email"],
        systemReserve: json["system_reserve"],
        served: json["served"],
        phone: json["phone"],
        code: json["code"],
        providerId: json["provider_id"],
        status: json["status"],
        isFeatured: json["is_featured"],
        isVerified: json["is_verified"],
        type: json["type"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        fcmToken: json["fcm_token"],
        experienceInterval: json["experience_interval"],
        experienceDuration: json["experience_duration"],
        description: json["description"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        companyId: json["company_id"],
        locationCordinates: json["location_cordinates"],
        bookingsCount: json["bookings_count"],
        reviewsCount: json["reviews_count"],
        role: json["role"] == null ? null : Role.fromJson(json["role"]),
        reviewRatings: json["review_ratings"],
        providerRatingList: json["provider_rating_list"] == null
            ? []
            : List<int>.from(json["provider_rating_list"]!.map((x) => x)),
        serviceManRatingList: json["service_man_rating_list"] == null
            ? []
            : List<int>.from(json["service_man_rating_list"]!.map((x) => x)),
        primaryAddress: json["primary_address"] == null
            ? null
            : Address.fromJson(json["primary_address"]),
        totalDaysExperience: json["total_days_experience"],
        servicemanReviewRatings: json["ServicemanReviewRatings"],
        media: json["media"] == null
            ? []
            : List<LatestServiceRequestMedia>.from(json["media"]!
                .map((x) => LatestServiceRequestMedia.fromJson(x))),
        wallet: json["wallet"] == null ? null : Wallet.fromJson(json["wallet"]),
        providerWallet: json["provider_wallet"],
        servicemanWallet: json["serviceman_wallet"],
        knownLanguages: json["known_languages"] == null
            ? []
            : List<dynamic>.from(json["known_languages"]!.map((x) => x)),
        expertise: json["expertise"] == null
            ? []
            : List<dynamic>.from(json["expertise"]!.map((x) => x)),
        zones: json["zones"] == null
            ? []
            : List<dynamic>.from(json["zones"]!.map((x) => x)),
        provider: json["provider"],
        roles: json["roles"] == null
            ? []
            : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
        reviews: json["reviews"] == null
            ? []
            : List<dynamic>.from(json["reviews"]!.map((x) => x)),
        servicemanreviews: json["servicemanreviews"] == null
            ? []
            : List<dynamic>.from(json["servicemanreviews"]!.map((x) => x)),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "email": email,
        "system_reserve": systemReserve,
        "served": served,
        "phone": phone,
        "code": code,
        "provider_id": providerId,
        "status": status,
        "is_featured": isFeatured,
        "is_verified": isVerified,
        "type": type,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "fcm_token": fcmToken,
        "experience_interval": experienceInterval,
        "experience_duration": experienceDuration,
        "description": description,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "company_id": companyId,
        "location_cordinates": locationCordinates,
        "bookings_count": bookingsCount,
        "reviews_count": reviewsCount,
        "role": role?.toJson(),
        "review_ratings": reviewRatings,
        "provider_rating_list": providerRatingList == null
            ? []
            : List<dynamic>.from(providerRatingList!.map((x) => x)),
        "service_man_rating_list": serviceManRatingList == null
            ? []
            : List<dynamic>.from(serviceManRatingList!.map((x) => x)),
        "primary_address": primaryAddress?.toJson(),
        "total_days_experience": totalDaysExperience,
        "ServicemanReviewRatings": servicemanReviewRatings,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "wallet": wallet?.toJson(),
        "provider_wallet": providerWallet,
        "serviceman_wallet": servicemanWallet,
        "known_languages": knownLanguages == null
            ? []
            : List<dynamic>.from(knownLanguages!.map((x) => x)),
        "expertise": expertise == null
            ? []
            : List<dynamic>.from(expertise!.map((x) => x)),
        "zones": zones == null ? [] : List<dynamic>.from(zones!.map((x) => x)),
        "provider": provider,
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "reviews":
            reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x)),
        "servicemanreviews": servicemanreviews == null
            ? []
            : List<dynamic>.from(servicemanreviews!.map((x) => x)),
      };
}

class Role {
  int? id;
  String? name;
  String? guardName;
  int? systemReserve;
  DateTime? createdAt;
  DateTime? updatedAt;
  RolePivot? pivot;

  Role({
    this.id,
    this.name,
    this.guardName,
    this.systemReserve,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory Role.fromJson(Map<dynamic, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        guardName: json["guard_name"],
        systemReserve: json["system_reserve"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        pivot: json["pivot"] == null ? null : RolePivot.fromJson(json["pivot"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "name": name,
        "guard_name": guardName,
        "system_reserve": systemReserve,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pivot": pivot?.toJson(),
      };
}

class RolePivot {
  String? modelType;
  int? modelId;
  int? roleId;

  RolePivot({
    this.modelType,
    this.modelId,
    this.roleId,
  });

  factory RolePivot.fromJson(Map<dynamic, dynamic> json) => RolePivot(
        modelType: json["model_type"],
        modelId: json["model_id"],
        roleId: json["role_id"],
      );

  Map<dynamic, dynamic> toJson() => {
        "model_type": modelType,
        "model_id": modelId,
        "role_id": roleId,
      };
}

class Wallet {
  int? id;
  int? consumerId;
  double? balance;

  Wallet({
    this.id,
    this.consumerId,
    this.balance,
  });

  factory Wallet.fromJson(Map<dynamic, dynamic> json) => Wallet(
        id: json["id"],
        consumerId: json["consumer_id"],
        balance: json["balance"]?.toDouble(),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "consumer_id": consumerId,
        "balance": balance,
      };
}

class PopularService {
  int? id;
  String? title;
  String? duration;
  String? durationUnit;
  dynamic price;
  String? description;
  String? metaDescription;
  int? requiredServicemen;
  List<ServiceMedia>? media;
  int? bookingCount;
  int? status;
  List<PopularServiceCategory>? categories;
  dynamic ratingCount;
  int? bookingsCount;
  List<dynamic>? reviews;
  Tax? tax;
  String? video;

  PopularService({
    this.id,
    this.title,
    this.duration,
    this.durationUnit,
    this.price,
    this.description,
    this.metaDescription,
    this.requiredServicemen,
    this.media,
    this.bookingCount,
    this.status,
    this.categories,
    this.video,
    this.ratingCount,
    this.bookingsCount,
    this.reviews,
    this.tax,
  });

  factory PopularService.fromJson(Map<dynamic, dynamic> json) => PopularService(
        id: json["id"],
        title: json["title"],
        duration: json["duration"],
        durationUnit: json["duration_unit"],
        price: json["price"],
        description: json["description"],
        metaDescription: json["meta_description"],
        requiredServicemen: json["required_servicemen"],
        video: json["video"],
        media: json["media"] == null
            ? []
            : List<ServiceMedia>.from(
                json["media"]!.map((x) => ServiceMedia.fromJson(x))),
        bookingCount: json["booking_count"],
        status: json["status"],
        categories: json["categories"] == null
            ? []
            : List<PopularServiceCategory>.from(json["categories"]
                .map((x) => PopularServiceCategory.fromJson(x))),
        ratingCount: json["rating_count"],
        bookingsCount: json["bookings_count"],
        reviews: json["reviews"] == null
            ? []
            : List<dynamic>.from(json["reviews"]!.map((x) => x)),
        tax: json["tax"] == null ? null : Tax.fromJson(json["tax"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "title": title,
        "duration": duration,
        "duration_unit": durationUnit,
        "price": price,
        "description": description,
        "meta_description": metaDescription,
        "required_servicemen": requiredServicemen,
        "video": video,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "booking_count": bookingCount,
        "status": status,
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "rating_count": ratingCount,
        "bookings_count": bookingsCount,
        "reviews":
            reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x)),
        "tax": tax?.toJson(),
      };
}

class PopularServiceCategory {
  int? id;
  String? title;
  String? slug;
  String? description;
  int? parentId;
  dynamic metaTitle;
  dynamic metaDescription;
  int? commission;
  int? status;
  int? isFeatured;
  String? categoryType;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? servicesCount;
  FluffyPivot? pivot;
  List<CategoryMedia>? media;
  List<Zone>? zones;

  PopularServiceCategory({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.parentId,
    this.metaTitle,
    this.metaDescription,
    this.commission,
    this.status,
    this.isFeatured,
    this.categoryType,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.servicesCount,
    this.pivot,
    this.media,
    this.zones,
  });

  factory PopularServiceCategory.fromJson(Map<dynamic, dynamic> json) =>
      PopularServiceCategory(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        parentId: json["parent_id"],
        metaTitle: json["meta_title"],
        metaDescription: json["meta_description"],
        commission: json["commission"],
        status: json["status"],
        isFeatured: json["is_featured"],
        categoryType: json["category_type"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        servicesCount: json["services_count"],
        pivot:
            json["pivot"] == null ? null : FluffyPivot.fromJson(json["pivot"]),
        media: json["media"] == null
            ? []
            : List<CategoryMedia>.from(
                json["media"]!.map((x) => CategoryMedia.fromJson(x))),
        zones: json["zones"] == null
            ? []
            : List<Zone>.from(json["zones"]!.map((x) => Zone.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "description": description,
        "parent_id": parentId,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "commission": commission,
        "status": status,
        "is_featured": isFeatured,
        "category_type": categoryType,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "services_count": servicesCount,
        "pivot": pivot?.toJson(),
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "zones": zones == null
            ? []
            : List<dynamic>.from(zones!.map((x) => x.toJson())),
      };
}

class CategoryMedia {
  int? id;
  String? modelType;
  int? modelId;
  String? uuid;
  CollectionName? collectionName;
  String? name;
  String? fileName;
  String? mimeType;
  String? disk;
  String? conversionsDisk;
  int? size;
  List<dynamic>? manipulations;
  CustomProperties? customProperties;
  List<dynamic>? generatedConversions;
  List<dynamic>? responsiveImages;
  int? orderColumn;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? originalUrl;
  String? previewUrl;

  CategoryMedia({
    this.id,
    this.modelType,
    this.modelId,
    this.uuid,
    this.collectionName,
    this.name,
    this.fileName,
    this.mimeType,
    this.disk,
    this.conversionsDisk,
    this.size,
    this.manipulations,
    this.customProperties,
    this.generatedConversions,
    this.responsiveImages,
    this.orderColumn,
    this.createdAt,
    this.updatedAt,
    this.originalUrl,
    this.previewUrl,
  });

  factory CategoryMedia.fromJson(Map<dynamic, dynamic> json) => CategoryMedia(
        id: json["id"],
        modelType: json["model_type"],
        modelId: json["model_id"],
        uuid: json["uuid"],
        collectionName: collectionNameValues.map[json["collection_name"]]!,
        name: json["name"],
        fileName: json["file_name"],
        mimeType: json["mime_type"],
        disk: json["disk"],
        conversionsDisk: json["conversions_disk"],
        size: json["size"],
        manipulations: json["manipulations"] == null
            ? []
            : List<dynamic>.from(json["manipulations"]!.map((x) => x)),
        customProperties: json["custom_properties"] == null
            ? null
            : CustomProperties.fromJson(json["custom_properties"]),
        generatedConversions: json["generated_conversions"] == null
            ? []
            : List<dynamic>.from(json["generated_conversions"]!.map((x) => x)),
        responsiveImages: json["responsive_images"] == null
            ? []
            : List<dynamic>.from(json["responsive_images"]!.map((x) => x)),
        orderColumn: json["order_column"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        originalUrl: json["original_url"],
        previewUrl: json["preview_url"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "model_type": modelType,
        "model_id": modelId,
        "uuid": uuid,
        "collection_name": collectionNameValues.reverse[collectionName],
        "name": name,
        "file_name": fileName,
        "mime_type": mimeType,
        "disk": disk,
        "conversions_disk": conversionsDisk,
        "size": size,
        "manipulations": manipulations == null
            ? []
            : List<dynamic>.from(manipulations!.map((x) => x)),
        "custom_properties": customProperties?.toJson(),
        "generated_conversions": generatedConversions == null
            ? []
            : List<dynamic>.from(generatedConversions!.map((x) => x)),
        "responsive_images": responsiveImages == null
            ? []
            : List<dynamic>.from(responsiveImages!.map((x) => x)),
        "order_column": orderColumn,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "original_url": originalUrl,
        "preview_url": previewUrl,
      };
}

class FluffyPivot {
  int? serviceId;
  int? categoryId;

  FluffyPivot({
    this.serviceId,
    this.categoryId,
  });

  factory FluffyPivot.fromJson(Map<dynamic, dynamic> json) => FluffyPivot(
        serviceId: json["service_id"],
        categoryId: json["category_id"],
      );

  Map<dynamic, dynamic> toJson() => {
        "service_id": serviceId,
        "category_id": categoryId,
      };
}

class Zone {
  int? id;
  String? name;
  PlacePoints? placePoints;
  List<Location>? locations;
  String? status;
  int? createdById;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  ZonePivot? pivot;

  Zone({
    this.id,
    this.name,
    this.placePoints,
    this.locations,
    this.status,
    this.createdById,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.pivot,
  });

  factory Zone.fromJson(Map<dynamic, dynamic> json) => Zone(
        id: json["id"],
        name: json["name"],
        placePoints: json["place_points"] == null
            ? null
            : PlacePoints.fromJson(json["place_points"]),
        locations: json["locations"] == null
            ? []
            : List<Location>.from(
                json["locations"]!.map((x) => Location.fromJson(x))),
        status: json["status"],
        createdById: json["created_by_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        pivot: json["pivot"] == null ? null : ZonePivot.fromJson(json["pivot"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "name": name,
        "place_points": placePoints?.toJson(),
        "locations": locations == null
            ? []
            : List<dynamic>.from(locations!.map((x) => x.toJson())),
        "status": status,
        "created_by_id": createdById,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "pivot": pivot?.toJson(),
      };
}

class Location {
  double? lat;
  double? lng;

  Location({
    this.lat,
    this.lng,
  });

  factory Location.fromJson(Map<dynamic, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<dynamic, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class ZonePivot {
  int? categoryId;
  int? zoneId;

  ZonePivot({
    this.categoryId,
    this.zoneId,
  });

  factory ZonePivot.fromJson(Map<dynamic, dynamic> json) => ZonePivot(
        categoryId: json["category_id"],
        zoneId: json["zone_id"],
      );

  Map<dynamic, dynamic> toJson() => {
        "category_id": categoryId,
        "zone_id": zoneId,
      };
}

class PlacePoints {
  String? type;
  List<List<List<double>>>? coordinates;

  PlacePoints({
    this.type,
    this.coordinates,
  });

  factory PlacePoints.fromJson(Map<dynamic, dynamic> json) => PlacePoints(
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? []
            : List<List<List<double>>>.from(json["coordinates"]!.map((x) =>
                List<List<double>>.from(x.map(
                    (x) => List<double>.from(x.map((x) => x?.toDouble())))))),
      );

  Map<dynamic, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => List<dynamic>.from(
                x.map((x) => List<dynamic>.from(x.map((x) => x)))))),
      };
}

class Tax {
  int? id;
  String? name;
  int? rate;
  int? status;
  int? createdById;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Tax({
    this.id,
    this.name,
    this.rate,
    this.status,
    this.createdById,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Tax.fromJson(Map<dynamic, dynamic> json) => Tax(
        id: json["id"],
        name: json["name"],
        rate: json["rate"],
        status: json["status"],
        createdById: json["created_by_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "name": name,
        "rate": rate,
        "status": status,
        "created_by_id": createdById,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
 */

// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

import 'package:fixit_provider/model/blog_model.dart';
import 'package:fixit_provider/model/user_model.dart';
import 'package:fixit_provider/screens/app_pages_screens/earning_screen/layouts/chart_class.dart';

import 'category_model.dart';
import 'job_request_model.dart';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  dynamic totalRevenue;
  int? totalBookings;
  int? totalServices;
  int? totalCategories;
  int? totalServicemen;
  Chart? chart;
  List<Booking>? booking;
  List<LatestServiceRequest>? latestServiceRequests;
  List<PopularService>? popularServices;
  List<BlogModel>? latestBlogs;

  DashboardModel({
    this.totalRevenue,
    this.totalBookings,
    this.totalServices,
    this.totalCategories,
    this.totalServicemen,
    this.chart,
    this.booking,
    this.latestServiceRequests,
    this.popularServices,
    this.latestBlogs,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        totalRevenue: json["total_revenue"],
        totalBookings: json["total_Bookings"],
        totalServices: json["total_services"],
        totalCategories: json["total_categories"],
        totalServicemen: json["total_servicemen"],
        chart: json["chart"] == null ? null : Chart.fromJson(json["chart"]),
        booking: json["booking"] == null
            ? []
            : List<Booking>.from(
                json["booking"]!.map((x) => Booking.fromJson(x))),
        latestServiceRequests: json["latestServiceRequests"] == null
            ? []
            : List<LatestServiceRequest>.from(json["latestServiceRequests"]!
                .map((x) => LatestServiceRequest.fromJson(x))),
        popularServices: json["popularServices"] == null
            ? []
            : List<PopularService>.from(json["popularServices"]!
                .map((x) => PopularService.fromJson(x))),
        latestBlogs: json["latestBlogs"] == null
            ? []
            : List<BlogModel>.from(
                json["latestBlogs"]!.map((x) => BlogModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_revenue": totalRevenue,
        "total_Bookings": totalBookings,
        "total_services": totalServices,
        "total_categories": totalCategories,
        "total_servicemen": totalServicemen,
        "chart": chart?.toJson(),
        "booking": booking == null
            ? []
            : List<dynamic>.from(booking!.map((x) => x.toJson())),
        "latestServiceRequests": latestServiceRequests == null
            ? []
            : List<dynamic>.from(latestServiceRequests!.map((x) => x)),
        "popularServices": popularServices == null
            ? []
            : List<dynamic>.from(popularServices!.map((x) => x.toJson())),
        "latestBlogs": latestBlogs == null
            ? []
            : List<dynamic>.from(latestBlogs!.map((x) => x.toJson())),
      };
}

class Booking {
  int? id;
  int? bookingNumber;
  int? totalServicemen;
  double? total;
  BookingStatus? bookingStatus;
  int? requiredServicemen;
  DateTime? dateTime;
  String? paymentMethod;
  String? paymentStatus;
  Service? service;
  Consumer? consumer;
  List<dynamic>? servicemen;
  Consumer? provider;
  bool? isExpand;

  Booking({
    this.id,
    this.bookingNumber,
    this.totalServicemen,
    this.total,
    this.bookingStatus,
    this.requiredServicemen,
    this.dateTime,
    this.paymentMethod,
    this.paymentStatus,
    this.service,
    this.consumer,
    this.isExpand,
    this.servicemen,
    this.provider,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json["id"],
        bookingNumber: json["booking_number"],
        totalServicemen: json["total_servicemen"],
        total: json["total"]?.toDouble(),
        bookingStatus: json["booking_status"] == null
            ? null
            : BookingStatus.fromJson(json["booking_status"]),
        requiredServicemen: json["required_servicemen"],
        dateTime: json["date_time"] == null
            ? null
            : DateTime.parse(json["date_time"]),
        paymentMethod: json["payment_method"],
        paymentStatus: json["payment_status"],
        service:
            json["service"] == null ? null : Service.fromJson(json["service"]),
        consumer: json["consumer"] == null
            ? null
            : Consumer.fromJson(json["consumer"]),
        servicemen: json["servicemen"] == null
            ? []
            : List<dynamic>.from(json["servicemen"]!.map((x) => x)),
        provider: json["provider"] == null
            ? null
            : Consumer.fromJson(json["provider"]),
        isExpand: false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_number": bookingNumber,
        "total_servicemen": totalServicemen,
        "total": total,
        "booking_status": bookingStatus?.toJson(),
        "required_servicemen": requiredServicemen,
        "date_time": dateTime?.toIso8601String(),
        "payment_method": paymentMethod,
        "payment_status": paymentStatus,
        "service": service?.toJson(),
        "consumer": consumer?.toJson(),
        "servicemen": servicemen == null
            ? []
            : List<dynamic>.from(servicemen!.map((x) => x)),
        "provider": provider?.toJson(),
        "isExpand": isExpand,
      };
}

class BookingStatus {
  int? id;
  String? name;
  String? slug;
  String? hexaCode;

  BookingStatus({
    this.id,
    this.name,
    this.slug,
    this.hexaCode,
  });

  factory BookingStatus.fromJson(Map<String, dynamic> json) => BookingStatus(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        hexaCode: json["hexa_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "hexa_code": hexaCode,
      };
}

class Consumer {
  int? id;
  String? name;
  List<Media>? media;

  Consumer({
    this.id,
    this.name,
    this.media,
  });

  factory Consumer.fromJson(Map<String, dynamic> json) => Consumer(
        id: json["id"],
        name: json["name"],
        media: json["media"] == null
            ? []
            : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
      };
}

class Media {
  int? id;
  String? originalUrl;
  String? collectionName;
  CustomProperties? customProperties;

  Media({
    this.id,
    this.originalUrl,
    this.collectionName,
    this.customProperties,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json["id"],
        originalUrl: json["original_url"],
        collectionName: json["collection_name"],
        customProperties: json["custom_properties"] == null
            ? null
            : CustomProperties.fromJson(json["custom_properties"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "original_url": originalUrl,
        "collection_name": collectionName,
        "custom_properties": customProperties?.toJson(),
      };
}

class CustomProperties {
  Language? language;

  CustomProperties({
    this.language,
  });

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties(
        language: languageValues.map[json["language"]]!,
      );

  Map<String, dynamic> toJson() => {
        "language": languageValues.reverse[language],
      };
}

enum Language { EN }

final languageValues = EnumValues({"en": Language.EN});

class Service {
  int? id;
  String? title;
  List<Media>? media;

  Service({
    this.id,
    this.title,
    this.media,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        title: json["title"],
        media: json["media"] == null
            ? []
            : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
      };
}

class Chart {
  List<ChartData>? monthlyRevenues = [];
  List<ChartData>? yearlyRevenues = [];
  List<ChartData>? weekdayRevenues = [];

  Chart({
    this.monthlyRevenues,
    this.yearlyRevenues,
    this.weekdayRevenues,
  });

  Chart.fromJson(Map<dynamic, dynamic> json) {
    json['yearlyRevenues'].forEach((key, n) {
      ChartData chartData = ChartData(x: key, y: double.parse(n.toString()));
      yearlyRevenues!.add(chartData);
    });
    json['monthlyRevenues'].forEach((key, n) {
      ChartData chartData = ChartData(x: key, y: double.parse(n.toString()));
      monthlyRevenues!.add(chartData);
    });
    json['weekdayRevenues'].forEach((key, n) {
      ChartData chartData = ChartData(x: key, y: double.parse(n.toString()));
      weekdayRevenues!.add(chartData);
    });
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    if (monthlyRevenues!.isNotEmpty) {
      data['monthlyRevenues'] =
          monthlyRevenues!.map((v) => v.toJson()).toList();
    }
    if (yearlyRevenues!.isNotEmpty) {
      data['yearlyRevenues'] = yearlyRevenues!.map((v) => v.toJson()).toList();
    }
    if (weekdayRevenues!.isNotEmpty) {
      data['weekdayRevenues'] =
          weekdayRevenues!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WeekdayRevenues {
  int? sunday;
  int? monday;
  int? tuesday;
  double? wednesday;
  int? thursday;
  int? friday;
  int? saturday;

  WeekdayRevenues({
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
  });

  factory WeekdayRevenues.fromJson(Map<String, dynamic> json) =>
      WeekdayRevenues(
        sunday: json["Sunday"],
        monday: json["Monday"],
        tuesday: json["Tuesday"],
        wednesday: json["Wednesday"]?.toDouble(),
        thursday: json["Thursday"],
        friday: json["Friday"],
        saturday: json["Saturday"],
      );

  Map<String, dynamic> toJson() => {
        "Sunday": sunday,
        "Monday": monday,
        "Tuesday": tuesday,
        "Wednesday": wednesday,
        "Thursday": thursday,
        "Friday": friday,
        "Saturday": saturday,
      };
}

class LatestBlog {
  int? id;
  String? title;
  String? description;
  DateTime? createdAt;
  CreatedBy? createdBy;
  List<Media>? media;

  LatestBlog({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.createdBy,
    this.media,
  });

  factory LatestBlog.fromJson(Map<String, dynamic> json) => LatestBlog(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"] == null
            ? null
            : CreatedBy.fromJson(json["created_by"]),
        media: json["media"] == null
            ? []
            : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy?.toJson(),
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
      };
}

class CreatedBy {
  String? name;

  CreatedBy({
    this.name,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class PopularService {
  int? id;
  String? title;
  dynamic price;
  int? status;
  dynamic ratingCount;
  int? bookingsCount;
  String? categories;
  List<Media>? media;

  PopularService({
    this.id,
    this.title,
    this.price,
    this.status,
    this.ratingCount,
    this.bookingsCount,
    this.categories,
    this.media,
  });

  factory PopularService.fromJson(Map<String, dynamic> json) => PopularService(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        status: json["status"],
        ratingCount: json["rating_count"],
        bookingsCount: json["bookings_count"],
        categories: json["categories"],
        media: json["media"] == null
            ? []
            : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "status": status,
        "rating_count": ratingCount,
        "bookings_count": bookingsCount,
        "categories": categories,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class LatestServiceRequest {
  int? id;
  String? title;
  String? description;
  String? duration;
  String? durationUnit;
  int? requiredServicemen;
  int? initialPrice;
  dynamic finalPrice;
  String? status;
  dynamic serviceId;
  List<dynamic>? category;
  int? userId;
  dynamic providerId;
  int? createdById;
  DateTime? bookingDate;
  List<String>? categoryIds;
  dynamic locations;
  dynamic locationCoordinates;
  DateTime? createdAt;
  dynamic bids;
  List<Media>? media;
  UserModel? user;
  dynamic provider;
  dynamic service;
  List<dynamic>? zones;

  LatestServiceRequest({
    this.id,
    this.title,
    this.description,
    this.duration,
    this.durationUnit,
    this.requiredServicemen,
    this.initialPrice,
    this.finalPrice,
    this.status,
    this.serviceId,
    this.userId,
    this.providerId,
    this.createdById,
    this.user,
    this.category,
    this.bookingDate,
    this.categoryIds,
    this.locations,
    this.locationCoordinates,
    this.createdAt,
    this.bids,
    this.media,
    this.provider,
    this.service,
    this.zones,
  });

  factory LatestServiceRequest.fromJson(Map<dynamic, dynamic> json) =>
      LatestServiceRequest(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        duration: json["duration"],
        durationUnit: json["duration_unit"],
        requiredServicemen: json["required_servicemen"],
        initialPrice: json["initial_price"],
        finalPrice: json["final_price"],
        status: json["status"],
        serviceId: json["service_id"],
        userId: json["user_id"],
        providerId: json["provider_id"],
        createdById: json["created_by_id"],
        user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
        bookingDate: json["booking_date"] == null
            ? null
            : DateTime.parse(json["booking_date"]),
        categoryIds: json["category_ids"] == null
            ? []
            : List<String>.from(json["category_ids"]!.map((x) => x)),
        category: json["categories"] == null
            ? []
            : List<dynamic>.from(json["categories"]!.map((x) => x)),
        locations: json["locations"],
        locationCoordinates: json["location_coordinates"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        bids: json["bids"],
        media: json["media"] == null
            ? []
            : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
        provider: json["provider"],
        service: json["service"],
        zones: json["zones"] == null
            ? []
            : List<dynamic>.from(json["zones"]!.map((x) => x)),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "duration": duration,
        "duration_unit": durationUnit,
        "required_servicemen": requiredServicemen,
        "initial_price": initialPrice,
        "final_price": finalPrice,
        "status": status,
        "service_id": serviceId,
        "user_id": userId,
        "provider_id": providerId,
        "created_by_id": createdById,
        "booking_date": bookingDate?.toIso8601String(),
        'user': user!.toJson(),
        "category_ids": categoryIds == null
            ? []
            : List<dynamic>.from(categoryIds!.map((x) => x)),
        "locations": locations,
        "location_coordinates": locationCoordinates,
        "created_at": createdAt?.toIso8601String(),
        "bids": bids,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "categories": category == null
            ? []
            : List<dynamic>.from(category!.map((x) => x.toJson())),
        "provider": provider,
        "service": service,
        "zones": zones == null ? [] : List<dynamic>.from(zones!.map((x) => x)),
      };
}
