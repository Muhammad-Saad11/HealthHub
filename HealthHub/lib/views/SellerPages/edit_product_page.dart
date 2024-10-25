import 'package:bgmfitness/ViewModels/Vendor/add_product_model.dart';
import 'package:bgmfitness/ViewModels/Vendor/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants.dart';

class ProductEditPage extends StatefulWidget {
  final productData;
  const ProductEditPage({Key? key, required this.productData})
      : super(key: key);

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  ProductModel productModel = ProductModel();

  late bool isPrivate = widget.productData["isPrivate"];
  late String category = widget.productData["productCategory"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              buildProductName(),
              buildProductDes(),
              buildAddress(),
              buildProductPrice(),
              buildProductVariation(),
              buildProductWeight(),
              buildProductDelivery(),
              const SizedBox(
                height: 20,
              ),
              buildDivider(),
              buildContactInfo(),
              buildNumber(),
              buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 30.0, bottom: 10.0, left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();

                try {
                  updateProductData(
                      productId: widget.productData['productId'],
                      productLocation: productModel.productAddress,
                      productName: productModel.productName,
                      productPrice: productModel.productPrice,
                      productDescription: productModel.productDescription,
                      productNumber: productModel.productNumber,
                      productQuantity: productModel.availableQuantity,
                      productSize: productModel.productSize,
                      productCategory: category,
                      productDelivery: productModel.productDelivery,
                      isPrivate: isPrivate);

                  Navigator.pushNamedAndRemoveUntil(
                      context, 'StreamPage', (route) => false);
                } catch (error) {
                  Fluttertoast.showToast(
                    msg: error.toString(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    fontSize: 15,
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text(
              "Submit",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildNumber() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 20,
            child: const Icon(
              size: 25,
              color: Colors.white,
              Icons.numbers,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              initialValue: widget.productData['sellerNumber'],
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
              decoration: const InputDecoration(
                labelText: "Mobile Number",
                hintText: "Enter Mobile Number",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty || !RegExp(r"^\d{11}$").hasMatch(value)) {
                  return "Enter Number eg: 0333xxx";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => productModel.productNumber = value!),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildContactInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildAddress() {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 20,
            child:  Icon(
              size: 25.sp,
              color: Colors.white,
              Icons.add_location_alt,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              initialValue: widget.productData["productAddress"],
              decoration:  InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w400),
                hintText: "Shop Address",
                labelText: "Address",
                labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[a-zA-Z0-9\s.,#\-]+$").hasMatch(value)) {
                  return "Enter Address";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => productModel.productAddress = value!),
            ),
          ),
        ],
      ),
    );
  }

  Divider buildDivider() {
    return Divider(
      thickness: 1,
      color: kPurple.withOpacity(0.2),
    );
  }

  Padding buildProductName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 20,
            child: const Icon(
              size: 25,
              color: Colors.white,
              Icons.add_box_rounded,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              initialValue: widget.productData["productName"],
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w400),
                hintText: "Product Name",
                labelText: "Product",
                labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[a-zA-Z0-9\s.,#\-]+$").hasMatch(value)) {
                  return "Enter Product Name";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => productModel.productName = value!),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildProductDes() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 20,
            child: const Icon(
              size: 25,
              color: Colors.white,
              Icons.description,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              initialValue: widget.productData["productDescription"],
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w400),
                hintText: "Tell us about your product",
                labelText: "Description",
                labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter Description";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => productModel.productDescription = value!),
            ),
          ),
        ],
      ),
    );
  }
  Padding buildProductPrice() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 20,
            child: const Icon(
              size: 30,
              color: Colors.white,
              Icons.attach_money,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              initialValue: widget.productData["productPrice"].toString(),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w400),
                hintText: "Price of Product",
                labelText: "Price",
                labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return "Enter Price";
                } else {
                  return null;
                }
              },
              onSaved: (value) => setState(
                      () => productModel.productPrice = int.parse(value!)),
            ),
          ),
        ],
      ),
    );
  }
  Padding buildProductWeight() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 20,
            child: const Icon(
              size: 30,
              color: Colors.white,
              Icons.adb_rounded,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              initialValue: widget.productData["productSize"],
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w400),
                hintText: "Product Weight",
                labelText: "Weight",
                labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[a-zA-Z0-9\s.,#\-]+$").hasMatch(value)) {
                  return "Enter Product Weight";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => productModel.productSize = value!),
            ),
          ),
        ],
      ),
    );
  }
  Padding buildProductDelivery() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 20,
            child: const Icon(
              size: 30,
              color: Colors.white,
              Icons.delivery_dining,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              initialValue: widget.productData["productDelivery"].toString(),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w400),
                hintText: "Product Delivery Price",
                labelText: "Delivery",
                labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return "Enter Product Delivery Price";
                } else {
                  return null;
                }
              },
              onSaved: (value) => setState(
                      () => productModel.productDelivery = int.parse(value!)),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildProductVariation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
                radius: 20,
                child: const Icon(
                  size: 25,
                  color: Colors.white,
                  Icons.add_business,
                ),
              ),
              const SizedBox(
                width: 18,
              ),
              Expanded(
                  child:Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: DropdownButton<String>(
                        underline: Container(
                          height: 1,
                          color: Colors.white,
                        ),
                        value: category,
                        items: [
                          DropdownMenuItem(
                            child: Text("Whey Protein"),
                            value: "Whey Protein",
                          ),
                          DropdownMenuItem(
                            child: Text("Amino Acids"),
                            value: "Amino",
                          ),
                        ],
                        onChanged: (val){
                          setState(() {
                            category = val!;
                            print(category);
                          });
                        }
                    ),
                  )
              ),
              const SizedBox(
                width: 18,
              ),
              Expanded(
                child: TextFormField(
                  // controller: controller,
                  initialValue: widget.productData["availableQuantity"].toString(),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w400),
                    hintText: "eg: 50",
                    labelText: "Quantity",
                    labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return "Enter Quantity";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) => setState(() =>
                  productModel.availableQuantity = int.parse(value!)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
