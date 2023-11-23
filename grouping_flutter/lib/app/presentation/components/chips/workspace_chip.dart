import 'package:flutter/material.dart';
import 'package:grouping_project/dashboard/data/models/workspace_model.dart';

class WorkspaceChip extends StatelessWidget {
  const WorkspaceChip({super.key, required this.workspace});

  final WorkspaceModel workspace;

  @override
  Widget build(BuildContext context) {
    // debugPrint('themeColor: ${workspace.themeColor.toString()}');
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          width: 7,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              // border: Border.all(),
              color: Color(workspace.themeColor)),
        ),
        Container(
          // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(workspace.themeColor)),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(),
                  image: DecorationImage(
                    image: workspace.photo != null
                        ? NetworkImage(workspace.photo!.data)
                        : const AssetImage('assets/images/404_not_found.png')
                            as ImageProvider,
                    // image: AssetImage('welcome')
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                workspace.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }
}
