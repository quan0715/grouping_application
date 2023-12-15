import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';
import 'package:provider/provider.dart';
import 'package:grouping_project/app/presentation/components/data_display/title_with_content.dart';
import 'package:grouping_project/space/presentation/views/components/forms/tag_edit_form.dart';
import 'package:grouping_project/app/presentation/providers/token_manager.dart';
import 'package:grouping_project/space/presentation/view_models/setting_view_model.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/key_value_pair_widget.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';
import 'package:grouping_project/space/presentation/views/components/user_action_button.dart';
import 'package:image_picker/image_picker.dart';

class UserSettingFrame extends StatefulWidget {
  const UserSettingFrame({
    super.key,
    this.frameColor = Colors.white,
    this.frameHeight,
    this.frameWidth,
  });

  final Color frameColor;
  final double? frameHeight;
  final double? frameWidth;

  @override
  State<UserSettingFrame> createState() => _SettingViewState();
}

class _SettingViewState extends State<UserSettingFrame>{
  
  @override
  Widget build(BuildContext context) => _buildBody();

  List<Widget> get _tabPages => [
    AccountSettingSection(primaryColor: getThemePrimaryColor,),
    PublicProfileSettingSection(primaryColor: getThemePrimaryColor,),
    SpaceSettingSection(primaryColor: getThemePrimaryColor)
  ];

  final tabData = [
    {"icon" : Icons.account_circle_outlined, "label" : "個人帳號設定"},
    {"icon" : Icons.person_outline, "label" : "公開資料設定"},
    {"icon" : Icons.dashboard_outlined, "label" : "個人儀錶板設定"},
  ];


  Color get getThemePrimaryColor => widget.frameColor;
  final _innerPadding = const EdgeInsets.symmetric(vertical: 10, horizontal: 10);

