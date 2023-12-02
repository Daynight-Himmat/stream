import 'package:faker/faker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream/app.dart';
import '../screen/chat_screens.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'packages.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  final channelListController = ChannelListController();
  @override
  Widget build(BuildContext context) {
   return ChannelListCore(
     channelListController: channelListController,
     filter: Filter.and([
       Filter.equal('type', 'messaging'),
       Filter.in_('members', [StreamChatCore.of(context).currentUser!.id])
     ]),
     errorBuilder: (BuildContext context, Object error) {
       return const DisplayErrorMessage();
     },
     emptyBuilder: (BuildContext context) {
       return const Center(
         child: Text(
           " So Empty.\n Go and message Someone", style: TextStyle( fontSize: 17, ),textAlign: TextAlign.center,
         )
       );
     },
     loadingBuilder: (BuildContext context) {
       return const Center(
         child: SizedBox(
           height: 70,
           width: 70,
           child: CircularProgressIndicator(),
         )
       );
     },
     listBuilder: (BuildContext context , List<Channel> channel ) {
       return CustomScrollView(
       slivers: [
         const SliverToBoxAdapter(
           child: _Stories(),
         ),
         SliverList(
           delegate: SliverChildBuilderDelegate((context, index){
             return _MessageTile(channel: channel[index],);
           }, childCount: channel.length)
         ),
       ],
     );
   },
   );
    // return CustomScrollView(
    //   slivers: [
    //     const SliverToBoxAdapter(
    //       child: _Stories(),
    //     ),
    //     SliverList(
    //       delegate: SliverChildBuilderDelegate(_delegate)
    //     ),
    //   ],
    // );
  }

  // Widget _delegate(BuildContext context, int index){
  //   final Faker faker = Faker();
  //   final date = Helper.randomDate();
  //   return _MessageTile(messageData: MessageData(
  //     message: faker.lorem.sentence(),
  //     senderName: faker.person.firstName(),
  //     messageDate: date,
  //     dateMessage: Jiffy(date).fromNow(),
  //     profilePicture: Helper.randomPictureUrl()));
  // }
}

class _MessageTile extends StatelessWidget {
  const _MessageTile({Key? key,required this.channel}) : super(key: key);

  final Channel channel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(ChatScreen.routeWithChannel(channel));
        },
      child: Container(
        width: 100,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color:Colors.grey,
              width: 0.2
            )
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Avatar.medium(url: Helper.getChannelImage(channel, context.currentUser!)),
              ),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:  8.0),
                  child: Text(Helper.getChannelName(channel, context.currentUser!)!, overflow: TextOverflow.ellipsis, style: const TextStyle(letterSpacing: 0.2,wordSpacing: 1.5,fontWeight: FontWeight.w900),),
                ),
                  SizedBox(
                  height: 20,
                    child: _buildLastMessage()
                )
              ],)),
              Padding(
                  padding:const EdgeInsets.only(right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    _buildLastMessageTime(),
                    const SizedBox(
                      height: 8,
                    ),
                    UnreadIndicator(channel: channel)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLastMessage(){
    return  BetterStreamBuilder<int>(stream: channel.state!.unreadCountStream,initialData: channel.state?.unreadCount ?? 0, builder:(context,count ){
      return BetterStreamBuilder<Message>(
          stream: channel.state!.lastMessageStream,
          initialData: channel.state!.lastMessage,
          builder: (context, lastMessage){
            return Text(lastMessage.text ?? '',overflow:TextOverflow.ellipsis,
              style: (count > 0) ? const TextStyle(
                fontSize: 12, color: AppColors.secondary
            ) : const TextStyle(
                  fontSize: 12, color: AppColors.textFaded
              ));
          }
      );
    });
  }

  Widget _buildLastMessageTime(){
    return BetterStreamBuilder<DateTime>(
        stream: channel.lastMessageAtStream,
        initialData: channel.lastMessageAt,
        builder: (context, data){
          final lastMessageAt = data.toLocal();
          String stringData;
          final now = DateTime.now();
          final startOfDay = DateTime(now.year, now.month, now.day);
          if(lastMessageAt.millisecondsSinceEpoch >= startOfDay.millisecondsSinceEpoch){
            stringData = Jiffy(lastMessageAt.toLocal()).jm;
          }
          else if(lastMessageAt.millisecondsSinceEpoch >= startOfDay.subtract( const Duration(days: 1)).millisecondsSinceEpoch){
            stringData = 'YesterDay';
          }
          else if(startOfDay.difference(lastMessageAt).inDays < 7){
            stringData = Jiffy(lastMessageAt.toLocal()).EEEE;
          }
          else{
            stringData = Jiffy(lastMessageAt.toLocal()).yMd;
          }
          return Text(stringData,overflow:TextOverflow.ellipsis,style: const TextStyle(
              fontSize: 11, letterSpacing: -0.2,color: AppColors.textFaded
          ),);
        }
    );
  }
}



class _Stories extends StatelessWidget {
  const _Stories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: SizedBox(
        height: 134,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0, top: 8, bottom: 16),
              child: Text("Stories", style: TextStyle(fontSize: 15,
                  color: AppColors.textFaded,
                  fontWeight: FontWeight.w900),),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  Faker faker = Faker();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        child: _StoryCard(storyData: StoryData(name: faker.person.firstName(), url: Helper.randomPictureUrl())  )),
                  );
                },),
            )
          ],
        ),
      ),
    );
  }
}


class _StoryCard extends StatelessWidget {
  final StoryData storyData;

  const _StoryCard({Key? key, required this.storyData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Avatar.medium(url: storyData.url),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(storyData.name, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11,
                      letterSpacing: 0.3,
                      fontWeight: FontWeight.bold),
                )
            )
        )
      ],
    );
  }
}
