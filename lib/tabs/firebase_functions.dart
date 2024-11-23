
import 'package:add_task/model/myuser.dart';
import 'package:add_task/model/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


class FirebaseFunctions{
  CollectionReference<TaskModel> getTaskCollection(){
    return FirebaseFirestore.instance.collection("Tasks")
        .withConverter<TaskModel>(
      fromFirestore: (snapshot, options) => TaskModel.fromJson(snapshot.data()!),
      toFirestore: (task, options) => task.toJson(),);
  }

  Future<void> addTask(TaskModel task){
  var collectin =getTaskCollection();
  var docRef = collectin.doc();
  task.id =docRef.id;
  return docRef.set(task);
  }
  Stream<QuerySnapshot<TaskModel>> getTasks(){
    var collection = getTaskCollection();
   return collection.snapshots();
  }

  Future<void> deleteTask(String id){
   return getTaskCollection().doc(id).delete();
  }

  Future<void> updateTask(TaskModel taskModel){
    return getTaskCollection().doc(taskModel.id).update(taskModel.toJson()) ;
  }

  CollectionReference<MyUser> getUsersCollection(){
    return FirebaseFirestore.instance.collection(MyUser.collectinName).
    withConverter(fromFirestore: (snapshot, options) => MyUser.fromJson(snapshot.data()!),
        toFirestore: (value, options) => value.toJson(),) ;
  }

  Future<void> addUser(MyUser myUser){
    return getUsersCollection().doc(myUser.id).set(myUser) ;
  }

  Future<MyUser?> getUsers(String uId)async{
   var querySnapshot = await getUsersCollection().doc(uId).get();
    return querySnapshot.data();
  }


}