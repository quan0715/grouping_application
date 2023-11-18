import 'package:flutter/material.dart';

class AuthTextFormField extends TextFormField{
  AuthTextFormField({
    Key? key,
    required String hintText,
    required String labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool obscureText = false,
    required String? Function(String?) validator,
    required Function(String?) onChanged,
  }) : super(
    key: key,
    decoration: InputDecoration(
      hintText: hintText,
      label: Text(labelText),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        gapPadding: 10)
      ),
    obscureText: obscureText,
    validator: validator,
    onChanged: onChanged,
  );
} 

class ProtectedTextFormField extends StatefulWidget{
  final String hintText;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? visibleIcon;
  final Widget? inVisibleIcon;
  
  final bool obscureText;
  final String? Function(String?) validator;
  final Function(String?) onChanged;
  const ProtectedTextFormField({
    Key? key,
    required this.hintText,
    required this.labelText,
    this.prefixIcon,
    this.visibleIcon = const Icon(Icons.visibility),
    this.inVisibleIcon = const Icon(Icons.visibility_off),
    this.obscureText = false,
    required this.validator,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ProtectedTextFormField> createState() => _ProtectedTextFormFieldState();
}

class _ProtectedTextFormFieldState extends State<ProtectedTextFormField> {

  bool obscureText = false;

  void onVisibleChanged(){
    setState(() {
      debugPrint('change visibility');
      obscureText = !obscureText;
      // widget.obscureText = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    obscureText = widget.obscureText;
    super.initState();
  }

  Widget _buildVisibilitySwitchingButton(){
    return IconButton(
      onPressed: onVisibleChanged,
      icon: obscureText ? widget.inVisibleIcon! : widget.visibleIcon!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthTextFormField(
      hintText: widget.hintText,
      labelText: widget.labelText,
      prefixIcon: widget.prefixIcon,
      suffixIcon: _buildVisibilitySwitchingButton(),
      obscureText: obscureText,
      validator: widget.validator,
      onChanged: widget.onChanged,
    );
  }
}