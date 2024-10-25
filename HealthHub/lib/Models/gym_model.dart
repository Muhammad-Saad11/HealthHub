class GymModel {
  String gymId;
  String gymUID;
  List gymImages;
  String gymLocation;
  String gymName;
  int gymPrice;
  String gymDescription;
  String gymAddress;
  String gymNumber;
  Map<String, int> packages;

  GymModel({
    this.gymId = '',
    this.gymUID = '',
    this.gymImages = const [],
    this.gymLocation = '',
    this.gymName = '',
    this.gymPrice = 0,
    this.gymDescription = '',
    this.gymAddress = '',
    this.gymNumber = '',
    this.packages = const {},
  });
}
