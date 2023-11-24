import 'package:flutter/material.dart';
import 'package:grouping_project/core/theme/theme.dart';

enum AppButtonType{
  primary,
  secondary,
  tertiary,
  danger,
  warning,
  success,
  info,
  hightLight,
  light,
  dark,
  transparent,
}

class AppButton extends StatelessWidget{
  AppButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.buttonType = AppButtonType.primary,
  });
  final VoidCallback onPressed;
  final String label;
  final Icon? icon;
  final AppButtonType buttonType;

  final outerPadding = const EdgeInsets.symmetric(vertical: 0, horizontal: 20);
  final innerPadding = const EdgeInsets.symmetric(vertical: 6, horizontal: 10);

  final buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  );


  (Color, Color) getButtonColor(BuildContext context){
    switch (buttonType) {
      case AppButtonType.primary:
        return (AppColor.primary(context), AppColor.onPrimary(context));
      case AppButtonType.secondary:
        return (AppColor.secondary(context), AppColor.onSecondary(context));
      case AppButtonType.tertiary:
        return (AppColor.tertiaryContainer(context), AppColor.onTertiaryContainer(context));
      case AppButtonType.danger:
        return (AppColor.error(context), AppColor.onError(context));
      // case AppButtonType.warning:
      //   return (AppColors.warning(context), AppColors.onWarning(context));
      // case AppButtonType.success:
      //   return (AppColors.success(context), AppColors.onSuccess(context));
      // case AppButtonType.info:
      //   return (AppColors.info(context), AppColors.onInfo(context));
      // case AppButtonType.light:
      //   return (AppColors.light(context), AppColors.onLight(context));
      case AppButtonType.hightLight:
        return (Colors.amber, Colors.black);
      case AppButtonType.transparent:
        return (AppColor.surface(context), AppColor.onSurface(context));
      default:
        return (AppColor.primary(context), AppColor.onPrimary(context));
    }
  }

  Widget _labelWrapper(BuildContext context, String label,){
    assert(label.isNotEmpty, "label cannot be empty");
    return Text(label,
      style: AppText.labelLarge(context).copyWith(
        fontWeight: FontWeight.bold,
        color: getButtonColor(context).$2,
      )
    );
  }

  Widget _iconWrapper(BuildContext context, Widget? icon){
    assert(icon == null || icon is Icon);
    return icon != null 
      ? Icon((icon as Icon).icon, color: getButtonColor(context).$2) 
      : const SizedBox.shrink();
  }
  
  Widget _getButton(BuildContext context){
    var color = getButtonColor(context);
    return MaterialButton(
      onPressed: onPressed,
      shape: buttonShape,
      color: color.$1,
      child: Padding(
        padding: innerPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _labelWrapper(context, label),
            _iconWrapper(context, icon) 
          ],
        ),
      ),
    );
  }

  Widget _getBody(BuildContext context){
    return Card(
      elevation: 0,
      child: _getButton(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getBody(context);
  }
}