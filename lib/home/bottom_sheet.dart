
import 'package:add_task/model/task_model.dart';
import 'package:add_task/tabs/firebase_functions.dart';
import 'package:flutter/material.dart';


class BottomSheetTask extends StatefulWidget {

  BottomSheetTask({super.key});

  @override
  State<BottomSheetTask> createState() => _BottomSheetTaskState();
}

class _BottomSheetTaskState extends State<BottomSheetTask> {
  var formKey=GlobalKey<FormState>();
  DateTime selectedDate= DateTime.now();
  TextEditingController title = TextEditingController();
  TextEditingController subTitle = TextEditingController();
   FirebaseFunctions firebaseFunctions=FirebaseFunctions();



  @override
  Widget build(BuildContext context) {
    return Container(
      margin:EdgeInsets.all(12),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Add new Task",textAlign:TextAlign.center,style:Theme.of(context).textTheme.titleMedium,),
            TextFormField(
              controller: title,
              validator: (text) {
                if(text!.isEmpty){
                  return "please enter task title";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Enter Task Title",

              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: subTitle,
              validator: (text) {
                if(text!.isEmpty){
                  return "please enter task subtitle";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Enter Task Description",
              ),
              maxLines: 4,
            ),
            Padding(padding: EdgeInsets.all(8),
                child: Text("Select Date",textAlign:TextAlign.start,style:Theme.of(context).textTheme.bodyMedium,)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: (){
                    showCalender();
                  },
                  child: Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
                      ,textAlign:TextAlign.center,style:Theme.of(context).textTheme.bodyMedium)),
            ),
            Spacer(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor:Colors.indigo),
                onPressed: (){

                  TaskModel task= TaskModel(title: title.text, subTitle: subTitle.text, date:selectedDate.millisecondsSinceEpoch);
                   firebaseFunctions.addTask(task).then((value) {
                     Navigator.pop(context);
                   },);

                },
                child: Text("Add",style:Theme.of(context).textTheme.titleLarge,)
            )
          ],
        ),
      ),
    );
  }


  void showCalender()async {
    var chosenDate  = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365))

    );
    setState(() {
      selectedDate = chosenDate ?? selectedDate ;
    });
  }

}

