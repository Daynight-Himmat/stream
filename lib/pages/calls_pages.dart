import 'packages.dart';

class CallsPages extends StatefulWidget {
  const CallsPages({Key? key}) : super(key: key);

  @override
  State<CallsPages> createState() => _CallsPagesState();
}

class _CallsPagesState extends State<CallsPages> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: const Text("Calls Page")),
    );
  }
}
