import 'package:add_task/model/myuser.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier{
  MyUser? currentUser;

  void updateUser(MyUser newUser){
    currentUser = newUser;
    notifyListeners();
  }
}