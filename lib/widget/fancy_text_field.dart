import 'package:flutter/material.dart';

class FancyTextField extends StatefulWidget {

  FancyTextField({this.controller, this.enabled = true, this.labelText, this.validator, this.keyboardType, this.border, this.password=false});

  final TextEditingController controller;
  final bool enabled;
  final String labelText;
  final String Function(String) validator;
  final TextInputType keyboardType;
  final InputBorder border;
  final bool password;

  @override
  State<StatefulWidget> createState() => _FancyTextFieldState();

}

class _FancyTextFieldState extends State<FancyTextField> {

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {

    var textField = TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      enabled: widget.enabled,
      obscureText: (widget.password) ? _obscurePassword : false,
      decoration: InputDecoration(
        border: widget.border,
        labelText: widget.labelText,
        suffixIcon: Visibility(
          visible: widget.password,
          child: IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off,),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.all(10.0),
      child: textField,
    );
  }

}