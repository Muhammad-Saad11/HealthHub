class ProductModel {
  String productId;
  List productImages;
  String productName;
  int productPrice;
  int productQuantity;
  String productDescription;
  String vendorUID;
  Map productVariation;
  // int venueRating;
  // int venueFeedback;

  ProductModel({
    this.productId = '',
    this.productImages = const [],
    this.productName = '',
    this.productPrice = 0,
    this.productQuantity = 0,
    this.productDescription = '',
    this.vendorUID = '',
    this.productVariation = const {},
  });
}
