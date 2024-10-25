class StepsModel {
  String calorie;
  String date;
  String steps;
  String uid;
  List stepsData;

  StepsModel({
    required this.calorie,
    required this.date,
    required this.steps,
    required this.stepsData,
    required this.uid,
  });

  factory StepsModel.fromMap(map) {
    return StepsModel(
      calorie: map["calorie"],
      date: map["date"],
      steps: map["steps"],
      stepsData: map["stepsData"],
      uid: map["uid"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "calorie": calorie,
      "date": date,
      "steps": steps,
      "stepsData": stepsData,
      "uid": uid,
    };
  }
}
