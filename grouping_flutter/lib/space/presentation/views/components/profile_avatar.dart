import 'dart:async';

import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget{

  final Color themePrimaryColor;
  final Widget? avatar;
  final String imageUrl;
  final String label;
  final double avatarSize;
  final double labelFontSize;
  final double radius;
  
  const ProfileAvatar({
    super.key,
    required this.themePrimaryColor,
    required this.label,
    this.imageUrl = "",
    this.avatar,
    this.avatarSize = 40,
    this.labelFontSize = 14,
    this.radius = 10,
  });

  Future<Size> _getImageSize(ImageProvider imageProvider) async {
    final Completer<Size> completer = Completer<Size>();
    imageProvider.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );
    return completer.future;
  }

  Widget _getAvatar(BuildContext context) {
    
    Widget labelWidget = Center(
      child: Text(
        label,
        softWrap: false,
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: themePrimaryColor,
          // fontSize: labelFontSize,
          fontWeight: FontWeight.bold
        ))
    );
    
    if (avatar != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: avatar!);
    }
    else if(imageUrl.isNotEmpty){
      var image = NetworkImage(imageUrl);
      return FutureBuilder(
        future: _getImageSize(image),
        builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
          if (snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Image.network(
                imageUrl,
                fit: snapshot.data!.width > snapshot.data!.height ? BoxFit.fitHeight : BoxFit.fitWidth,
              ),
            );
          } else {
            return labelWidget;
          }
        },
      );
    }
    else{
      return labelWidget;
    }
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: themePrimaryColor.withOpacity(0.3), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: _getAvatar(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _buildBody(context);

}