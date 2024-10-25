import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = [];
  List trainersList = [];

  // reference our box
  final _myBox = Hive.box('mybox');

  // run this method if this is the 1st time ever opening this app
  void createInitialTaskData() {
    toDoList = [];
  }
  void createInitialGuestData() {
    trainersList = [];
  }
  // load the data from database
  void loadTaskData() {
    toDoList = _myBox.get("TODOLIST");
  }
  void loadGuestData() {
    trainersList = _myBox.get("TRAINERSLIST");
  }

  // update the database
  void updateTaskDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
  void updateGuestDataBase() {
    _myBox.put("GUESTLIST", trainersList);
  }
}
