import 'package:crust/models/store.dart';
import 'package:crust/models/store_group.dart';
import 'package:crust/utils/enum_util.dart';

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
