import 'package:crust/models/store.dart';
import 'package:crust/models/store_group.dart';
import 'package:crust/utils/enum_util.dart';
import 'package:intl/intl.dart';

class Reward {
  final int id;
  final String name;
  final String description;
  final RewardType type;
  final Store store;
  final StoreGroup storeGroup;
  final DateTime validFrom;
  final DateTime validUntil;
  final String promoImage;
  final String termsAndConditions;
  final bool hidden;

  Reward({
    this.id,
    this.name,
    this.description,
    this.type,
    this.store,
    this.storeGroup,
    this.validFrom,
    this.validUntil,
    this.promoImage,
    this.termsAndConditions,
    this.hidden,
  });

  bool isExpired() {
    var today = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var lastDay = this.validUntil;
    return lastDay == null || lastDay.isBefore(today);
  }

  bool isHidden() {
    return hidden;
  }

  String bannerText() {
    var lastDay = this.validUntil;
    if (isExpired() == true) return 'Expired ${DateFormat.MMMEd("en_US").format(lastDay)}';

    var today = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var firstDay = this.validFrom;
    if (firstDay != null && lastDay != null) {
      if (firstDay == lastDay) {
        if (today == firstDay) return 'Only available TODAY. Get in quick!';
        return 'Coming Soon · ${DateFormat.MMMEd("en_US").format(firstDay)} · One Day Only';
      } else {
        if (firstDay.isBefore(today)) return 'Hurry! Only available until ${DateFormat.MMMEd("en_US").format(lastDay)}';
        return 'Coming Soon · ${DateFormat.MMMEd("en_US").format(firstDay)} - ${DateFormat.MMMEd("en_US").format(lastDay)}';
      }
    } else if (firstDay == null) {
      return 'Available today until ${DateFormat.MMMEd("en_US").format(lastDay)}';
    } else {
      return 'Available from the ${DateFormat.MMMEd("en_US").format(firstDay)}';
    }
  }

  String storeNameText() {
    return this.store?.name ?? this.storeGroup.name;
  }

  String locationText() {
    var store = this.store;
    if (store != null) {
      var text = '';
      if (store.suburb != null) text += '${store.suburb}';
      if (store.location != null) text += ', ${store.location}';
      return text;
    }
    var stores = this.storeGroup.stores;
    var text = stores.take(2).map((s) {
      return s.suburb != null ? s.suburb : s.location;
    }).join(', ');
    if (stores.length > 2) text += ', +${stores.length - 2} locations';
    return text;
  }

  factory Reward.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    return Reward(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: EnumUtil.fromString(RewardType.values, json['type']),
      store: Store.fromToaster(json['store']),
      storeGroup: StoreGroup.fromToaster(json['store_group']),
      validFrom: json['valid_from'] != null ? DateTime.parse(json['valid_from']) : null,
      validUntil: json['valid_until'] != null ? DateTime.parse(json['valid_until']) : null,
      promoImage: json['promo_image'],
      termsAndConditions: json['terms_and_conditions'],
      hidden: json['hidden'],
    );
  }

  static const attributes = """
    id,
    name,
    description,
    type,
    store {
      id,
      name,
      phone_number,
      cover_image,
      address {
        address_first_line,
        address_second_line,
        address_street_number,
        address_street_name,
      },
      location {
        id,
        name,
      },
      suburb {
        id,
        name,
      },
      cuisines {
        id,
        name,
      },
      ratings {
        heart_ratings,
        okay_ratings,
        burnt_ratings
      }
    },
    store_group {
      id,
      name,
      stores {
        id,
        name,
        phone_number,
        cover_image,
        address {
          address_first_line,
          address_second_line,
          address_street_number,
          address_street_name,
        },
        location {
          id,
          name,
        },
        suburb {
          id,
          name,
        },
        cuisines {
          id,
          name,
        },
        ratings {
          heart_ratings,
          okay_ratings,
          burnt_ratings
        }
      }
    },
    valid_from,
    valid_until,
    promo_image,
    terms_and_conditions,
    hidden,
  """;
}

enum RewardType { one_time }
