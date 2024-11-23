import 'package:add_task/home/bottom_sheet.dart';
import 'package:add_task/home/task_item.dart';
import 'package:add_task/tabs/firebase_functions.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';

class Home extends StatelessWidget {
  static const String routeName = "home";
   Home({super.key});
FirebaseFunctions firebaseFunctions =FirebaseFunctions();
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white70,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(onPressed: (){
        showModalBottomSheet(context: context, builder: (context) => BottomSheetTask(),);
      },
      child: Icon(Icons.add),),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        toolbarHeight: MediaQuery.of(context).size.height*0.2,
        title: Text("Todo App ${userProvider.currentUser!.name!}"),
      ),
      body: Column(
        children: [
          EasyDateTimeLine(
            initialDate: DateTime.now(),
            onDateChange: (selectedDate){

            },
            headerProps: const EasyHeaderProps(
              monthPickerType: MonthPickerType.switcher,
              dateFormatter: DateFormatter.fullDateDMY(),
            ),
            dayProps: const EasyDayProps(
                dayStructure: DayStructure.dayStrDayNumMonth,
                activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        gradient:LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xff3371FF),
                              Color(0xff8426D6)

                            ]
                        )
                    )
                )
            ),
          ),
          StreamBuilder(stream:firebaseFunctions.getTasks(), builder:(context, snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            if(snapshot.hasError){
              return Column(children: [
                Text("something went wrong")
              ],);
            }

            var tasks= snapshot.data?.docs.map((doc) => doc.data(),).toList()?? [];
            if(tasks.isEmpty){
              return Text("No Tasks");
            }

           return Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) => TaskItem(taskModel:tasks[index] ,),),
            );

          },
          ),


        ],
      ),
    );
  }
}
