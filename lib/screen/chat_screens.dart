import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream/app.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:collection/collection.dart' show IterableExtension;
import '../pages/packages.dart';
import 'screens.dart';

class ChatScreen extends StatefulWidget {
  static Route routeWithChannel(Channel channel) => MaterialPageRoute(builder: (context)=> StreamChannel(channel: channel, child: const ChatScreen()));
  const ChatScreen({Key? key,}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late StreamSubscription<int> unreadCountSubscription;

  Future<void> _unreadCountHandler(int count) async {
    if(count > 0) {
      await StreamChannel
          .of(context).channel.markRead();
    }
  }

  @override
  void initState() {
    unreadCountSubscription = StreamChannel.of(context).channel.state!.unreadCountStream.listen(_unreadCountHandler);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    unreadCountSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:Align(
          alignment: Alignment.centerRight,
          child: IconBackground(
            icon: CupertinoIcons.back,
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: const AppBarTitle(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: IconBorder(
              icon: CupertinoIcons.video_camera_solid,
              onTap: (){},
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: IconBorder(
              icon: CupertinoIcons.phone_solid,
              onTap: (){},
            ),),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: MessageListCore(
                  loadingBuilder: (context){
                    return const CircularProgressIndicator();
                  },
                  emptyBuilder: (context) =>
                    const SizedBox.shrink(),
                  messageListBuilder: (BuildContext context,List<Message> message){
                    return _MessageList(message: message);
                  },
                  errorBuilder:(context,error) {
                    return DisplayErrorMessage(error: error,);
                  }
              )
          ),
          const _ActionBar(),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList({Key? key, required this.message}) : super(key: key);
  final List<Message> message;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.separated(
          reverse: true,
          itemBuilder: (BuildContext context, int index) {
            if (index < message.length) {
              final messages = message[index];
              if(messages.user?.id == context.currentUser?.id){
                return _MessageTile(message: messages);
              }
              else{
                return _MessageOwnTile(message: messages);
              }
            }else{
              return const SizedBox.shrink();
            }
          },
          separatorBuilder: (BuildContext context, int index) {
            if(index == message.length - 1){
              return _DateLabel(dateTime: message[index].createdAt);
            }
            if(message.length == 1){
              return const SizedBox.shrink();
            } else if(index >= message.length -1){
              return const SizedBox.shrink();
            } else if(index <= message.length ){
              final messages = message[index];
              final nextMessage = message[index + 1];
              if(!Jiffy(messages.createdAt.toLocal()).isSame(nextMessage.createdAt.toLocal(),Units.DAY)){
                return _DateLabel(dateTime: messages.createdAt);
              }
              else{
                return const SizedBox.shrink();
              }
            }else{
              return const SizedBox.shrink();
            }
          },
          itemCount: message.length + 1,
        )
    );
  }
}


class _MessageOwnTile extends StatelessWidget {
  final Message message;
  static const _borderRadius = 26.0;

  const _MessageOwnTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .cardColor,
                    borderRadius:  const BorderRadius.only(
                        topLeft: Radius.circular(_borderRadius),
                        topRight: Radius.circular(_borderRadius),
                        bottomRight: Radius.circular(_borderRadius))
                ),
                child: Padding(
                  padding:const EdgeInsets.symmetric(horizontal: 12,vertical: 20),
                  child: Text(message.text ?? ""),
                )
            ),
             Padding(
              padding: const EdgeInsets.only(top: 8.0,right: 20,bottom: 8),
              child: Text(
                Jiffy(message.createdAt.toLocal()).jm,style: const TextStyle(
                  color: AppColors.textFaded,
                  fontSize: 10,
                  fontWeight: FontWeight.bold
              ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class _MessageTile extends StatelessWidget {
  const _MessageTile(
      {Key? key, required this.message})
      : super(key: key);

  final Message message;

  static const _borderRadius = 26.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(_borderRadius),
                      topRight: Radius.circular(_borderRadius),
                      bottomLeft: Radius.circular(_borderRadius))
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 12,vertical: 20),
                child: Text(message.text ?? ""),
              )
            ),
            Padding(padding: const EdgeInsets.only(top: 8.0,right: 0,bottom: 8),
                child: Text(
                    Jiffy(message.createdAt.toLocal()).jm,style: const TextStyle(
                  color: AppColors.textFaded,
                  fontSize: 10,
                  fontWeight: FontWeight.bold
                ),
                ),
            )
          ],
        ),
      ),
    );
  }
}


// class _DemoMessageList extends StatelessWidget {
//   const _DemoMessageList({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: ListView(
//         children: const [
//           _DateLabel(label: "Yesterday"),
//           _MessageTile(message: "Hi, Lucy! How's Your day going", messageDate: '12:01 AM'),
//           _MessageOwnTile(message: "Hi, Lucy! How's Your day going", messageDate: '12:01 PM'),
//           _MessageTile(message: "Hi, Lucy! How's Your day going", messageDate: '12:01 AM'),
//           _MessageTile(message: "Hi, Lucy! How's Your day going", messageDate: '12:01 PM')
//         ],
//       ),
//     );
//   }
// }

class _DateLabel extends StatefulWidget {
  final DateTime dateTime;
  const _DateLabel({Key? key, required this.dateTime}) : super(key: key);

  @override
  State<_DateLabel> createState() => _DateLabelState();
}

class _DateLabelState extends State<_DateLabel> {
  late String dayInfo;

