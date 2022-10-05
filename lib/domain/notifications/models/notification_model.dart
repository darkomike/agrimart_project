class NotificationField {
  static String notificationTitle = 'notificationTitle';
  static String notificationID = 'notificationID';
  static String notificationTimeStamp = 'notificationTimeStamp';
  static String notificationOpened = 'notificationOpened';
  static String notificationMessage = 'notificationMessage';
}

class NotificationModel {
  String? notificationTitle;
  String? notificationID;
  String? notificationTimeStamp;
  String? notificationMessage;
  bool? notificationOpened;

  NotificationModel(
      {this.notificationTimeStamp, this.notificationOpened,
      this.notificationID,
      this.notificationTitle,
      this.notificationMessage});

  NotificationModel.fromJson(Map<String, dynamic> map) {
    notificationTitle = map[NotificationField.notificationTitle];
    notificationTimeStamp = map[NotificationField.notificationTimeStamp];
    notificationID = map[NotificationField.notificationID];
    notificationOpened = map[NotificationField.notificationOpened];
    notificationMessage = map[NotificationField.notificationMessage];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data[NotificationField.notificationMessage] = notificationMessage;
    data[NotificationField.notificationID] = notificationID;
    data[NotificationField.notificationOpened] = notificationOpened;
    data[NotificationField.notificationTimeStamp] = notificationTimeStamp;
    data[NotificationField.notificationTitle] = notificationTitle;

    return data;
  }
}
