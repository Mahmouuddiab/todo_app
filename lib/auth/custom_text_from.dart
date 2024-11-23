import 'package:flutter/material.dart';

class CustomTextFrom extends StatefulWidget {
  String label;
  String? Function (String?) validator;
  TextInputType keyboardType ;
  TextEditingController controller;
  bool passwordVisible;
   CustomTextFrom({super.key,required this.label,
     required this.validator,
     this.keyboardType=TextInputType.text,
     required this.controller,
     this.passwordVisible=false

   });

  @override
  State<CustomTextFrom> createState() => _CustomTextFromState();
}

class _CustomTextFromState extends State<CustomTextFrom> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          suffixIcon: IconButton(onPressed: (){
            setState(() {
              widget.passwordVisible=!widget.passwordVisible;
            });
          }, icon: Icon(
            widget.passwordVisible?Icons.visibility_off:Icons.visibility
          )),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.blueAccent,
              width: 2
            )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: Colors.blueAccent,
                  width: 2
              )
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: Colors.red,
                  width: 2
              )
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: Colors.red,
                  width: 2
              )
          ),
          labelText: widget.label,
      ),
        validator: widget.validator,
        keyboardType:widget.keyboardType,
        controller:widget.controller,
        obscureText: widget.passwordVisible,


        ),
    );

  }
}
