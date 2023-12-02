import 'package:stream/Model/demo_users.dart';
import 'package:stream/app.dart';
import 'package:stream/pages/packages.dart';
import 'package:stream/screen/home.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class SelectUserScreen extends StatefulWidget {

  static Route get route => MaterialPageRoute(builder: (context)=> const SelectUserScreen());
  const SelectUserScreen({Key? key}) : super(key: key);

  @override
  State<SelectUserScreen> createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  bool _loading = false;

  Future<void> onUserSelected(DemoUser user) async {
    setState(() {
      _loading = true;
    });

    try{
      final client  =  StreamChatCore.of(context).client;

      await client.connectUser(User(id: user.id,extraData: {
        'name': user.name,
        'image': user.image
      }), client.devToken(user.id).rawValue);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomeScreen()));
    }
    on Exception catch(e, st){
      logger.e("could not connect user", e, st);
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: (_loading) ? const CircularProgressIndicator() : Padding(padding: EdgeInsets.all(16), child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text("Select User"),
            ),
            Expanded(child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                return SelectUserButton(
                  user: users[index],
                  onPressed: onUserSelected
                );
              },)
            )
          ],
        ),),
      ),
    );
  }
}


class SelectUserButton extends StatelessWidget {
  final DemoUser user;
  final Function(DemoUser user) onPressed;
  const SelectUserButton({Key? key, required this.user, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(16),
    child: InkWell(
      onTap: ()=> onPressed(user),
      child: Row(
        children: [
          Avatar.large(url: user.image,),
          Padding(padding: const
            EdgeInsets.all(8.0),
          child: Text(user.name, style:const TextStyle(fontSize: 16),),)

        ],
      ),
    ),);
  }
}
