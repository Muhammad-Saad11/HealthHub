class ProductModel {
  int availableQuantity;
  bool isPrivate;
  String productAddress;
  String productCategory;
  int productDelivery;
  String productDescription;
  String productEmail;
  int productFeedback;
  String productId;
  List productImages;
  String productName;
  String productNumber;
  int productPrice;
  int productRating;
  String productSize;
  String productUID;

  ProductModel({
    this.availableQuantity = 0,
    this.isPrivate = false,
    this.productAddress = '',
    this.productCategory = '',
    this.productDelivery = 0,
    this.productDescription = '',
    this.productEmail = '',
    this.productFeedback = 0,
    this.productId = '',
    this.productImages = const [],
    this.productName = '',
    this.productNumber = '',
    this.productPrice = 0,
    this.productRating = 0,
    this.productSize = '',
    this.productUID = '',
  });
}
