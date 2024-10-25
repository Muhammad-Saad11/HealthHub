class ProductOrder {

  var ProductImages;
  String ProductName;
  int ProductQuantity;
  int ProductPrice;
  String Productcategory;
  int deliveryCharges;
  String buyerId;
  String sellerId;

  ProductOrder({
    this.ProductImages='',
    this.ProductName='',
    this.ProductPrice=0,
    this.ProductQuantity=0,
    this.Productcategory='Custom',
    this.buyerId='',
    this.deliveryCharges=0,
    this.sellerId=''

  });

  int totalPrice(){
    return ProductQuantity * ProductPrice;
  }
}
