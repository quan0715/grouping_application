import 'package:flutter/material.dart';
import 'package:grouping_project/space/presentation/view_models/user_data_provider.dart';
import 'package:grouping_project/app/presentation/components/data_display/key_value_pair_widget.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';
import 'package:provider/provider.dart';

class SpaceInfoFrame extends StatelessWidget{
  // SpaceInfoAndNavigatorFrame, display space info with expanded user information card and navigator route list 
  final Color frameColor;
  final double? frameHeight;
  final double? frameWidth;

  const SpaceInfoFrame({
    this.frameColor = Colors.white,
    this.frameHeight,
    this.frameWidth,
    super.key
  });

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context){
    return DashboardFrameLayout(
      frameWidth: frameWidth ?? MediaQuery.of(context).size.width,
      frameHeight: frameHeight ?? MediaQuery.of(context).size.height,
      frameColor: frameColor,
      child: _buildSpaceInfo(context),
    );
  }
  
  Widget _buildSpaceInfo(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileAvatar(
            themePrimaryColor: frameColor,
            label: userData.currentUser?.name ?? "",
            avatar: userData.currentUser?.photo != null && userData.currentUser!.photo!.imageUri.isNotEmpty 
              ? Image.network(
                userData.currentUser!.photo!.imageUri, 
                fit: BoxFit.fitWidth, 
              ) : null,
            avatarSize: 72,
            labelFontSize: 20,
          ),
          // const Gap(10),
          KeyValuePairWidget<String, Widget>(
            gap: 3,
            primaryColor: frameColor,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            keyChild: "@user-${userData.currentUser?.id ?? ""}", 
            valueChild: Text(userData.currentUser?.name ?? "", style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            )),
          ),
          // const Gap(10),
          Divider(color: frameColor.withOpacity(0.2), thickness: 2,),
          KeyValuePairWidget(
            gap: 3,
            primaryColor: frameColor,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            keyChild: "自我介紹", 
            valueChild: userData.currentUser?.introduction ?? "",
          ),
          
          ...userData.currentUser!.tags.map((tag) => KeyValuePairWidget(
            gap: 3,
            primaryColor: frameColor,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            keyChild: tag.title, 
            valueChild: tag.content,
          )),
        ]
        // add gap,
      ),
    );
  }
}

