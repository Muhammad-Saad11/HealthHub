import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class GuestTile extends StatelessWidget {
  final String GuestName;
  final bool GuestCancel;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;

  GuestTile({
    super.key,
    required this.GuestName,
    required this.GuestCancel,
    required this.onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(
            GuestName,
            style: TextStyle(
              decoration: GuestCancel
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          trailing: Checkbox(
            value: GuestCancel,
            onChanged: onChanged,
            activeColor: Colors.deepPurpleAccent,
          ),
        ),
      ),
    );
  }
}

