import 'dart:async';
import 'package:block_agri_mart/app/app.dart';
import 'package:block_agri_mart/hive/boxes.dart';
import 'package:block_agri_mart/hive/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dialogflow_grpc/dialogflow_grpc.dart';
import 'package:dialogflow_grpc/generated/google/cloud/dialogflow/v2beta1/session.pb.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

late DialogflowGrpcV2Beta1 dialogflow;

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlugin();
  }

  Future<void> initPlugin() async {
    final serviceAccount = ServiceAccount.fromString(
        (await rootBundle.loadString('assets/credentials.json')));
    dialogflow = DialogflowGrpcV2Beta1.viaServiceAccount(serviceAccount);
  }

  void handleSubmitted(text) async {
    _textController.clear();

    ChatsUtils.addChat(text: text, time: ChatsUtils.getChatDate(), type: true);

    DetectIntentResponse data = await dialogflow.detectIntent(text, 'en-US');
    String fulfillmentText = data.queryResult.fulfillmentText;
    if (fulfillmentText.isNotEmpty) {
      ChatsUtils.addChat(
          text: fulfillmentText, time: ChatsUtils.getChatDate(), type: false);
    } else {
      ChatsUtils.addChat(
          text:
              'Oops, something went wrong. Please check your internet connection and try again',
          time: ChatsUtils.getChatDate(),
          type: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomShaderMask(
          blendMode: BlendMode.srcIn,
          gradient: LinearGradient(
              colors: [ColorConstants.primaryColor, Colors.blue]),
          child: const CustomText(
            label: 'AgriChat',
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          PopupMenuButton(
              color: Theme.of(context).backgroundColor,
              onSelected: (value) {
                switch (value) {
                  case 0:
                    ChatsUtils.deleteAllChats();
                    break;
                  default:
                }
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                        value: 0,
                        child: ListTile(
                          tileColor: Theme.of(context).backgroundColor,
                          leading: Icon(Icons.clear_all,
                              color: Theme.of(context).iconTheme.color),
                          title: const CustomText(
                            label: 'Clear Chats',
                            fontSize: 14,
                          ),
                        ))
                  ])
        ],
      ),
      body: Column(children: [
        Flexible(
            child: ValueListenableBuilder<Box<ChatModel>>(
                valueListenable: Boxes.getChats().listenable(),
                builder: (context, box, _) {
                  final chats =
                      box.values.toList().reversed.toList().cast<ChatModel>();
                  AppUtils.appLog('Chats length ' + chats.length.toString());
                  return chats.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          reverse: true,
                          itemBuilder: (_, int index) {
                            return Dismissible(
                              behavior: HitTestBehavior.translucent,
                              background: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  color: Colors.red,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ],
                                  )),
                              onDismissed: (DismissDirection direction) {
                                if (direction == DismissDirection.startToEnd) {
                                  ChatsUtils.deleteChatAt(
                                      chatModel: chats[index]);
                                } else {
                                  ChatsUtils.deleteChatAt(
                                      chatModel: chats[index]);
                                }
                              },
                              key: UniqueKey(),
                              child: ChatMessage(
                                  text: chats[index].text,
                                  time: DateFormat().format(
                                      DateTime.parse(chats[index].time)),
                                  type: chats[index].type),
                            );
                          },
                          itemCount: chats.length,
                        )
                      : const NoChats();
                })),
        const Divider(height: 1.0),
        Container(
            decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
            child: IconTheme(
              data: IconThemeData(color: ColorConstants.primaryColor),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _textController,
                        onSubmitted: handleSubmitted,
                        style: Theme.of(context).textTheme.headline3,
                        decoration: InputDecoration.collapsed(
                            hintText: "Send a message",
                            hintStyle: Theme.of(context).textTheme.headline3),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => handleSubmitted(_textController.text),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ]),
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {Key? key, required this.text, required this.time, required this.type})
      : super(key: key);

  final String text;
  final String time;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: CircleAvatar(
          backgroundImage: AssetImage(AppUtils.getImage(name: 'logo')),
        ),
      ),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: type ? Colors.blue : ColorConstants.primaryColor)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: CustomText(
                  label: text,
                ),
              ),
              spaceH1,
              CustomText(
                label: time,
                fontSize: 12,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: type ? Colors.blue : ColorConstants.primaryColor)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 5.0,
                ),
                child: CustomText(
                  label: text,
                ),
              ),
              spaceH1,
              CustomText(
                label: time,
                fontSize: 12,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          backgroundImage: AssetImage(AppUtils.getAvatarImage(key: 1)),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}

class NoChats extends StatelessWidget {
  const NoChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CustomText(
          label: 'No chats',
          fontSize: 20,
        )
      ],
    ));
  }
}
