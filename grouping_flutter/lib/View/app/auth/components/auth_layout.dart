import 'package:flutter/material.dart';

class AuthLayoutInterface extends StatelessWidget{
  const AuthLayoutInterface({super.key});

  
  double get formWidth => 450;
  double get breakPoint => formWidth * 1.5;
  Widget getInfoDisplayFrame(){
    return Container(
      width: formWidth,
      color: Colors.blue,
    );
  }
  Widget getBuildLoginFrame(){
    return Container(
      width: formWidth,
      color: Colors.red,
    );
  }
  
  Widget buildPage(){
    return Scaffold(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > breakPoint) {
          return _buildNormalSizeBody();
        } else {
          return _buildSmallSizeBody();
        }
      }),
    );
  }
  
  Widget _buildNormalSizeBody(){
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: getInfoDisplayFrame(),),
              getBuildLoginFrame(),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildSmallSizeBody(){
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ getBuildLoginFrame()],
          ),
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return buildPage();
  }
}