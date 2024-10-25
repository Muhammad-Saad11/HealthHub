import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class WorkoutMapScreen extends ConsumerStatefulWidget {
  const WorkoutMapScreen({Key? key}) : super(key: key);

  @override
  _WorkoutMapScreen createState() => _WorkoutMapScreen();
}

class _WorkoutMapScreen extends ConsumerState<WorkoutMapScreen> {
// created controller to display Google Maps
  final Completer<GoogleMapController> _controller = Completer();

//on below line we have set the camera position

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(); // Create instance.

  // final _screenshotController = ScreenshotController();

// list of locations to display polylines
  List<LatLng> latLen = [];
  double initialLat = 0.0;
  double initialLon = 0.0;
  String mapStyle = '';
  bool press1 = true;
  bool starter = true;
  var duration;
  bool maptoggle = false;
  double destLat = 0.0;
  double destLon = 0.0;
  late final Uint8List imageFile;
  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  var path = '';

  loadData() {
    _getUserCurrentLocation().then((value) async {
      final GoogleMapController controller = await _controller.future;
      CameraPosition kGooglePlex = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 19,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex));
      setState(() {
        destLon = value.longitude;
        destLat = value.latitude;
        maptoggle = true;
      });
      latLen.add(LatLng(destLat, destLon));
      print('Update');
      print(destLat);
      print(destLon);
    });
  }

  initialUserLocation() {
    _getUserCurrentLocation().then((value) {
      print('hello');
      // await convert();
      setState(() {
        initialLat = value.longitude;
        initialLon = value.latitude;
      });
    });
  }

  Uint8List? img;
  // Future<void> takeSnapShot() async {
  //   GoogleMapController controller = await _controller.future;
  //   Future<void>.delayed(const Duration(milliseconds: 1000), () async {
  //     final imageBytes = await controller.takeSnapshot();
  //     setState(() {
  //       img = imageBytes;
  //     });
  //     print('say hello');
  //     print(imageBytes);
  //     // await saveImage(imageBytes!);
  //   });
  // }

  markerWithPolyline() {
    for (int i = 0; i < latLen.length; i++) {
      _markers.add(
          // added markers
          Marker(
              markerId: MarkerId(i.toString()),
              position: latLen[i],
              visible: false));
      setState(() {});
      _polyline.add(Polyline(
        polylineId: const PolylineId('1'),
        points: latLen,
        color: Colors.blue,
      ));
    }
  }

  double result = 0.00;
  double steps = 0;

  getDistanceFromGPSPointsInRoute(List<LatLng> gpsList) {
    double total = 0.0;
    print('Before latlen');
    for (var i = 0; i < gpsList.length; i++) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((gpsList[i + 1].latitude - gpsList[i].latitude) * p) / 2 +
          c(gpsList[i].latitude * p) *
              c(gpsList[i + 1].latitude * p) *
              (1 - c((gpsList[i + 1].longitude - gpsList[i].longitude) * p)) /
              2;
      double distance = 12742 * asin(sqrt(a));
      total += distance;
      setState(() {
        result = total;
        steps = ((result * 1000) * 1.31);
      });
      print('Distance is ${12742 * asin(sqrt(a))}');
    }
    print('Total distance is $total');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    loadData();
  }

  var choose = 'Run';

  @override
  Widget build(BuildContext context) {
    // int provider=ref.watch(stepProvider);
    print('initial Location');
    print(destLat);
    print(destLon);
    CameraPosition initialPosition = CameraPosition(
      target: LatLng(destLat, destLon),
      zoom: 19,
    );
    print('Calculate Distance');
    print(result);
    print(latLen.length);
    return starter
        ? Scaffold(
            appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height * 0.08,
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose Activity',
                        style: TextStyle(color: Colors.black38, fontSize: 14),
                      ),
                      Text(
                        choose,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      // await takeSnapShot();
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: SingleChildScrollView(
                              child: Center(
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              choose = 'Run';
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: const Text(
                                            'Run',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          )),
                                      Divider(),
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              choose = 'Walk';
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: const Text(
                                            'Walk',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.black54,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: GoogleMap(
                      //given camera position
                      initialCameraPosition: initialPosition,
                      mapType: MapType.normal,
                      markers: _markers,
                      myLocationButtonEnabled: false,
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      polylines: _polyline,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        Timer.periodic(const Duration(seconds: 10), (timer) {
                          loadData();
                          press1 ? '' : markerWithPolyline();
                          // takeSnapShot();
                        });
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.27,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        result.toString().substring(0, 3),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 23),
                                      ),
                                      const Text(
                                        'Distance (KM)',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Center(
                                    child: StreamBuilder<int>(
                                      stream: _stopWatchTimer.rawTime,
                                      initialData: 0,
                                      builder: (context, snap) {
                                        final value = snap.data;
                                        final displayTime =
                                            StopWatchTimer.getDisplayTime(
                                                value!);
                                        duration = displayTime;
                                        return Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            children: [
                                              Text(
                                                displayTime,
                                                style: const TextStyle(
                                                    fontSize: 23,
                                                    fontFamily: 'Helvetica',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Text(
                                                'Duration',
                                                style: TextStyle(fontSize: 20),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: press1
                                    ? GestureDetector(
                                        onTap: () {
                                          starter = false;
                                          latLen = [];
                                          _polyline.clear();

                                          Timer.periodic(
                                              const Duration(seconds: 10),
                                              (timer) async {
                                            await getDistanceFromGPSPointsInRoute(
                                                latLen);
                                          });
                                          setState(() {
                                            // _markers.clear();
                                            press1 = !press1;
                                          });

                                          print('Polyliness');
                                          print(_polyline.toString());
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 250,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          child: const Center(
                                              child: Text(
                                            'Start Workout',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          )),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () async {
                                          _stopWatchTimer.onExecute
                                              .add(StopWatchExecute.stop);
                                          // setImage();
                                          setState(() {
                                            press1 = !press1;
                                          });
                                          showModalBottomSheet(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20))),
                                              context: context,
                                              builder: (context) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 20),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            'Conclusion',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 20),
                                                          )),
                                                      SizedBox(
                                                        height: 30,
                                                      ),
                                                      Text(
                                                        'Distance :     $result KM',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 20),
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                      ),
                                                      Text(
                                                        'Steps : ' +
                                                            steps.toString(),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 20),
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                      ),
                                                      Text(
                                                        'Duration :      $duration',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });

                                          // Future<void>.delayed(const Duration(milliseconds: 1000), () async {
                                          //    showDialog<void>(
                                          //     context: context,
                                          //     barrierDismissible: false, // user must tap button!
                                          //     builder: (BuildContext context) {
                                          //       return AlertDialog(
                                          //         content: SingleChildScrollView(
                                          //           child: Column(
                                          //             crossAxisAlignment: CrossAxisAlignment.start,
                                          //             children: [
                                          //               IconButton(onPressed: (){
                                          //                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>WorkoutMapScreen()));
                                          //               },
                                          //                   icon: Icon(Icons.arrow_back_sharp,size: 28,color: Colors.black,)),
                                          //               SizedBox(height: 50,),
                                          //               Text('Distance :     $result KM',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20),),
                                          //               SizedBox(height: 50,),
                                          //               Text('Steps :         200',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20),),
                                          //               SizedBox(height: 50,),
                                          //               Text('Duration :      $duration',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20),),
                                          //               SizedBox(height: 50,),
                                          //               Container(
                                          //                 height: 200,
                                          //                 width: 200,
                                          //                 child: Image.memory(img!),
                                          //               )
                                          //             ],
                                          //           ),
                                          //         ),
                                          //       );
                                          //     },
                                          //   );
                                          // });

                                          // Navigator.push(context, MaterialPageRoute(builder: (_)=>DetailsWorkoutMapScreen(distance: result.toString(), steps: '200', duration: duration.toString(), image: path,
                                          //  )));
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 250,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          child: const Center(
                                              child: Text(
                                            'Stop',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          )),
                                        ),
                                      ))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : TimeCircularCountdown(
            unit: CountdownUnit.second,
            countdownTotal: 3,
            textStyle: const TextStyle(
              color: Color.fromARGB(255, 240, 99, 5),
              fontSize: 90,
              fontWeight: FontWeight.w800,
            ),
            onUpdated: (unit, remainingTime) => print('Updated'),
            onFinished: () {
              const Text(
                'Go',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 90),
              );
              setState(() {
                starter = true;
                _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                _stopWatchTimer.onExecute.add(StopWatchExecute.start);
              });
            },
          );
  }

  // void _takeScreenshot() async {
  //  final imageFile = await _screenshotController.capture();
  //  await saveImage(imageFile!);
  //  // final image=File.fromRawPath(imageFile!);
  //  // final directory = await getApplicationDocumentsDirectory();
  //  // final pathOfImage = await File('${directory.path}').create();
  //  // final Uint8List bytes = imageFile.buffer.asUint8List();
  //  // await pathOfImage.writeAsBytes(bytes);
  //  // print('hello');
  //  // print(image.path);
  //  // // await GallerySaver.saveImage(imageFile);
  //  // print(image.path);
  //  //
  //  // setState(() {
  //  //   path=image.path;
  //  // });
  //
  // }
  // Future<String> saveImage(Uint8List bytes) async {
  //   await [Permission.storage].request();
  //   final time = DateTime.now()
  //       .toIso8601String()
  //       .replaceAll('.', '_')
  //       .replaceAll(':', '_');
  //   final name = 'screenshot_$time';
  //   final result = await ImageGallerySaver.saveImage(bytes, name: name);
  //   return result['filePath'];
  // }
}
