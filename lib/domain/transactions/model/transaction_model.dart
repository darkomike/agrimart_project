class TransactionField {
  static String transactionID = 'transactionID';
  static String transactionAmount = 'transactionAmount';
  static String transactionTimeStamp = 'transactionTimeStamp';
  static String transactionStatus = 'transactionStatus';
  static String transactionSeller = 'transactionTo';
  static String transactionBuyer = 'transactionFrom';
}

class TransactionModel {
  String transactionID = '';
  String transactionTimeStamp = '';
  String transactionAmount = '';
  int transactionStatus = 0;
  String transactionSeller = '';
  String transactionBuyer = '';

  TransactionModel(
      {required this.transactionSeller,
      required this.transactionStatus,
      required this.transactionID,
      required this.transactionAmount,
      required this.transactionTimeStamp,
      required this.transactionBuyer});

  TransactionModel.fromJson(Map<String, dynamic> map) {
    transactionID = map[TransactionField.transactionID];
    transactionTimeStamp = map[TransactionField.transactionTimeStamp];
    transactionAmount = map[TransactionField.transactionAmount];
    transactionStatus = map[TransactionField.transactionStatus];
    transactionSeller = map[TransactionField.transactionSeller];
    transactionBuyer = map[TransactionField.transactionBuyer];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data[TransactionField.transactionID] = transactionID;
    data[TransactionField.transactionAmount] = transactionAmount;
    data[TransactionField.transactionTimeStamp] = transactionTimeStamp;
    data[TransactionField.transactionStatus] = transactionStatus;
    data[TransactionField.transactionBuyer] = transactionBuyer;
    data[TransactionField.transactionSeller] = transactionSeller;

    return data;
  }
}
