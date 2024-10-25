import 'dart:async';
import 'dart:math';
import 'package:bgmfitness/Models/step_model.dart';
import 'package:bgmfitness/services/step_services.dart';
import 'package:bgmfitness/views/CustomerPages/steps_calculator/step_analysis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class StepCalculatorScreeen extends StatefulWidget {
  const StepCalculatorScreeen({Key? key}) : super(key: key);

  @override
  State<StepCalculatorScreeen> createState() => _StepCalculatorScreeenState();
}

class _StepCalculatorScreeenState extends State<StepCalculatorScreeen> {
  var auto_text = "Slide for Steps OFF";
  var manual_text = "Slide for Steps On";
  var current_text = "Slide for Steps OFF";
  Icon auto_icon = Icon(Icons.flash_on);
  Icon manual_icon = Icon(Icons.settings);
  Icon current_icon = Icon(Icons.flash_on);
  var mode = 0; //1 for manual 0 for auto
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  double miles = 0.0;
  double duration = 0.0;
  double calories = 0.0;
  double addValue = 0.025;
  int steps = 0;
  double previousDistacne = 0.0;
  double distance = 0.0;
  StepService _stepService = StepService();

  StepsModel? stepDetail;
  bool stepStatus = false;
  int? stepCachevalue = 0;
  var start2 = '';

  var date = '5/17/2023';
  final _auth = FirebaseAuth.instance;
  User? user;

