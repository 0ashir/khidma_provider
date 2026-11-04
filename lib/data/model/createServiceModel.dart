import 'dart:convert';
import 'package:edemand_partner/app/generalImports.dart';

class CreateServiceModel {
  CreateServiceModel({
    this.title,
    this.serviceId,
    this.description,
    this.price,
    this.duration,
    this.durationType,
    this.maxQty,
    this.image,
    this.tags,
    this.members,
    this.categories,
    this.iscancelable,
    this.is_pay_later_allowed,
    this.isDoorStepAllowed,
    this.isStoreAllowed,
    this.discounted_price,
    this.tax_type,
    this.tax,
    this.cancelableTill,
    this.taxId,
    this.other_images,
    this.files,
    this.long_description,
    this.faqs,
    this.status,
    this.slug,
    this.seoTitle,
    this.seoDescription,
    this.seoKeywords,
    this.seoSchemaMarkup,
    this.seoOgImage,
    this.deletedFiles,
    this.deletedOtherImages,
    // Multi-language fields
    this.translatedTitles,
    this.translatedDescriptions,
    this.translatedTags,
    this.translatedLongDescriptions,
    this.translatedFaqs,
    // New nested structure
    this.translatedFields,
  });
  String? serviceId;
  String? title;
  String? description;
  String? price;
  int? duration;
  String? durationType;
  String? maxQty;
  String? tags;
  String? members;
  String? categories;
  String? cancelableTill;
  int? iscancelable;
  int? is_pay_later_allowed;
  int? isStoreAllowed;
  int? isDoorStepAllowed;
  String? discounted_price;
  String? tax_type;
  String? status;
  String? taxId;
  int? tax;
  dynamic image;
  List<String>? other_images;
  List<String>? files;
  String? long_description;
  List<ServiceFaQs>? faqs;
  String? slug;
  // SEO fields
  String? seoTitle;
  String? seoDescription;
  String? seoKeywords;
  String? seoSchemaMarkup;
  dynamic seoOgImage;

  List<String>? deletedOtherImages;
  List<String>? deletedFiles;

  // Multi-language translation fields
  Map<String, String>? translatedTitles;
  Map<String, String>? translatedDescriptions;
  Map<String, String>? translatedTags;
  Map<String, String>? translatedLongDescriptions;
  Map<String, List<Map<String, String>>>? translatedFaqs;

  // New nested translated fields structure
  Map<String, dynamic>? translatedFields;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (serviceId != '' && serviceId != null) {
      data['service_id'] = serviceId;
    }

    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['duration'] = duration;
    data['duration_type'] = durationType;
    data['max_qty'] = maxQty;
    data['tags'] = tags;
    data['members'] = members;
    data['categories'] = categories;
    data['cancelable_till'] = cancelableTill;
    data['is_cancelable'] = iscancelable;
    data['pay_later'] = is_pay_later_allowed;
    data['at_store'] = isStoreAllowed;
    data['at_doorstep'] = isDoorStepAllowed;
    data['discounted_price'] = discounted_price;
    data['tax_type'] = tax_type;
    data['image'] = image;
    data['tax'] = tax;
    data['tax_id'] = taxId;
    data['status'] = status;
    data['slug'] = slug;

    if (long_description != null) {
      data['long_description'] = long_description;
    }

    if (faqs != null) {
      for (int i = 0; i < faqs!.length; i++) {
        data['faqs[$i][question]'] = faqs![i].question;
        data['faqs[$i][answer]'] = faqs![i].answer;
      }
    }
    final List<String> tagList = tags!.split(',');
    for (int i = 0; i < tagList.length; i++) {
      data['tags[$i]'] = tagList[i];
    }

    if (deletedOtherImages != null && deletedOtherImages!.isNotEmpty) {
      data['images_to_delete'] = deletedOtherImages;
    }
    if (deletedFiles != null && deletedFiles!.isNotEmpty) {
      data['files_to_delete'] = deletedFiles;
    }

    if (other_images != null && other_images!.isNotEmpty) {
      data['other_images'] = other_images;
    }
    if (files != null && files!.isNotEmpty) {
      data['files'] = files;
    }
    data['files'] = files;

    // SEO fields
    if (seoTitle != null && seoTitle!.isNotEmpty) {
      data['seo_title'] = seoTitle;
    }
    if (seoDescription != null && seoDescription!.isNotEmpty) {
      data['seo_description'] = seoDescription;
    }
    if (seoKeywords != null && seoKeywords!.isNotEmpty) {
      data['seo_keywords'] = seoKeywords;
    }
    if (seoSchemaMarkup != null && seoSchemaMarkup!.isNotEmpty) {
      data['seo_schema_markup'] = seoSchemaMarkup;
    }
    if (seoOgImage != null) {
      data['seo_og_image'] = seoOgImage;
    }

    // Handle new nested translated_fields structure
    if (translatedFields != null && translatedFields!.isNotEmpty) {
      // Encode translated_fields as JSON string for API
      data['translated_fields'] = jsonEncode(translatedFields);
    }

