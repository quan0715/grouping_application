import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/space/presentation/views/components/user_action_button.dart';

class CreateWorkspaceDialog extends StatelessWidget{
  const CreateWorkspaceDialog({super.key});

  @override
  Widget build(BuildContext context) => _buildBody(context);

  TextStyle titleTextStyle(BuildContext context) => Theme.of(context).textTheme.titleLarge!.copyWith(
    color: Theme.of(context).primaryColor,
    fontWeight: FontWeight.bold,
  );

  TextStyle labelTextStyle(BuildContext context) => Theme.of(context).textTheme.titleMedium!.copyWith(
    color: Theme.of(context).primaryColor,
    fontWeight: FontWeight.bold,
  );

  EdgeInsets get _innerPadding => const EdgeInsets.all(40.0);

  Widget _buildBody(BuildContext context){
    return Dialog(
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
              Text("建立新小組", style: titleTextStyle(context)),
              const Divider(),
              _buildGroupBasicInfoInputSection(context),
              _buildGroupAdditionalInfoInputSection(context),
              const Gap(10),
              _buildActionList(context),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildActionList(BuildContext context){
    return Row(
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
          onPressed: (){
            // Navigator.of(context).pop();
            // TODO: implement create new workspace usecase
          },
        ),
      ],
    );
  }
  
  Widget _buildGroupBasicInfoInputSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("小組基本資料", style: labelTextStyle(context)),
            Row(
              children: [
                // upload image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(Icons.add_a_photo),
                ),
                const Gap(10),
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "請輸入小組名稱",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(10),
            Text("小組介紹", style: labelTextStyle(context)),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "請輸入小組介紹",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(10),
            Text("小組標籤", style: labelTextStyle(context)),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 60,
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
                              onPressed: (){}, 
                              child: const Row(
                                children: [
                                  Icon(Icons.add),
                                  Gap(5),
                                  Text("新增標籤"),
                                ],
                              )),
                          ],
                        ),
                      )
                    ),
                     
                  )
                ),
              ],
            ),
            const Gap(10),
          ]
        ),
      ),
    );
  }
  
  Widget _buildGroupAdditionalInfoInputSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("佈景主題顏色", style: labelTextStyle(context)),
                // const Gap(10),
                Text(
                  "更改佈景主題顏色", 
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  )
                )
              ],
            ),
            const Spacer(),
            // dropdown menu to chose color
            DropdownButton(
              items: const [
                DropdownMenuItem(
                  child: Text("紅色"),
                  value: "red",
                ),
                DropdownMenuItem(
                  child: Text("藍色"),
                  value: "blue",
                ),
                DropdownMenuItem(
                  child: Text("綠色"),
                  value: "green",
                ),
              ], 
              onChanged: (value){}
            )
          ],
        ),
      ),
    );
  }
}