class CatalogModel {
  String? catalogID;
  int? userAvatar;

  CatalogModel({required this.catalogID, required this.userAvatar});

  CatalogModel.fromJson(Map<String, dynamic> map) {
    catalogID = map['cataloID'];
    userAvatar = map['userAvatar'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['catalogID'] = catalogID;
    data['userAvatar'] = userAvatar;

    return data;
  }
}
