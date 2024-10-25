class Booking {
  String venueId;
  String vendorUID;
  List venueImages;
  String venueLocation;
  String nutritionistName;
  int venuePrice;
  String nutritionistDescription;
  String nutritionistAddress;
  String nutritionistNumber;
  List inActiveDates;
  String vendorName;
  Map<String, int> menus;

  Booking({
    this.venueId = '',
    this.vendorUID = '',
    this.venueImages = const [],
    this.venueLocation = '',
    this.nutritionistName = '',
    this.venuePrice = 0,
    this.nutritionistDescription = '',
    this.nutritionistAddress = '',
    this.nutritionistNumber = '',
    this.inActiveDates = const [],
    this.vendorName = '',
    this.menus = const {},
  });
}