  @override
  void initState() {
    final createAt = Jiffy(widget.dateTime);
    final now = DateTime.now();
    if(Jiffy(createAt).isSame(now,Units.DAY)){
      dayInfo = "Today";
    }else if(Jiffy(createAt).isSame(now.subtract(const Duration(days: 1)),Units.DAY)){
      dayInfo = "Yesterday";
    }
    else if(Jiffy(createAt).isAfter(now.subtract(const Duration(days: 7)),Units.DAY)){
      dayInfo = createAt.EEEE;
    }
    else if(Jiffy(createAt).isAfter(Jiffy(now).subtract(years: 1),Units.DAY)){
      dayInfo = createAt.MMMd;
    }else{
      dayInfo = createAt.MMMd;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 12),
            child: Text(dayInfo, style: const TextStyle(fontSize:12,fontWeight: FontWeight.bold),),
          ),
        ),
      ),
    );

  }
}




class AppBarTitle extends StatelessWidget {
  const AppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channel =  StreamChannel.of(context).channel;
    return Row(
      children: [
        Avatar.small(url: Helper.getChannelImage(channel, context.currentUser!)),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(Helper.getChannelName(channel, context.currentUser!)!, overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 14),),
               const SizedBox(height: 3,),
              BetterStreamBuilder<List<Member>>(
                stream: channel.state!.membersStream,
                  builder: (BuildContext context,List<Member> data){
                    return ConnectionStatusBuilder(
                      loadingBuilder: (BuildContext context) => const SizedBox( height: 70, width: 70,child: CircularProgressIndicator(),),
                      statusBuilder: (BuildContext context, ConnectionStatus status) {
                        switch(status){
                          case ConnectionStatus.connected:
                            return _buildConnectionTitleState(context, data);
                          case ConnectionStatus.connecting:
                            return const Text("Connecting...",style:TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.green));
                          case ConnectionStatus.disconnected:
                            return const Text("Offline",style:TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.redAccent));
                        }
                      },);
                  },
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildConnectionTitleState(BuildContext context,List<Member>? member){
    Widget? alternativeWidget;
    final channel = StreamChannel.of(context).channel;
    final memberCount = channel.memberCount;
    if(memberCount != null && memberCount > 2){
      var text = "Members: $memberCount";
      final watcherCount = channel.state?.watcherCount ?? 0;
      if(watcherCount > 0){
        alternativeWidget = Text(text);
      }
    }else{
      final userId = StreamChatCore.of(context).currentUser?.id;
      final otherMember  = member?.firstWhereOrNull((element){
        return element.userId != userId;
      });
      if(otherMember != null){
        if(otherMember.user?.online == true){
          alternativeWidget = const Text("Online",style: TextStyle( fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),);
        }else{
          alternativeWidget = Text("Last online ${Jiffy(otherMember.user?.lastActive).fromNow()}",style: TextStyle( fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),);
        }
      }
    }
    return TypingIndicator(
      alternativeWidget: alternativeWidget,
    );
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({Key? key, this.alternativeWidget}) : super(key: key);
  final Widget? alternativeWidget;

  @override  
  Widget build(BuildContext context) {
    final channelState = StreamChannel.of(context).channel.state;
    final altWidget = alternativeWidget ?? const SizedBox.shrink();
    return BetterStreamBuilder<Iterable<User>>(
      stream: channelState?.typingEventsStream.map((event) => event.entries.map((e) => e.key)),
      builder: (BuildContext context, Iterable<User> data){
        return Align(
          alignment: Alignment.centerLeft,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: data.isNotEmpty ? const Align(
              alignment: Alignment.centerLeft,
              key: ValueKey('typing-text'),
              child: Text('Typing message',maxLines: 1,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
            ) : Align( alignment: Alignment.centerLeft,key : const ValueKey('altWidget') , child: altWidget,),
          ),
        );
      },
    );
  }
}


class ConnectionStatusBuilder extends StatelessWidget {
  const ConnectionStatusBuilder({Key? key, this.connectionStatusStream, this.errorBuilder,  this.loadingBuilder, required this.statusBuilder}) : super(key: key);
  final Stream<ConnectionStatus>? connectionStatusStream;
  final Widget Function(BuildContext context, Object error)? errorBuilder;
  final WidgetBuilder? loadingBuilder;
  final Widget Function(BuildContext context, ConnectionStatus status) statusBuilder;


  @override
  Widget build(BuildContext context) {
    final stream = connectionStatusStream ?? StreamChatCore.of(context).client.wsConnectionStatusStream;
    final client = StreamChatCore.of(context).client;
    return BetterStreamBuilder<ConnectionStatus>(
        stream: stream,
        initialData: client.wsConnectionStatus,
        noDataBuilder: loadingBuilder,
        errorBuilder: (context, error){
          if(errorBuilder != null ){
            return errorBuilder!(context, error);
          }
          return const Offstage();
        },
        builder: statusBuilder);

  }
}



class _ActionBar extends StatefulWidget {

  const _ActionBar({Key? key}) : super(key: key);

  @override
  State<_ActionBar> createState() => _ActionBarState();
}

class _ActionBarState extends State<_ActionBar> {

  TextEditingController controller = TextEditingController();

  Future<void> _sendMessage() async {
    if(controller.text.isNotEmpty){
      StreamChannel.of(context).channel.sendMessage(Message(text: controller.text));
      controller.clear();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  width: 2,
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                CupertinoIcons.camera_fill,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TextField(
                controller: controller,
                onChanged: (val) {
                  StreamChannel.of(context).channel.keyStroke();
                },
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Type something...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 24.0,
            ),
            child: GlowingActionButton(
              color: AppColors.accent,
              icon: Icons.send_rounded,
              onPressed: ( ) {
                _sendMessage();
              }
            ),
          ),
        ],
      ),
    );
  }
}