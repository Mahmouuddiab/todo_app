import 'package:add_task/auth/custom_text_from.dart';
import 'package:add_task/dialogs/dialog_functions.dart';
import 'package:add_task/home/home.dart';
import 'package:add_task/model/myuser.dart';
import 'package:add_task/provider/user_provider.dart';
import 'package:add_task/tabs/firebase_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  static const String routeName = "register";

  Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmationController = TextEditingController();

  FirebaseFunctions firebaseFunctions=FirebaseFunctions();

  DialogFunctions dialogFunctions=DialogFunctions();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/images/blob.jpeg",
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              "create an account",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
            centerTitle: true,
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  CustomTextFrom(
                    label: "UserName",
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return "please enter username";
                      }
                      return null;
                    },
                    controller: nameController,
                    keyboardType: TextInputType.text,
                  ),
                  CustomTextFrom(
                    label: "Email",
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return "please enter Email";
                      }
                      final bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(text);
                      if (!emailValid) {
                        return "please enter valid email";
                      }
                      return null;
                    },
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  CustomTextFrom(
                    label: "Password",
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "please enter password";
                      }
                      if (text.length < 6) {
                        return "please enter strong password";
                      }
                      return null;
                    },
                    controller: passwordController,
                    keyboardType: TextInputType.phone,
                    passwordVisible: true,
                  ),
                  CustomTextFrom(
                    label: "Confirm Password",
                    validator: (text) {
                      if (passwordController.text != text) {
                        return "password is different";
                      }
                      if (text == null || text.trim().isEmpty) {
                        return "please enter password to confirm";
                      }
                      return null;
                    },
                    controller: confirmationController,
                    keyboardType: TextInputType.phone,
                    passwordVisible: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.blueAccent))),
                        onPressed: () {
                          signUp();
                        },
                        child: Text(
                          "create account",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void signUp()async {
    if (formKey.currentState?.validate() == true) {
      dialogFunctions.showLoadindDialog(context, 'loading...');
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        MyUser myUser=MyUser(id: credential.user?.uid??'', name: nameController.text, email: emailController.text);
        var userProvider = Provider.of<UserProvider>(context,listen: false);
        userProvider.updateUser(myUser);
        if(nameController.text==null){
          return;
        }
       await firebaseFunctions.addUser(myUser);
        dialogFunctions.hideLoading(context);
        dialogFunctions.showMessageDialog(context: context, message: "register is successfull",
        negActionName: "ok",negAction: (){
          Navigator.pushNamed(context, Home.routeName);
            });

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          dialogFunctions.hideLoading(context);
          dialogFunctions.showMessageDialog(context: context, message: "The password provided is too weak.");

          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          dialogFunctions.hideLoading(context);
          dialogFunctions.showMessageDialog(context: context, message: 'The account already exists for that email.');
          print('The account already exists for that email.');
        }
      } catch (e) {
        dialogFunctions.hideLoading(context);
        dialogFunctions.showMessageDialog(context: context, message:e.toString());

        print(e);
      }
    }
  }
}
