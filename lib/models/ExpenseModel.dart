import '../data_base/DatabaseHelper.dart';

class ExpenseModel {
  int? expenseID, cardId, cardOwnerId;
  String? expensePaymentType,
      expenseDate,
      expenseTransactionID,
      expenseDescription;
  double? expenseAmount;

  ExpenseModel(
      {this.expenseID,
      this.cardId,
      this.cardOwnerId,
      this.expenseAmount,
      this.expensePaymentType,
      this.expenseDate,
      this.expenseTransactionID,
      this.expenseDescription});

  ExpenseModel.fromMap(Map<String, dynamic> map) {
    expenseID = map[DatabaseHelper.expenseID];
    cardId = map[DatabaseHelper.cardId];
    cardOwnerId = map[DatabaseHelper.cardOwnerId];
    expenseAmount = map[DatabaseHelper.expenseAmount];
    expensePaymentType = map[DatabaseHelper.expensePaymentType];
    expenseDate = map[DatabaseHelper.expenseDate];
    expenseTransactionID = map[DatabaseHelper.expenseTransactionID];
    expenseDescription = map[DatabaseHelper.expenseDescription];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.expenseID: expenseID,
      DatabaseHelper.cardId: cardId,
      DatabaseHelper.cardOwnerId: cardOwnerId,
      DatabaseHelper.expenseAmount: expenseAmount,
      DatabaseHelper.expensePaymentType: expensePaymentType,
      DatabaseHelper.expenseDate: expenseDate,
      DatabaseHelper.expenseTransactionID: expenseTransactionID,
      DatabaseHelper.expenseDescription: expenseDescription,
    };
  }
}
