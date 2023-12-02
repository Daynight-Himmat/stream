import 'package:flutter/cupertino.dart';
import 'package:stream/app.dart';
import 'package:stream/pages/packages.dart';
import 'screens.dart' ;


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final ValueNotifier<int> pageIndex = ValueNotifier(0);
  final ValueNotifier<String> title = ValueNotifier("Message");

  final pages = const [
    MessagePage(),
    NotificationPage(),
    CallsPages(),
    ContactPage()
  ];

  final pageTitle = [
    'Message',
    'Notification',
    'Calls',
    'Contacts'
  ];
  var currentValue = 0;

  void onNavigationItemSelected(index){
    title.value = 'text';
    title.value = pageTitle[index];
    pageIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        leadingWidth: 54,
        leading: Align(
          alignment: Alignment.centerRight,
          child: IconBackground(
              onTap: (){},
              icon: Icons.search
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Hero(
              tag: 'hero-profile-picture',
              child: Avatar.small(url: context.currentUserImage, onTap: (){
                Navigator.of(context).push(ProfileScreen.route);
              },),
            ),
          )
        ],
        title: ValueListenableBuilder(
          valueListenable: title,
          builder: (BuildContext context, value, Widget? _) {
            return Text(title.value);
          },),
      ) ,
      body: ValueListenableBuilder(
        valueListenable: pageIndex,
        builder: (BuildContext context, int value, Widget? _) {
          return pages[value];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onItemSelected: onNavigationItemSelected
      )
    );
  }
}


class BottomNavigationBar extends StatefulWidget {
  final ValueChanged<int> onItemSelected;

  const BottomNavigationBar({Key? key, required this.onItemSelected})
      : super(key: key);

  @override
  State<BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {

  var selectedIndex = 0;

  void handleItemSelected(int index){
    setState(() {
      selectedIndex = index;
    });
    widget.onItemSelected(index);
  }
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Card(
      color: (brightness == Brightness.light) ? Colors.transparent : null,
      margin: const EdgeInsets.all(0),
      elevation: 0 ,
      child: SafeArea(
          top: false,
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0,left: 8,right: 8,bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavigationBarItem(
                  index: 0,
                  label: "Message",
                  isSelected: (selectedIndex == 0),
                  iconData: CupertinoIcons.bubble_left_bubble_right_fill,
                  onTap: handleItemSelected,),
                NavigationBarItem(index: 1,
                  label: "Notification",
                  isSelected: (selectedIndex == 1),
                  iconData: CupertinoIcons.bell_solid,
                  onTap: handleItemSelected,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GlowingActionButton(color: AppColors.secondary, icon: CupertinoIcons.add, onPressed: (){ showDialog(context: context, builder: (context) {
                    return const Dialog(
                      child: AspectRatio(
                           aspectRatio: 8/7,
                        child: ContactPage(),
                      )
                    );
                    });
                  }),
                ),
                NavigationBarItem(index: 2,
                  label: "Calls",
                  iconData: CupertinoIcons.phone_fill,
                  isSelected: (selectedIndex == 2),
                  onTap: handleItemSelected,),
                NavigationBarItem(index: 3,
                  label: "Contacts",
                  isSelected: (selectedIndex == 3),
                  iconData: CupertinoIcons.person_2_fill,
                  onTap: handleItemSelected,)
              ],
            ),
          )
      ),
    );
  }
}

class NavigationBarItem extends StatelessWidget {
  final int index;
  final String label;
  final IconData iconData;
  final bool isSelected ;
  final ValueChanged<int> onTap;
  const NavigationBarItem({Key? key, required this.onTap, required this.index, required this.label, required this.iconData,  this.isSelected = false,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {onTap(index);},
        child:  SizedBox(
          height: 70,
          width: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData,size: 20,color: isSelected ? AppColors.secondary : null,),
              const SizedBox(height: 5,),
              Text(label, style: TextStyle(fontSize:  11, color: isSelected ? AppColors.secondary : null),),
            ],
          ),
        ),
      ),
    );
  }
}


