import 'dart:io';
import 'package:bgmfitness/ViewModels/Vendor/nutritionist_provider.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../Models/bookings.dart';
import '../../constants.dart';


class EditNutritionistPage extends StatefulWidget {
  final nutritionistData;
  const EditNutritionistPage({this.nutritionistData});

  @override
  State<EditNutritionistPage> createState() => _EditNutritionistPageState();
}

class _EditNutritionistPageState extends State<EditNutritionistPage> {
  @override
  void dispose() {
    menuDesController.dispose();
    menuCostController.dispose();
    super.dispose();
  }

  final menuFormKey = GlobalKey<FormState>();
  Map<String, int> packagesMap = {};
  int cost = 0;
  String menu = '';
  TextEditingController menuDesController = TextEditingController();
  TextEditingController menuCostController = TextEditingController();
  List<String> inActiveDates = [];
  late Map<String, dynamic> menuMap = widget.nutritionistData["menus"];
  final today = DateUtils.dateOnly(DateTime.now());
  List<DateTime?> _multiDatePickerValueWithDefaultValue = [];

  List<String> temp = [];

  String imageUrl = "";

  List<String> cityList = [
    'Jhelum',
    'Sheikhupura',
    'Karachi',
    'Lahore',
    'Islamabad',
    'Rawalpindi',
    'Faisalabad',
    'Multan',
    'Hyderabad',
    'Peshawar',
    'Quetta',
    'Gujranwala',
    'Sialkot',
    'Abbottabad',
    'Bahawalpur',
    'Sukkur',
    'Larkana'
  ];
  late String venueLocation = widget.nutritionistData["nutritionistsLocation"];
  String nutritionistLocation = 'Location';

  Booking nutritionistModel = Booking();
  final formKey = GlobalKey<FormState>();

  List<String> listOfUrls = [];
  File? image;
  final imagePicker = ImagePicker();
  bool isUploading = false;
  late bool isPrivate = widget.nutritionistData["isPrivate"];

