import '../data_base/DatabaseHelper.dart';

class CardModel {
  int? cardId,cardOwnerId;
  String? cardHolderName,
      cardCompanyName,
      cardBankName,
      cardType,
      cardNumber,
      cardExpiryDate,
      cardCvv,
      cardGenerateDate,
      cardPaymentDate;
  double? cardLimit;

  CardModel(
      {
        this.cardId,
        this.cardOwnerId,
      this.cardHolderName,
      this.cardCompanyName,
      this.cardBankName,
      this.cardType,
      this.cardNumber,
      this.cardExpiryDate,
      this.cardCvv,
      this.cardGenerateDate,
      this.cardPaymentDate,
      this.cardLimit});

  CardModel.fromMap(Map<String, dynamic> map) {
    cardId = map[DatabaseHelper.cardId];
    cardOwnerId = map[DatabaseHelper.cardOwnerId];
    cardHolderName = map[DatabaseHelper.cardHolderName];
    cardCompanyName = map[DatabaseHelper.cardCompanyName];
    cardBankName = map[DatabaseHelper.cardBankName];
    cardType = map[DatabaseHelper.cardType];
    cardNumber = map[DatabaseHelper.cardNumber];
    cardExpiryDate = map[DatabaseHelper.cardExpiryDate];
    cardCvv = map[DatabaseHelper.cardCvv];
    cardGenerateDate = map[DatabaseHelper.cardGenerateDate];
    cardLimit = map[DatabaseHelper.cardLimit];
    cardPaymentDate = map[DatabaseHelper.cardPaymentDate];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.cardId: cardId,
      DatabaseHelper.cardOwnerId: cardOwnerId,
      DatabaseHelper.cardHolderName: cardHolderName,
      DatabaseHelper.cardCompanyName: cardCompanyName,
      DatabaseHelper.cardBankName: cardBankName,
      DatabaseHelper.cardType: cardType,
      DatabaseHelper.cardNumber: cardNumber,
      DatabaseHelper.cardExpiryDate: cardExpiryDate,
      DatabaseHelper.cardCvv: cardCvv,
      DatabaseHelper.cardGenerateDate: cardGenerateDate,
      DatabaseHelper.cardLimit: cardLimit,
      DatabaseHelper.cardPaymentDate: cardPaymentDate,
    };
  }
}
