import 'package:flutter/material.dart';
import 'package:stream/pages/packages.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class UnreadIndicator extends StatelessWidget {
  const UnreadIndicator({Key? key, required this.channel}) : super(key: key);

  final Channel channel;
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: BetterStreamBuilder<int>(
        stream: channel.state!.unreadCountStream,
        builder: (context, data){
          if(data == 0){
            return const SizedBox.shrink();
          }
          return Material(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.secondary,
            child: Padding(
              padding: const EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
              child: Center(
                child: Text(style:const TextStyle(fontSize: 11, color: Colors.white),
                  "${data > 99 ? "99+" : data}",
                )
              ),
            ),
          );
        },
      ),
    );
  }
}