  void initState() {
    // TODO: implement initState
    super.initState();
    nutritionistLocation = widget.nutritionistData['nutritionistsLocation'];
    var temp = widget.nutritionistData['nutritionistsPackages'] as Map<String, dynamic>;
    packagesMap = Map<String, int>.from(temp);
    var dates = widget.nutritionistData['inActiveDates'] as List<dynamic>;
    for(int i = 0;i<dates.length;i++){
      _multiDatePickerValueWithDefaultValue.add(DateTime.parse(dates[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              buildLocation(),
              buildDivider(),
              buildNutritionistName(),
              buildNutritionistDes(),
              buildAddress(),
              buildDates(context),
              buildPackages(context),
              buildContactInfo(),
              buildNumber(),
              buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }


  Padding buildDates(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet<dynamic>(
                backgroundColor: Colors.white.withOpacity(0),
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder:
                        (BuildContext context, StateSetter setModalState) =>
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: buildDefaultMultiDatePickerWithValue(),
                        ),
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text(
              "Select Non Active Dates",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDefaultMultiDatePickerWithValue() {
    final config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.multi,
      selectedDayHighlightColor: Colors.indigo,
      firstDate: DateTime.now(),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Select Dates On Which Your Nutritionist Is Not Available'),
        CalendarDatePicker2(
          config: config,
          value: _multiDatePickerValueWithDefaultValue,
          onValueChanged: (dates) => setState(
                () {
              _multiDatePickerValueWithDefaultValue = dates;

              List<DateTime> filter(List<DateTime?> input) {
                input.removeWhere((e) => e == null);
                return List<DateTime>.from(input);
              }

              List<DateTime> filteredList =
              filter(_multiDatePickerValueWithDefaultValue);

              List<String> DateTimeListAsString =
              filteredList.map((data) => data.toString()).toList();
              inActiveDates = DateTimeListAsString;
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
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
              if (nutritionistLocation == 'Location') {
                Fluttertoast.showToast(
                  msg: 'Please select location!',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey.shade900,
                  fontSize: 15,
                );
              }
              if (packagesMap.isEmpty) {
                Fluttertoast.showToast(
                  msg: 'Please add Packages!',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey.shade900,
                  fontSize: 15,
                );
              }
              if (formKey.currentState!.validate() &&
                  nutritionistLocation != 'Location' &&
                  packagesMap.isNotEmpty) {
                formKey.currentState!.save();
                try {
                  NutritionistProvider().updateNutritionistData(
                      nutritionistId: widget.nutritionistData["nutritionistsId"],
                      nutritionistLocation: nutritionistLocation,
                      nutritionistName: nutritionistModel.nutritionistName,
                      nutritionistDescription: nutritionistModel.nutritionistDescription,
                      nutritionistAddress: nutritionistModel.nutritionistAddress,
                      nutritionistNumber: nutritionistModel.nutritionistNumber,
                      inActiveDates: inActiveDates,
                      startingPrice: packagesMap.entries.first.value,
                      packages: packagesMap,
                  );
             // default value change later
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
              // Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text("Submit", style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 20,)
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
              initialValue: widget.nutritionistData["nutritionistsNumber"],
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                labelText: "Mobile Number",
                labelStyle: TextStyle(color: Colors.black),
                hintText: "Enter Mobile Number",
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty || !RegExp(r"^\d{11}$").hasMatch(value)) {
                  return "Enter Number eg: 0333";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => nutritionistModel.nutritionistNumber = value!),
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
        children: [
          const Padding(
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
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 20,
            child: const Icon(
              size: 25,
              color: Colors.white,
              Icons.add_location_alt,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              initialValue: widget.nutritionistData["nutritionistsAddress"],
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "Nutritionist Address",
                labelText: "Address",
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: const UnderlineInputBorder(
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
                  setState(() => nutritionistModel.nutritionistAddress = value!),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildNutritionistDes() {
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
              initialValue: widget.nutritionistData["nutritionistsDescription"],
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "Tell us about your self",
                labelText: "Description",
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[\w\s.,!?@#$%^&*()-]+$").hasMatch(value)) {
                  return "Enter Description";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => nutritionistModel.nutritionistDescription = value!),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildNutritionistName() {
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
              Icons.health_and_safety_outlined,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              initialValue: widget.nutritionistData["nutritionistsName"],
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "Nutritionist Name",
                labelText: "Name",
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                  return "Enter Nutritionist Name";
                } else {
                  return null;
                }
              },
              onSaved: (value) => setState(() => nutritionistModel.nutritionistName = value!),
            ),
          ),
        ],
      ),
    );
  }

  Divider buildDivider() {
    return Divider(
      thickness: 1,
      color: Colors.black.withOpacity(0.2),
    );
  }

  GestureDetector buildLocation() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.white.withOpacity(0),
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: cityList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          nutritionistLocation = cityList[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          cityList[index],
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      thickness: 1,
                      color: kPurple.withOpacity(0.2),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.black,
          radius: 20,
          child: const Icon(
            size: 25,
            color: Colors.white,
            Icons.location_on,
          ),
        ),
        title: Text(
          nutritionistLocation,
          style: const TextStyle(fontWeight: FontWeight.w400),
        ),
        trailing: const Icon(
          size: 25,
          color: Colors.black,
          Icons.keyboard_arrow_down_outlined,
        ),
      ),
    );
  }

  Future getImage() async {
    XFile? pickedFile =
    await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        setState(() {
          isUploading = true;
          uploadFile().then((url) {
            if (url != null) {
              setState(() {
                isUploading = false;
              });
            }
          });
        });
      }
    });
  }

  Future uploadFile() async {
    File file = File(image!.path);

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(file);
      imageUrl = await referenceImageToUpload.getDownloadURL();

      if (imageUrl != null) {
        setState(() {
          listOfUrls.add(imageUrl);
        });
      }
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

    return imageUrl;
  }
  Padding buildPackages(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Colors.white.withOpacity(0),
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder:
                        (BuildContext context, StateSetter setModalState) =>
                        Container(
                          height: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: SingleChildScrollView(
                            // physics: ScrollPhysics(),
                            child: Form(
                              key: menuFormKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
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
                                            controller: menuDesController,
                                            keyboardType: TextInputType.multiline,
                                            maxLines: null,
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                  color: Colors.black.withOpacity(0.5),
                                                  fontWeight: FontWeight.w400),
                                              labelStyle: TextStyle(color: Colors.black),
                                              hintText: "Add your package details",
                                              labelText: "Package Description",
                                              enabledBorder:
                                              const UnderlineInputBorder(
                                                borderSide:
                                                BorderSide(color: Colors.black45),
                                              ),
                                              focusedBorder:
                                              const UnderlineInputBorder(
                                                borderSide:
                                                BorderSide(color: Colors.black),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty ||
                                                  !RegExp(r"^[\s\S]*$")
                                                      .hasMatch(value)) {
                                                return "Add Your Package";
                                              } else {
                                                return null;
                                              }
                                            },
                                            onSaved: (value) =>
                                                setState(() => menu = value!),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
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
                                            controller: menuCostController,
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                  color: Colors.black.withOpacity(0.5),
                                                  fontWeight: FontWeight.w400),
                                              hintText:
                                              "Cost of this package",
                                              labelText: "Cost",
                                              labelStyle: TextStyle(color: Colors.black),
                                              enabledBorder:
                                              const UnderlineInputBorder(
                                                borderSide:
                                                BorderSide(color: Colors.black45),
                                              ),
                                              focusedBorder:
                                              const UnderlineInputBorder(
                                                borderSide:
                                                BorderSide(color: Colors.black),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty ||
                                                  !RegExp(r"^[0-9]+$")
                                                      .hasMatch(value)) {
                                                return "Enter Cost";
                                              } else {
                                                return null;
                                              }
                                            },
                                            onSaved: (value) => setState(
                                                    () => cost = int.parse(value!)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0,
                                        bottom: 10.0,
                                        left: 15.0,
                                        right: 15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            print('pressed');
                                            if (menuFormKey.currentState!
                                                .validate()) {
                                              menuFormKey.currentState!.save();

                                              setModalState(() {
                                                packagesMap[menu] = cost;
                                              });
                                              menuDesController.clear();
                                              menuCostController.clear();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black),
                                          child: const Text(
                                            "Add",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.separated(
                                    physics: const PageScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: packagesMap.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                    const Divider(),
                                    itemBuilder: (BuildContext context, int index) {
                                      String key =
                                      packagesMap.keys.elementAt(index);
                                      int? value = packagesMap[key];
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: kPink.withAlpha(50),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(kDefaultPadding),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Text(
                                                    'Packages',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      setModalState(() {
                                                        packagesMap.remove(key);
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.remove,
                                                      color: kPurple,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ExpandableText(
                                                key,
                                                expandText: '\n\nShow More',
                                                collapseText: '\n\nShow Less',
                                                maxLines: 6,
                                                linkColor: kPurple,
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: kPink.withOpacity(0.4),
                                                  borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(15)),
                                                ),
                                                child: Text(
                                                  "Rs. $value",
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    color: kPurple,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text("Add Packages",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Padding buildAddPhotos() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: image == null
          ? DottedBorder(
        color: Colors.black,
        strokeWidth: 2,
        dashPattern: const [8, 4],
        child: InkWell(
            onTap: getImage,
            child: Container(
                height: 150,
                width: double.infinity,
                color: kPink.withAlpha(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                        size: 35,
                        color: Colors.grey,
                        Icons.camera_alt_outlined),
                    Text('Add Photo',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ))),
      )
          : DottedBorder(
        color: Colors.black,
        strokeWidth: 2,
        dashPattern: const [8, 4],
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.15,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 5,
                  ),
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: listOfUrls.length,
                  itemBuilder: (context, index) => SizedBox(
                    width: size.width * 0.35,
                    child: Stack(
                      children: [
                        AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Image.network(
                              listOfUrls[index],
                              fit: BoxFit.cover,
                            )),
                        IconButton(
                            onPressed: () {
                              try {
                                FirebaseStorage.instance
                                    .refFromURL(listOfUrls[index])
                                    .delete();
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
                              setState(() {
                                listOfUrls.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.clear)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: getImage,
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: const Text(
                    "Add More Photos",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              if (isUploading)
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
