import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.hint, this.password = false, this.validator, this.onSaved});

  final String hint;
  final bool password;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Padding(
        padding: EdgeInsets.symmetric(),
        child: TextFormField(
          obscureText: password,
          onSaved: onSaved,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(color: Colors.grey),
            hintText: hint,
          ),
        ),
      ),
    );
  }
}
