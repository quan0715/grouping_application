import 'package:flutter/material.dart';
import 'package:grouping_project/threads/presentations/viewmodel/thread_view_model.dart';
import 'package:grouping_project/threads/presentations/widgets/chat_action_promt.dart';
import 'package:grouping_project/threads/presentations/widgets/chat_message.dart';
import 'package:provider/provider.dart';

class ChatThreadBody extends StatefulWidget {
  final String threadTitle;

  const ChatThreadBody({
    super.key,
    this.threadTitle = "新MMIS Bot",
  });

  @override
  State<ChatThreadBody> createState() => _ChatThreadBodyState();
}

class _ChatThreadBodyState extends State<ChatThreadBody> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<ThreadViewModel>(
    create: (context) => ThreadViewModel(),
    child: _buildBody(context)
  );

  Widget _buildBody(BuildContext context){
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.3,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            )
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildTitleFrame(context),
                _buildChatFrame(context),
                _buildInputFrame(context),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildTitleFrame(BuildContext context) {
    return Row(
      children: [
        Text(widget.threadTitle, style: Theme.of(context).textTheme.titleMedium,),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
        )
      ],
    );
  }

  Widget _buildChatFrame(BuildContext context) {
    return Consumer<ThreadViewModel>(
      builder: (context, viewModel, child) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: viewModel.messages.isNotEmpty
            ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...viewModel.messages.map((message) => ChatMessageCard(message: message)),
                ],
              ),
            )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Text("沒有新訊息", style: TextStyle(fontSize: 18),),
                ],
            ),
        ),
      ),
    );
  }

  Widget _buildInputFrame(BuildContext context) {
    return Container(
      decoration:BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        )
      ),
      child: Consumer<ThreadViewModel>(
        builder: (context, viewModel, child) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () => {
                  debugPrint("attach file")
                },
                style: IconButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                icon: const Icon(Icons.attach_file_outlined),
              ),
              Expanded(
                child: TextFormField(
                  controller: textController..addListener(() {
                    viewModel.inputText = textController.text;
                  }),
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "請輸入訊息",
                    contentPadding: EdgeInsets.all(10),
                  ),
                  onFieldSubmitted: (value) {
                    if(viewModel.canSendMessage){
                      debugPrint("send message $value");
                      viewModel.addMessage(value);
                      textController.clear();
                    }
                  },
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(width: 10,),
              IconButton(
                onPressed: viewModel.canSendMessage ? (){
                  debugPrint("send message ${viewModel.inputText}");
                  viewModel.addMessage(viewModel.inputText);
                  textController.clear();
                } : null,
                style: IconButton.styleFrom(
                  disabledBackgroundColor: Theme.of(context).colorScheme.onPrimary,
                  disabledForegroundColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                icon: const Icon(Icons.send_rounded),
              )
            ],
          ),
        ),
      ),
    );
  }
}