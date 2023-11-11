import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/View/components/components.dart';
import 'package:grouping_project/ViewModel/workspace/workspace_view_model.dart';
import 'package:provider/provider.dart';

class WorkspaceView extends StatefulWidget {
  const WorkspaceView({Key? key}) : super(key: key);

  @override
  State<WorkspaceView> createState() => _WorkspaceViewState();
}

class _WorkspaceViewState extends State<WorkspaceView> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WorkspaceViewModel>(
      create: (context) => WorkspaceViewModel(),
      child: Scaffold(
        // drawer: const Drawer(),
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   title: const Text('張百寬的工作區'),
        //   centerTitle: false,
        //   titleSpacing: 5,
        //   titleTextStyle: const TextStyle(
        //     fontSize: 16,
        //     color: Colors.black,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   leadingWidth: 50,
        //   leading: const Padding(
        //     padding:  EdgeInsets.all(6.0),
        //     child: CircleAvatar(
        //       radius: 16,
        //       child: Text("張"),
        //     ),
        //   ),
        //   actions: [
        //     Builder(
        //       builder: (context) {
        //         return IconButton(
        //           onPressed: () => Scaffold.maybeOf(context)!.openDrawer(),
        //           icon: const Icon(Icons.menu),
        //         );
        //       }
        //     ),
        //   ],
          
        // ),
        body: Consumer<WorkspaceViewModel>(
          builder: (context, viewModel, child) => Stack(
            children: [
              Align(
                alignment: kIsWeb ? Alignment.topRight : Alignment.topCenter,
                child: MessagesList(messageService: viewModel.messageService),
              ),
              Center(
                child: TextButton(onPressed: ()async => {
                  viewModel.onPress(),
                  // await showMessage(viewModel.messageService)
                  }, child: const Text("Switch workspace"))
              ),
              
            ],
          ),
        )
      ),
    );
  }
}



