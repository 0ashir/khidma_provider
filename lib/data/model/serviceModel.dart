class ServiceModel {
  String? id;
  String? userId;
  String? categoryId;
  String? parentId;
  String? categoryName;
  String? partnerName;
  String? tax;
  String? taxType;
  String? title;
  //String? translatedTitle;
  String? slug;
  String? description;
  //String? translatedDescription;
  String? tags;
  String? imageOfTheService;
  String? price;
  String? discountedPrice;
  String? numberOfMembersRequired;
  String? duration;
  String? durationType;
  String? averageRating;
  String? rating;
  String? numberOfRatings;
  String? onSiteAllowed;
  String? maxQuantityAllowed;
  String? isPayLaterAllowed;
  String? isDoorStepAllowed;
  String? isStoreAllowed;
  String? status;
  String? translatedStatus;
  String? isApprovedByAdmin;
  String? createdAt;
  String? cancelableTill;
  String? cancelable;
  String? isCancelable;
  String? inCartQuantity;
  String? taxId;
  String? taxTitle;
  String? translatedTaxTitle;
  String? taxPercentage;
  List<String>? otherImages;
  List<String>? files;
  String? longDescription;
  List<ServiceFaQs>? faqs;
  // Complete translated_fields structure
  Map<String, dynamic>? translatedFields;
  // SEO fields
  String? seoTitle;
  String? seoDescription;
  String? seoKeywords;
  String? seoSchemaMarkup;
  String? seoOgImage;

  ServiceModel({
    this.id,
    this.userId,
    this.categoryId,
    this.parentId,
    this.categoryName,
    this.partnerName,
    this.tax,
    this.taxType,
    this.title,
    this.slug,
    this.description,
    this.tags,
    this.imageOfTheService,
    this.price,
    this.discountedPrice,
    this.numberOfMembersRequired,
    this.duration,
    this.durationType,
    this.rating,
    this.averageRating,
    this.numberOfRatings,
    this.onSiteAllowed,
    this.maxQuantityAllowed,
    this.isPayLaterAllowed,
    this.isDoorStepAllowed,
    this.isStoreAllowed,
    this.status,
    this.translatedStatus,
    this.createdAt,
    this.cancelableTill,
    this.cancelable,
    this.isCancelable,
    this.taxId,
    this.taxPercentage,
    this.taxTitle,
    this.translatedTaxTitle,
    this.inCartQuantity,
    this.otherImages,
    this.files,
    this.longDescription,
    this.faqs,
    this.translatedFields,
    this.isApprovedByAdmin,
    this.seoTitle,
    this.seoDescription,
    this.seoKeywords,
    this.seoSchemaMarkup,
    this.seoOgImage,
  });

  ServiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '0';
    userId = json['user_id'].toString();
    categoryId = json['category_id'].toString();
    parentId = json['parent_id'].toString();
    categoryName = json['category_name'].toString();
    partnerName = json['partner_name'].toString();
    tax = json['tax'].toString();
    taxType = json['tax_type'].toString();
    title = json['title'].toString();
    slug = json['slug'].toString();
    description = json['description'].toString();
    tags = json['tags'].toString();
    imageOfTheService = json['image_of_the_service'].toString();
    price = json['price']?.toString() ?? '0';
    discountedPrice = json['discounted_price']?.toString() ?? '0';
    numberOfMembersRequired =
        json['number_of_members_required']?.toString() ?? '1';
    duration = json['duration']?.toString() ?? '0';
    durationType = json['duration_type']?.toString() ?? 'minutes';
    averageRating = (json['average_rating'] ?? '0').toString();
    rating = (json['rating'] ?? '0').toString();
    numberOfRatings = (json['total_ratings'] ?? "0").toString();
    onSiteAllowed = json['on_site_allowed'].toString();
    maxQuantityAllowed = json['max_quantity_allowed'].toString();
    isPayLaterAllowed = json['is_pay_later_allowed'].toString();
    isStoreAllowed = json['at_store'].toString();
    isDoorStepAllowed = json['at_doorstep'].toString();
    status = json['status'].toString();
    translatedStatus = json['translated_status'].toString();
    isApprovedByAdmin = json['approved_by_admin'].toString();
    createdAt = json['created_at'].toString();
    cancelableTill = json['cancelable_till'].toString();
    cancelable = json['cancelable'].toString();
    isCancelable = json['is_cancelable'].toString();
    inCartQuantity = json['in_cart_quantity'].toString();
    taxId = json['tax_id'].toString();
    taxTitle = json['tax_title'].toString();
    translatedTaxTitle =
        json['translated_tax_title']?.toString().isEmpty ?? true
        ? null
        : json['translated_tax_title'].toString();
    taxPercentage = json['tax_percentage'].toString();
    otherImages = (json["other_images"] ?? [])
        .map<String>((e) => e.toString())
        .toList();
    files = json.containsKey("files")
        ? json["files"].map<String>((e) => e.toString()).toList()
        : [];

    faqs = json.containsKey("faqs")
        ? json["faqs"] != ''
              ? json["faqs"]
                    .map<ServiceFaQs>((e) => ServiceFaQs.fromJson(e))
                    .toList()
              : []
        : [];

    longDescription = json["long_description"]?.toString() ?? '';

    // Store complete translated_fields structure
    translatedFields = json['translated_fields'] != null
        ? Map<String, dynamic>.from(json['translated_fields'])
        : null;

    // SEO fields
    seoTitle = json['seo_title']?.toString() ?? '';
    seoDescription = json['seo_description']?.toString() ?? '';
    seoKeywords = json['seo_keywords']?.toString() ?? '';
    seoSchemaMarkup = json['seo_schema_markup']?.toString() ?? '';
    seoOgImage = json['seo_og_image']?.toString() ?? '';
  }

  void copyFrom(ServiceModel other) {
    id = other.id;
    userId = other.userId;
    categoryId = other.categoryId;
    parentId = other.parentId;
    categoryName = other.categoryName;
    partnerName = other.partnerName;
    tax = other.tax;
    taxType = other.taxType;
    title = other.title;
    slug = other.slug;
    description = other.description;
    tags = other.tags;
    imageOfTheService = other.imageOfTheService;
    price = other.price;
    discountedPrice = other.discountedPrice;
    numberOfMembersRequired = other.numberOfMembersRequired;
    duration = other.duration;
    durationType = other.durationType;
    averageRating = other.averageRating;
    rating = other.rating;
    numberOfRatings = other.numberOfRatings;
    onSiteAllowed = other.onSiteAllowed;
    maxQuantityAllowed = other.maxQuantityAllowed;
    isPayLaterAllowed = other.isPayLaterAllowed;
    isDoorStepAllowed = other.isDoorStepAllowed;
    isStoreAllowed = other.isStoreAllowed;
    status = other.status;
    translatedStatus = other.translatedStatus;
    isApprovedByAdmin = other.isApprovedByAdmin;
    createdAt = other.createdAt;
    cancelableTill = other.cancelableTill;
    cancelable = other.cancelable;
    isCancelable = other.isCancelable;
    inCartQuantity = other.inCartQuantity;
    taxId = other.taxId;
    taxTitle = other.taxTitle;
    translatedTaxTitle = other.translatedTaxTitle;
    taxPercentage = other.taxPercentage;
    otherImages = other.otherImages != null
        ? List.from(other.otherImages!)
        : null;
    files = other.files != null ? List.from(other.files!) : null;
    longDescription = other.longDescription;
    faqs = other.faqs != null ? List.from(other.faqs!) : null;
    // Copy translated fields
    translatedFields = other.translatedFields != null
        ? Map<String, dynamic>.from(other.translatedFields!)
        : null;
    // SEO fields
    seoTitle = other.seoTitle;
    seoDescription = other.seoDescription;
    seoKeywords = other.seoKeywords;
    seoSchemaMarkup = other.seoSchemaMarkup;
    seoOgImage = other.seoOgImage;
  }

  static const Map<String, String> durationTypeLabelKeys = {
    'minutes': 'minutesLbl',
    'hours': 'hoursLbl',
    'days': 'daysLbl',
  };

  String get durationTypeLabelKey =>
      durationTypeLabelKeys[durationType] ?? 'minutesLbl';

  // Helper methods to get translated data based on current language
  String? getTranslatedTitle(String languageCode) {
    return translatedFields?['title']?[languageCode]?.toString();
  }

  String? getTranslatedDescription(String languageCode) {
    return translatedFields?['description']?[languageCode]?.toString();
  }

  String? getTranslatedTags(String languageCode) {
    final tagsData = translatedFields?['tags']?[languageCode];
    if (tagsData is List) {
      return tagsData.join(',');
    }
    return tagsData?.toString();
  }

  String? getTranslatedLongDescription(String languageCode) {
    return translatedFields?['long_description']?[languageCode]?.toString();
  }

  List<ServiceFaQs>? getTranslatedFaqs(String languageCode) {
    final faqsData = translatedFields?['faqs']?[languageCode];
    if (faqsData is List) {
      return faqsData.map<ServiceFaQs>((e) => ServiceFaQs.fromJson(e)).toList();
    }
    return null;
  }
}

class ServiceFaQs {
  String? question;
  String? answer;

  ServiceFaQs({this.question, this.answer});

  factory ServiceFaQs.fromJson(Map<String, dynamic> json) => ServiceFaQs(
    question: json["question"].toString(),
    answer: json["answer"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "question": question.toString(),
    "answer": answer.toString(),
  };
}
