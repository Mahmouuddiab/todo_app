import 'package:add_task/auth/register.dart';
import 'package:add_task/dialogs/dialog_functions.dart';
import 'package:add_task/home/home.dart';
import 'package:add_task/tabs/firebase_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import 'custom_text_from.dart';

class Login extends StatefulWidget {
  static const String routeName="login";
   Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  var formKey=GlobalKey<FormState>();

  FirebaseFunctions firebaseFunctions=FirebaseFunctions();

  DialogFunctions dialogFunctions=DialogFunctions();

  @override
  Widget build(BuildContext context){
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
              "Login",
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text("Welcome Back!",style:TextStyle(fontSize:20,fontWeight:FontWeight.bold),),
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
                          login();
                        },
                        child: Text(
                          "login",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )),
                  ),
                  TextButton(onPressed: (){
                    Navigator.pushNamed(context, Register.routeName);
                  }, child: Text("Or Create My Account",style:TextStyle(fontSize: 16,color:Colors.cyan),))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void login()async{
    if(formKey.currentState?.validate()==true){
      dialogFunctions.showLoadindDialog(context, "loading...");
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );

        var user =await firebaseFunctions.getUsers(credential.user!.uid);
        if(user==null){
          return;
        }
        var userProvider = Provider.of<UserProvider>(context,listen: false);
        userProvider.updateUser(user);
        dialogFunctions.hideLoading(context);
        dialogFunctions.showMessageDialog(context: context, message: "successful login",
        negActionName: "ok",negAction: (){
          Navigator.pushNamed(context, Home.routeName);
            });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          dialogFunctions.hideLoading(context);
          dialogFunctions.showMessageDialog(context: context, message:'No user found for that email.');
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          dialogFunctions.hideLoading(context);
          dialogFunctions.showMessageDialog(context: context, message:'Wrong password provided for that user.');
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}
