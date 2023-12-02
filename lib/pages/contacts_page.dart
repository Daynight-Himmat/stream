import 'package:stream/app.dart';
import 'package:stream/screen/chat_screens.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'packages.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return UserListCore(
      limit: 20,
      filter: Filter.notEqual('id', context.currentUser!.id),
      errorBuilder: (BuildContext context, Object error) { return DisplayErrorMessage(error: error,); },
      emptyBuilder: (BuildContext context) { return const Center(child: Text('There are no users')); },
      loadingBuilder: (BuildContext context) { return const Center(
        child: CircularProgressIndicator(),
      ); },
      listBuilder: (BuildContext context, List<ListItem> users) {
        return Scrollbar(child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            return users[index].when(headerItem: (_)=> const SizedBox.shrink(),
                userItem: (users) => _ContactTile(user: users));
          },)
        );
      },);
  }
}


class _ContactTile extends StatelessWidget {
  final User user;
  const _ContactTile({Key? key, required this.user}) : super(key: key);

  Future<void> createChannel(BuildContext context) async{
    final core = StreamChatCore.of(context);
    final channel = core.client.channel('messaging',extraData: {
      'members' : [
        core.currentUser!.id,
        user.id
      ]
    });
    await channel.watch();
    Navigator.of(context).push(ChatScreen.routeWithChannel(channel));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        createChannel(context);
      },
      child: ListTile(
        leading: Avatar.small(url: user.image,),
        title: Text(user.name),
      ),
    );
  }
}