    return data;
  }

  // Utility method to create nested translated_fields structure
  // Format: field_name -> language_code -> value
  // Note: The API requires title, description, tags, and faqs to always be present
  static Map<String, dynamic> createTranslatedFields({
    Map<String, String>? titles,
    Map<String, String>? descriptions,
    Map<String, String>? tags,
    Map<String, String>? longDescriptions,
    Map<String, List<Map<String, String>>>? faqs,
    Map<String, String>? companyNames,
    Map<String, String>? aboutProvider,
    // Fallback values for required fields
    String? defaultTitle,
    String? defaultDescription,
    String? defaultTags,
    String? defaultLanguageCode,
  }) {
    final Map<String, dynamic> translatedFields = {};

    // Add titles - REQUIRED by API (but only include languages that have actual data)
    final Map<String, String> titleTranslations = {};
    if (titles != null && titles.isNotEmpty) {
      titles.forEach((langCode, title) {
        if (title.isNotEmpty) {
          titleTranslations[langCode] = title;
        }
      });
    }
    // Only ensure default language exists if no titles at all
    if (titleTranslations.isEmpty &&
        defaultTitle != null &&
        defaultTitle.isNotEmpty) {
      titleTranslations[defaultLanguageCode ?? 'en'] = defaultTitle;
    }
    // Always include title field (API requirement) even if empty
    if (titleTranslations.isEmpty) {
      titleTranslations[defaultLanguageCode ?? 'en'] = '';
    }
    translatedFields['title'] = titleTranslations;

    // Add descriptions - REQUIRED by API (but only include languages that have actual data)
    final Map<String, String> descriptionTranslations = {};
    if (descriptions != null && descriptions.isNotEmpty) {
      descriptions.forEach((langCode, description) {
        if (description.isNotEmpty) {
          descriptionTranslations[langCode] = description;
        }
      });
    }
    // Only ensure default language exists if no descriptions at all
    if (descriptionTranslations.isEmpty &&
        defaultDescription != null &&
        defaultDescription.isNotEmpty) {
      descriptionTranslations[defaultLanguageCode ?? 'en'] = defaultDescription;
    }
    // Always include description field (API requirement) even if empty
    if (descriptionTranslations.isEmpty) {
      descriptionTranslations[defaultLanguageCode ?? 'en'] = '';
    }
    translatedFields['description'] = descriptionTranslations;

    // Add tags - REQUIRED by API (but only include languages that have actual data)
    final Map<String, String> tagTranslations = {};
    if (tags != null && tags.isNotEmpty) {
      tags.forEach((langCode, tagString) {
        if (tagString.isNotEmpty) {
          tagTranslations[langCode] = tagString;
        }
      });
    }
    // Only ensure default language exists if no tags at all
    if (tagTranslations.isEmpty &&
        defaultTags != null &&
        defaultTags.isNotEmpty) {
      tagTranslations[defaultLanguageCode ?? 'en'] = defaultTags;
    }
    // Always include tags field (API requirement) even if empty
    if (tagTranslations.isEmpty) {
      tagTranslations[defaultLanguageCode ?? 'en'] = '';
    }
    translatedFields['tags'] = tagTranslations;

    // Add long descriptions if exists
    if (longDescriptions != null && longDescriptions.isNotEmpty) {
      final Map<String, String> longDescTranslations = {};
      longDescriptions.forEach((langCode, longDesc) {
        if (longDesc.isNotEmpty) {
          longDescTranslations[langCode] = longDesc;
        }
      });
      if (longDescTranslations.isNotEmpty) {
        translatedFields['long_description'] = longDescTranslations;
      }
    }

    // Add company names if exists
    if (companyNames != null && companyNames.isNotEmpty) {
      final Map<String, String> companyNameTranslations = {};
      companyNames.forEach((langCode, companyName) {
        if (companyName.isNotEmpty) {
          companyNameTranslations[langCode] = companyName;
        }
      });
      if (companyNameTranslations.isNotEmpty) {
        translatedFields['company_name'] = companyNameTranslations;
      }
    }

    // Add about provider if exists
    if (aboutProvider != null && aboutProvider.isNotEmpty) {
      final Map<String, String> aboutProviderTranslations = {};
      aboutProvider.forEach((langCode, about) {
        if (about.isNotEmpty) {
          aboutProviderTranslations[langCode] = about;
        }
      });
      if (aboutProviderTranslations.isNotEmpty) {
        translatedFields['about'] = aboutProviderTranslations;
      }
    }

    // Add FAQs if exists - organize by language but keep as nested structure
    if (faqs != null && faqs.isNotEmpty) {
      final Map<String, List<Map<String, String>>> faqTranslations = {};
      faqs.forEach((langCode, faqList) {
        final List<Map<String, String>> validFaqs = [];
        for (final faq in faqList) {
          final question = faq['question'];
          final answer = faq['answer'];
          if (question?.isNotEmpty == true && answer?.isNotEmpty == true) {
            validFaqs.add({'question': question!, 'answer': answer!});
          }
        }
        if (validFaqs.isNotEmpty) {
          faqTranslations[langCode] = validFaqs;
        }
      });
      if (faqTranslations.isNotEmpty) {
        translatedFields['faqs'] = faqTranslations;
      }
    }

    return translatedFields;
  }
}
