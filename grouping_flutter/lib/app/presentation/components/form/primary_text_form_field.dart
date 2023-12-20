import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppTextFormField extends StatelessWidget{
  final Color? primaryColor;
  // final String? title;
  final String? initialValue;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSubmit;
  final bool obscureText;
  final bool enabled;
  final bool filled;
  final Color fillColor;
  final TextStyle? textStyle;
  final TextStyle? contentStyle;
  final Widget? prefixWidget;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const AppTextFormField({
    Key? key,
    this.focusNode,
    this.initialValue,
    this.hintText = "",
    this.primaryColor,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onSubmit,
    this.obscureText = false,
    this.enabled = true,
    this.filled = true,
    this.fillColor = Colors.white,
    this.prefixWidget,
    this.textStyle,
    this.contentStyle,
    this.controller,
  }) : super(key: key);

  final gap = const Gap(5);
  final borderRadius = 5.0;

  Color getColor (BuildContext context) =>
    primaryColor ?? Theme.of(context).primaryColor;
  
  TextStyle getLabelStyle(BuildContext context){ 
    return textStyle ?? Theme.of(context).textTheme.labelLarge!.copyWith(
      color: getColor(context),
      fontWeight: FontWeight.bold
    );
  }

  TextStyle getContentStyle(BuildContext context){
    return contentStyle ?? Theme.of(context).textTheme.labelLarge!.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      initialValue: initialValue,
      style: getContentStyle(context),
      onChanged: onChanged,
      validator: validator,
      onSaved: onSaved,
      onFieldSubmitted: onSubmit,
      onTapOutside: (event){
        FocusScope.of(context).unfocus(); 
        onSaved != null ? onSaved!(initialValue) : null;
      },
      decoration: InputDecoration(
        prefix: prefixWidget,
        hintText: hintText,
        filled: filled,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 0,
        ),
        
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: getColor(context), width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}