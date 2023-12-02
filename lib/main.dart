import 'package:flutter/material.dart';
import 'package:stream/app.dart';
import 'package:stream/screen/home.dart';
import 'package:stream/screen/screens.dart';
import 'package:stream/theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

void main() {
  final client = StreamChatClient(streamKey);
  runApp( MyApp(client: client,));
}

class MyApp extends StatelessWidget {
  final StreamChatClient client;
  const MyApp({super.key, required this.client});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:AppTheme().light,
      darkTheme: AppTheme().dark,
      themeMode: ThemeMode.dark,
      builder: (context, child) {
        return StreamChatCore(
            client: client,
            child: ChannelsBloc(
              child: UsersBloc(
                child: child!,
              )
            ));
      },
      home: const SelectUserScreen(),
    );
  }
}