  stepCount() async {
    Timer(const Duration(milliseconds: 300), () {
      () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        stepCachevalue = prefs.getInt('${user!.uid}Steps');
        // print('Before $stepCachevalue');

        if (stepCachevalue == null) {
          prefs.setInt('${user!.uid}Steps', 0);
          stepCachevalue = 0;
          stepStatus = false;
          setState(() {});
        }
        if (stepStatus) {
          prefs.setInt('${user!.uid}Steps', 0);
          stepCachevalue = 0;
          stepStatus = false;
          setState(() {
            start2 = '';
          });
        }
        stepCachevalue = prefs.getInt('${user!.uid}Steps');
        steps = stepCachevalue!;

        print('After $stepStatus');

        print("Get C Steps: $stepCachevalue");

        setState(() {
          stepStatus = false;

          int? currentSteps = 0;

          stepCachevalue = prefs.getInt('${user!.uid}Steps');
          //stepCachevalue = stepadd;

          print("Cache Steps: $stepCachevalue");

          () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            prefs.setInt('${user!.uid}Steps', stepCachevalue!);
            print(prefs.getInt('${user!.uid}Steps').toString());
          }();
        });
      }();
    });
  }

  @override
  void initState() {
    super.initState();
    //initPlatformState();
    user = _auth.currentUser;

    stepCount();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      "Activities",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => StepAnalysisScreen()));
                        },
                        icon: Icon(
                          Icons.auto_graph_outlined,
                          color: Colors.black,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: WidgetCircularAnimator(
                      innerColor: Colors.black,
                      outerColor: Colors.grey,
                      size: 280,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder<AccelerometerEvent>(
                              stream:
                                  SensorsPlatform.instance.accelerometerEvents,
                              builder: (context, snapShort) {
                                if (snapShort.hasData) {
                                  x = snapShort.data!.x;
                                  y = snapShort.data!.y;
                                  z = snapShort.data!.z;
                                  distance = getValue(x, y, z);
                                  if (distance > 6) {
                                    //     ()async{
                                    //   SharedPreferences pref=await SharedPreferences.getInstance();
                                    //   pref.setInt('currentSteps', stepCachevalue);
                                    // }();
                                    steps++;
                                  }
                                  calories = calculateCalories(steps);
                                  duration = calculateDuration(steps);
                                  miles = calculateMiles(steps);
                                }

                                return const Center(
                                  child: Text(
                                    "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 1.0,
                                        color: Colors.black),
                                  ),
                                );
                              }),
                          start2 == ""
                              ? SizedBox(
                                  height: 2,
                                  width: 2,
                                  child: StreamBuilder<StepsModel?>(
                                      stream: _stepService.getSteps(),
                                      builder:
                                          (BuildContext context, stepData) {
                                        // Map<String,dynamic> stepDays={};
                                        // String formattedDate='11/2/2022';
                                        // print(formattedDate);
                                        // stepData.data!.stepsData=stepDays;
                                        // print(stepData.data?.stepsData
                                        //     .toString());
                                        DateTime now = DateTime.now();
                                        String formattedDate =
                                            DateFormat.yMd().format(now);

                                        if (stepData.hasError) {
                                          return CircularProgressIndicator();
                                        }
                                        if (!stepData.hasData) {
                                          return CircularProgressIndicator();
                                        }
                                        stepDetail = stepData.data;
                                        date = stepDetail!.date;
                                        print("Step Cache $stepCachevalue");

                                        Timer.periodic(Duration(seconds: 5),
                                            (timer) async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          DateTime now = DateTime.now();
                                          String formattedDate =
                                              DateFormat.yMd().format(now);

                                          int len =
                                              stepDetail!.stepsData.length;
                                          if (stepStatus) {
                                            setState(() {
                                              stepStatus = false;
                                            });
                                          }

                                          if (formattedDate ==
                                              stepDetail!.date) {
                                            print(stepDetail!.stepsData);
                                            print('Date is Matched');
                                            prefs.setInt(
                                                '${user!.uid}Steps', steps);
                                            print(stepDetail!.date);
                                            print(steps.toString());
                                            _stepService.updateSteps(StepsModel(
                                                calorie: calories.toString(),
                                                steps: steps.toString(),
                                                uid: stepDetail!.uid,
                                                date: formattedDate,
                                                stepsData: [
                                                  {
                                                    'steps': steps.toString(),
                                                    'date':
                                                        formattedDate.toString()
                                                  }
                                                ]));
                                            setState(() {
                                              stepStatus = false;
                                            });
                                          }
                                          if (stepDetail!.date.isEmpty ||
                                              stepDetail!.date == "") {
                                            print('Empty');
                                            steps = 0;
                                            prefs.setInt(
                                                '${user!.uid}Steps', steps);

                                            prefs.setInt(
                                                '${user!.uid}Steps', 0);
                                            _stepService.postSteps(
                                                context,
                                                calories.toString(),
                                                steps.toString(),
                                                formattedDate.toString());
                                            stepStatus = true;
                                            setState(() {});
                                          }

                                          if (stepDetail!.date !=
                                              formattedDate) {
                                            print('Dateee');
                                            print('Datee${stepDetail!.date}');

                                            // stepStatus == true;
                                            print('Date is not Matched');
                                            steps = 0;
                                            prefs.setInt(
                                                '${user!.uid}Steps', steps);
                                            print(prefs
                                                .getInt('${user!.uid}Steps'));
                                            _stepService.postSteps(
                                              context,
                                              calories.toString(),
                                              steps.toString(),
                                              formattedDate.toString(),
                                            );
                                            stepStatus = true;
                                            setState(() {});
                                          }

                                          stepCount();
                                        });

                                        // steps=steps+stepCachevalue!;

                                        start2 = 'j';

                                        return Text(
                                          '',
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 0),
                                        );
                                      }),
                                )
                              : Text(''),
                          InkWell(
                              onTap:
                                  // stepStatus
                                  //     ?
                                  () async {},
                              // : null,
                              child: Center(
                                child: Text(
                                  steps.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 58.0,
                                      color: Colors.black),
                                ),
                              )),
                          const SizedBox(height: 25),
                        ],
                      ))),
              SizedBox(
                height: 30,
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Workouts",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    )),
              ),
              // SizedBox(height: 50,),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: SizedBox(
                          height: 80,
                          width: 900,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                // Image.asset(
                                //   "assets/run.png",
                                //   height: 70,
                                //   width: 50,
                                // ),
                                Icon(
                                  Icons.run_circle,
                                  color: Colors.black,
                                  size: 50,
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Distance",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("${miles.toStringAsFixed(4)} miles",
                                        style: TextStyle(
                                            color: Colors.black,
                                            letterSpacing: 1)),
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  '$date',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 5,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: SizedBox(
                          height: 80,
                          width: 900,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.local_fire_department_rounded,
                                  color: Colors.black,
                                  size: 50,
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Calories",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("${calories.toStringAsFixed(3)} CAL",
                                        style: TextStyle(
                                            color: Colors.amber,
                                            letterSpacing: 1)),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  '$date',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setPreviousValue(double distance) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setDouble("preValue", distance);
  }

  void getPreviousValue() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      previousDistacne = _pref.getDouble("preValue") ?? 0.0;
    });
  }

  double getValue(double x, double y, double z) {
    double magnitude = sqrt(x * x + y * y + z * z);
    getPreviousValue();
    double modDistance = magnitude - previousDistacne;
    setPreviousValue(magnitude);
    return modDistance;
  }

  // void calculate data
  double calculateMiles(int steps) {
    double milesValue = (2.2 * steps) / 5280;
    return milesValue;
  }

  double calculateDuration(int steps) {
    double durationValue = (steps * 1 / 1000);
    return durationValue;
  }

  double calculateCalories(int steps) {
    double caloriesValue = (steps * 0.0566);
    return caloriesValue;
  }
}
