import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../TodoList/data/database.dart';
import 'add_guest.dart';
import 'guest_list_tile.dart';


class TrainersList extends StatefulWidget {
  const TrainersList({super.key});

  @override
  State<TrainersList> createState() => _TrainersListState();
}

class _TrainersListState extends State<TrainersList> {
  // reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db1 = ToDoDataBase();

  @override
  void initState() {
    // if this is the 1st time ever open in the app, then create default data
    if (_myBox.get("TRAINERSLIST") == null) {
      db1.createInitialGuestData();
    } else {
      // there already exists data
      db1.loadGuestData();
    }

    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  // checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db1.trainersList[index][1] = !db1.trainersList[index][1];
    });
    db1.updateGuestDataBase();
  }

  // save new task
  void saveNewTrainer() {
    setState(() {
      if(_controller.text!=''){
        db1.trainersList.add([_controller.text, false]);
        _controller.clear();
      }

    });
    Navigator.of(context).pop();
    db1.updateGuestDataBase();
  }


  // delete task
  void deleteGuest(int index) {
    setState(() {
      db1.trainersList.removeAt(index);
    });
    db1.updateGuestDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add,color: Colors.white,),
          onPressed: (){
            showModalBottomSheet(context: context, builder: (context)=>AddTrainersScreen(
              controller: _controller,
              onSave: saveNewTrainer,
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
                    'Trainers List',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  Text(
                    '${db1.trainersList.length} Trainers',
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
                  itemCount: db1.trainersList.length,
                  itemBuilder: (context, index) {
                    return GuestTile(
                      GuestName: db1.trainersList[index][0],
                      GuestCancel: db1.trainersList[index][1],
                      onChanged: (value) => checkBoxChanged(value, index),
                      deleteFunction: (context) => deleteGuest(index),
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

