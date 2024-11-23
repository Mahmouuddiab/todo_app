import 'package:add_task/model/task_model.dart';
import 'package:add_task/tabs/firebase_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskItem extends StatelessWidget {
  TaskModel taskModel ;
   TaskItem({super.key,required this.taskModel});
   FirebaseFunctions firebaseFunctions = FirebaseFunctions();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      child: Slidable(
        startActionPane: ActionPane(motion:  const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed:(context) {
                firebaseFunctions.deleteTask(taskModel.id);
                },
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13),
                  bottomLeft: Radius.circular(13)
                ),
              ),
            ]),
        child: SingleChildScrollView(
          child: Card(
            margin:EdgeInsets.all(10),
            color: Colors.white,
            shape: OutlineInputBorder(borderSide:BorderSide(color:Colors.white),borderRadius: BorderRadius.circular(12)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal:16 ,vertical:24 ),
              child: Row(
                children: [
                  Container(height: 65,width: 4,color: Colors.indigo,),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(taskModel.title,style:Theme.of(context).textTheme.titleMedium,),
                      SizedBox(height: 5,),
                      Text(taskModel.subTitle,style:Theme.of(context).textTheme.titleMedium,)
                    ],
                  ),
                  Spacer(),
                 taskModel.isDone?Text("Done",style:TextStyle(color:Colors.green,fontSize: 19),): ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor:Colors.indigo),
                      onPressed:(){
                    taskModel.isDone=true;
                    firebaseFunctions.updateTask(taskModel);
                      }, child:Icon(Icons.check,color:Colors.white,))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}