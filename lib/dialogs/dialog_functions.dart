
import 'package:flutter/material.dart';
class DialogFunctions{

  void showLoadindDialog(BuildContext context,String message){
    showDialog(
      context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 8,),
                Text(message)
              ],
            ),
          );
        },);
  }

  void hideLoading(BuildContext context){
    Navigator.pop(context);
  }

  void showMessageDialog({required BuildContext context,
    required String message, String title ='',String? posActionName,
    Function? posAction,Function? negAction,String? negActionName
  })
  {

List<Widget> actions =[];
if(posActionName!=null){
  actions.add(TextButton(onPressed:(){
    Navigator.pop(context);
    posAction?.call();
  }, child:Text(posActionName)));
}
if(negActionName!=null){
  actions.add(TextButton(onPressed:(){
    Navigator.pop(context);
    negAction?.call();
  }, child:Text(negActionName)));
}

    showDialog(context: context, builder: (context) {
      return AlertDialog(
        content: Text(message),
        title:Text(title),
        actions: actions

      );
    },);
  }

}