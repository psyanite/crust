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
  });

  String bannerText() {
    var today = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var firstDay = this.validFrom;
    var lastDay = this.validUntil;
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

  String locationText() {
    var store = this.store;
    if (store != null) {
      var text = store.name;
      if (store.suburb != null) text = '$text · ${store.suburb}';
      text = '$text, ${store.location}';
      return text;
    }
    var stores = this.storeGroup.stores;
    var text = stores.take(2).map((s) {
      return s.suburb != null ? s.suburb : s.location;
    }).join(', ');
    text = '${this.storeGroup.name} · $text';
    if (stores.length > 2) text = '$text, +${stores.length - 2} locations';
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
    );
  }
}

enum RewardType { one_time }
