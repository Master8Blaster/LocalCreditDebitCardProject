import '../data_base/DatabaseHelper.dart';

class CardOwnerModel {
  int? id;
  String? ownerName;

  CardOwnerModel(this.id, this.ownerName);

  CardOwnerModel.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseHelper.cardOwnerId];
    ownerName = map[DatabaseHelper.cardOwnerName];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.cardOwnerId: id,
      DatabaseHelper.cardOwnerName: ownerName,
    };
  }
}
