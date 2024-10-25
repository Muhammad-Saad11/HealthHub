import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/database.dart';
import '../util/add_task_screen.dart';
import '../util/todo_tile.dart';

class CheckList extends StatefulWidget {
  const CheckList({super.key});

  @override
  State<CheckList> createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  // reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // if this is the 1st time ever openin the app, then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialTaskData();
    } else {
      // there already exists data
      db.loadTaskData();
    }

    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  // checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateTaskDataBase();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      if(_controller.text!=''){
        db.toDoList.add([_controller.text, false]);
        _controller.clear();
      }

    });
    Navigator.of(context).pop();
    db.updateGuestDataBase();
  }


  // delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateGuestDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add,color: Colors.white,),
          onPressed: (){
            showModalBottomSheet(context: context, builder: (context)=>AddTaskScreen(
              controller: _controller,
              onSave: saveNewTask,
            ));
          }
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Container(
              padding:EdgeInsets.only(top: 60,bottom:30,left:30,right:30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Icon(Icons.list,size: 30,color: Colors.black,),
                    backgroundColor: Colors.white,
                    radius: 30 ,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Check List',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w700,
                      fontFamily: 'SourceSansPro-SemiBold',
                    ),
                  ),
                  Text(
                    '${db.toDoList.length} tasks',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)
                  ),
                ),
                child: ListView.builder(
                  itemCount: db.toDoList.length,
                  itemBuilder: (context, index) {
                    return ToDoTile(
                      taskName: '${index+1} . ' + db.toDoList[index][0],
                      taskCompleted: db.toDoList[index][1],
                      onChanged: (value) => checkBoxChanged(value, index),
                      deleteFunction: (context) => deleteTask(index),
                    );
                  },
                ),
              ),
            ),
          ]
      ),
    );
  }
}

