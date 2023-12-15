import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/app/presentation/components/data_display/title_with_content.dart';
import 'package:grouping_project/app/presentation/providers/token_manager.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/presentation/view_models/create_worksapce_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/key_value_pair_widget.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';
import 'package:grouping_project/space/presentation/views/components/user_action_button.dart';
import 'package:provider/provider.dart';

class CreateWorkspaceDialog extends StatelessWidget {
  const CreateWorkspaceDialog({super.key});

  @override
  Widget build(BuildContext context) => _buildBody(context);

  TextStyle titleTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge!.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          );

  TextStyle labelTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.labelMedium!.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          );

  EdgeInsets get _innerPadding => const EdgeInsets.all(40.0);

  Widget _buildBody(BuildContext context){
    return ChangeNotifierProvider(
      create: (context) => CreateWorkspaceViewModel(
        Provider.of<TokenManager>(context, listen: false).tokenModel,
      ),
      child: Dialog(
        backgroundColor: Colors.white,
        elevation: 0,
        child: Padding(
          padding: _innerPadding,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
              // maxHeight: 500,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleWithContent(
                  title: "建立新小組", 
                  content: "建立你的團隊，並邀請成員加入",
                ),
                const Divider(),
                _buildGroupBasicInfoInputSection(context),
                const Gap(10),
                _buildGroupAdditionalInfoInputSection(context),
                const Gap(10),
                _buildActionList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
  Widget _buildActionList(BuildContext context){
    return Consumer<CreateWorkspaceViewModel>(
      builder: (context, viewModel, child) => Row(
        children: [
          const Spacer(),
          UserActionButton.secondary(
            label: "取消", 
            primaryColor: Theme.of(context).primaryColor,
            icon: const Icon(Icons.close),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          const Gap(10),
          UserActionButton.primary(
            label: "建立新小組", 
            primaryColor: Theme.of(context).primaryColor,
            icon: const Icon(Icons.check),
            onPressed: () async {
              await viewModel.createWorkspace();
              if(context.mounted){
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGroupBasicInfoInputSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.mainSpaceColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("小組基本資料", style: labelTextStyle(context)),
              const Gap(5),
              Row(
                children: [
                  ProfileAvatar(
                    themePrimaryColor: AppColor.mainSpaceColor,
                    label: "label",
                    avatarSize: 48,
                    avatar: Icon(
                      Icons.add_a_photo,
                      color: AppColor.onSurfaceColor,
                      size: 20,
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Center(
                      child: TextField(
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: AppColor.onSurfaceColor,
                                ),
                        decoration: InputDecoration(
                          hintText: "請輸入小組名稱",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              const AppTextFormField(
                // title: "小組介紹",
                hintText: "請輸入小組介紹"
              ),
              const Gap(10),
              Text("小組標籤", style: labelTextStyle(context)),
              const Gap(5),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black54,
                              ),
                              onPressed: () {},
                              child: Row(
                                children: [
                                  const Icon(Icons.add),
                                  const Gap(5),
                                  Text(
                                    "新增標籤",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: AppColor.onSurfaceColor,
                                        ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    )),
                  )),
                ],
              ),
              const Gap(10),
            ]),
      ),
    );
  }

  Widget _buildGroupAdditionalInfoInputSection(BuildContext context) {
    return KeyValuePairWidget(
        primaryColor: AppColor.mainSpaceColor,
        keyChild: "佈景主題顏色",
        valueChild: "更改佈景主題顏色",
        action: DropdownButton(
          isDense: true,
          underline: const SizedBox(),
          value: 1,
          items: [
            DropdownMenuItem(
              value: 1,
              child: CircleAvatar(backgroundColor: AppColor.spaceColor1, radius: 12,),
            ),
            DropdownMenuItem(
              value: 2,
              child: CircleAvatar(backgroundColor: AppColor.spaceColor2, radius: 12,),
            ),
            DropdownMenuItem(
              value: 3,
              child: CircleAvatar(backgroundColor: AppColor.spaceColor3, radius: 12,),
            ),
            DropdownMenuItem(
              value: 4,
              child: CircleAvatar(backgroundColor: AppColor.spaceColor4, radius: 12,),
            ),
          ], 
          onChanged: (value){}
      )
      );
  }
}
