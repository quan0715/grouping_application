import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';
import 'package:provider/provider.dart';

class SpaceAppBar extends StatelessWidget implements PreferredSizeWidget{

  final Color color;
  final String spaceName;
  final String? spaceProfilePicURL;

  const SpaceAppBar({
    this.color = Colors.white,
    this.spaceName = "",
    this.spaceProfilePicURL,
    super.key,
  });
  
  // @override
  // Color get getThemePrimaryColor => profile.spaceColor;

  UserSpaceViewModel getSpaceViewModel(BuildContext context){
    return Provider.of<UserSpaceViewModel>(context, listen: false);
  }
  @override
  Widget build(BuildContext context) => _buildBody(context); 

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  String getTitle(String userName) => userName;

  Widget _buildBody(BuildContext context){
    return kIsWeb ? _buildWebView(context) : _buildMobileView(context);
  }

  Widget _getMenuButton(BuildContext context){
    return IconButton(
      onPressed: () => Scaffold.maybeOf(context)!.openDrawer(),
      icon: Icon(Icons.menu, color: color),
    );
  }

  Widget _getTitleWidget(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ProfileAvatar(
          themePrimaryColor: color,
          label: spaceName,
          avatar: spaceProfilePicURL != null && spaceProfilePicURL!.isNotEmpty 
            ? Image.network(spaceProfilePicURL!) : null,
          avatarSize: 35,
        ),
        const SizedBox(width: 10,),
        Text(
          getTitle(spaceName),
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildWebView(BuildContext context){
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      leading: _getMenuButton(context),
      title: _getTitleWidget(context),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildMobileView(BuildContext context){
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      leading: IconButton(
        onPressed: () => Scaffold.maybeOf(context)!.openDrawer(),
        icon: Icon(Icons.menu, color: color),
      ),
      title: _getTitleWidget(context),
      automaticallyImplyLeading: false,
      actions: [
        _getMenuButton(context),
      ],
    );
  }

}