  Widget _buildBody() {
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child) => Consumer<UserSpaceViewModel>(
        builder: (context, userPageViewModel, child) => DashboardFrameLayout(
          frameColor: getThemePrimaryColor,
          frameHeight: widget.frameHeight,
          frameWidth: widget.frameWidth,
          child: Padding(
            padding: _innerPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NavigationRail(
                  selectedIconTheme: const IconThemeData(color: Colors.white),
                  indicatorColor: getThemePrimaryColor,
                  extended: true,
                  onDestinationSelected: (index) => viewModel.onSectionChange(index),
                  backgroundColor: Colors.transparent,
                  destinations: tabData.map((data) => NavigationRailDestination(
                    icon: Icon(data["icon"] as IconData),
                    label: Text(data["label"] as String),
                  )).toList(),
                  selectedIndex: viewModel.currentSectionIndex,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Gap(20),
                        _tabPages.elementAt(viewModel.currentSectionIndex)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingFrameWidget extends StatelessWidget{
  // take a responsibility to build a setting section
  final String title;
  final String subTitle;
  final Widget? child;

  const SettingFrameWidget({
    super.key,
    required this.title,
    required this.subTitle,
    this.child,
  });

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWithContent(
          title: title,
          content: subTitle,
        ),
        const Divider(height: 10, thickness: 1),
        child ?? const SizedBox(),
      ],
    );
  }
}

class PublicProfileSettingSection extends StatelessWidget{
  final Color primaryColor;
  const PublicProfileSettingSection({
    super.key,
    required this.primaryColor,
  });

  Future<void> onTagAddedButtonPressed(BuildContext context) async {
    var vm = Provider.of<SettingPageViewModel>(context, listen: false);
    vm.isValidToAddNewTag
      ? vm.onTagAddButtonPressed()
      : debugPrint("You can't add more tags.");
  }


  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context) {
    return SettingFrameWidget(
      title: "公開個人資料設定",
      subTitle: "設定公開個人資料",
      child: _getPublicProfileBody(context),
    );
  }

  Widget _getPublicProfileBody(BuildContext context) {
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _getUserProfileBody(),
            ..._getExistingTags(context, viewModel),
          ] 
        ),
    );
  }
  
  Widget _getUserProfileBody() {
    return Consumer<SettingPageViewModel>(
      builder: (context, vm, child) => PrimaryInfoFrame(
        color: primaryColor,
        child: Column(
          children: [
            KeyValuePairWidget<String, Widget>(
              primaryColor: primaryColor,
              keyChild: "頭貼更換",
              valueChild:  InkWell(
                child: ProfileAvatar(
                  themePrimaryColor: primaryColor, 
                  avatar: vm.tempAvatarData != null
                    ? Image.memory( 
                      vm.tempAvatarData!,
                      fit: BoxFit.fill) 
                    : null,
                  avatarSize: 128,
                  label: "更換頭像",
                ),
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? file = await picker.pickImage(source: ImageSource.gallery);
                  if(context.mounted && file != null){
                    vm.uploadAvatar(file);
                  }
                }
              ), 
            ),
            const Gap(10),
            KeyValuePairWidget<String, Widget>(
              primaryColor: primaryColor,
              keyChild: "帳號資料",
              valueChild:AppTextFormField(
                initialValue: vm.currentUser.name,
                onChanged: (value) => vm.userName = value ?? "",
                // onSaved: (value) async => await vm.updateUser(vm.currentUser),
                onSubmit: (value) async => await vm.updateUser(vm.currentUser),
                primaryColor: primaryColor,
              ),
            ),
            const Gap(10),
            KeyValuePairWidget<String, Widget>(
              primaryColor: primaryColor,
              keyChild: "自我介紹",
              valueChild: AppTextFormField(
                initialValue: vm.currentUser.introduction,
                onChanged: (value) =>  vm.introduction = value ?? "",
                // onSaved: (value) async => await vm.updateUser(vm.currentUser),
                onSubmit: (value) async => await vm.updateUser(vm.currentUser),
                primaryColor: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getExistingTags(BuildContext context, SettingPageViewModel vm) {
    return [
      ...List.generate(
         vm.userTags.length, 
         (index) => Padding(
           padding: const EdgeInsets.symmetric(vertical: 5),
           child: vm.tagIsEdited(index)
              ? UserTagEditingForm(
                primaryColor: primaryColor,
                userTagEntity: vm.getTagByIndex(index), 
                onDeleteAction: (tag) async => await vm.deleteUserTagByIndex(index),
                onEditingCancel: (tag) => vm.clearFormState(),
                onEditingDone: (tag) async => await vm.updateExistingTag(tag, index),
              ): PrimaryInfoFrame(
                  color: primaryColor,
                  child: KeyValuePairWidget(
                    primaryColor: primaryColor,
                    keyChild: vm.getTagByIndex(index).title,
                    valueChild: vm.getTagByIndex(index).content,
                    action: IconButton(
                      icon: const Icon(Icons.create_outlined),
                      color: primaryColor,
                      onPressed: () => vm.onTagEdited(index),
                    ),
                  ),
              ),
         ),
      ),
      const Gap(10),
      Visibility(
        visible: vm.isAddingNewTag,
        child: UserTagEditingForm.createNewUserTag(
          primaryColor: primaryColor,
          onCancel: (tag) => vm.clearFormState(),
          onEditingDone: (tag) async => await vm.createNewTag(tag),
          onChange: (tag){},
        )
      ),
      vm.isAddingNewTag ? const Gap(10) : const SizedBox(),
      Visibility(
        visible: vm.isValidToAddNewTag,
        child: UserActionButton.secondary(
          onPressed: () async => vm.isValidToAddNewTag ? vm.onTagAddButtonPressed() : null,
          icon: const Icon(Icons.add),
          label: "創建新標籤",
          primaryColor: primaryColor),
      ),
    ];
  }  
}

class AccountSettingSection extends StatelessWidget{
  final Color primaryColor;

  const AccountSettingSection({
    super.key,
    required this.primaryColor,
  });

  void onLogout(BuildContext context) async {
    await Provider.of<UserSpaceViewModel>(context, listen: false).userDataProvider!.userLogout();
    if (context.mounted) {
      await Provider.of<TokenManager>(context, listen: false).updateToken();
    }
  }

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context) {
    return SettingFrameWidget(
      title: "個人帳號設定",
      subTitle: "設定個人帳號",
      child: _getAccountBody(context),
    );
  }

  final objectGap = const Gap(10);

  Widget _getAccountBody(BuildContext context) {
    UserSpaceViewModel userPageViewModel = Provider.of<UserSpaceViewModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
      PrimaryInfoFrame(
        color: primaryColor,
        child: KeyValuePairWidget(
          primaryColor: primaryColor,
          keyChild: "帳號名稱",
          valueChild: userPageViewModel.currentUser?.name ?? "這裡應為帳號名稱",
          action: UserActionButton.primary(
            onPressed: () => {
              throw UnimplementedError()
            },
            label: "更換帳號名稱",
            primaryColor: userPageViewModel.spaceColor,
            icon: const Icon(Icons.restart_alt),
          ),
        ),
      ),
      objectGap,
      PrimaryInfoFrame(
        color: primaryColor,
        child: KeyValuePairWidget(
          primaryColor: primaryColor,
          keyChild: "綁定信箱",
          valueChild: userPageViewModel.currentUser?.account ?? "這裡應為信箱",
        ),
      ),
      objectGap, 
      PrimaryInfoFrame(
        color: primaryColor,
        child: KeyValuePairWidget(
          primaryColor: primaryColor,
          keyChild: "帳號密碼",
          valueChild: "如遺失帳號密碼需更換密碼請點選密碼更換",
        ),
      ),
      objectGap,
      PrimaryInfoFrame(
        color: primaryColor,
        child: KeyValuePairWidget(
          primaryColor: primaryColor,
          keyChild: "帳號登出",
          valueChild: "登出此帳號",
          action: UserActionButton.secondary(
            onPressed: () => onLogout(context),
            label: "登出",
            primaryColor: Colors.red,
            icon: const Icon(Icons.logout),
          ),
        ),
      ),
    ]);
  }
}

class SpaceSettingSection extends StatelessWidget{
  final Color primaryColor;

  const SpaceSettingSection({
    super.key,
    required this.primaryColor,
  });

  void onLogout(BuildContext context) async {
    await Provider.of<UserSpaceViewModel>(context, listen: false).userDataProvider!.userLogout();
    if (context.mounted) {
      await Provider.of<TokenManager>(context, listen: false).updateToken();
    }
  }

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context) {
    return SettingFrameWidget(
      title: "工作區設定",
      subTitle: "工作區設定",
      child: _getPersonalDashboardBody(context),
    );
  }

  final objectGap = const Gap(10);

  Widget _getPersonalDashboardBody(BuildContext context) {
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PrimaryInfoFrame(
              color: primaryColor,
              child: KeyValuePairWidget(
                primaryColor: primaryColor,
                keyChild: "佈景主題",
                valueChild: "夜覽模式",
                action: CupertinoSwitch(
                    activeColor: primaryColor,
                    value: viewModel.settingEntity.isNightView,
                    onChanged: (value) => viewModel.onNightViewToggled(value)),
              ),
            ),
            const Gap(10),
            PrimaryInfoFrame(
              color: primaryColor,
              child: KeyValuePairWidget(
                primaryColor: primaryColor,
                keyChild: "佈景顏色",
                valueChild: "更改佈景主題顏色",
                action: UserActionButton.secondary(
                    onPressed: () => {
                      throw UnimplementedError()
                    },
                    icon: const Icon(Icons.square_rounded),
                    label: "顏色",
                    primaryColor: primaryColor),
              ),
            )
          ]));
  }
}