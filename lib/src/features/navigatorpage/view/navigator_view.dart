import 'package:auto_route/auto_route.dart';
import 'package:flash_angebote/src/features/homepage/view/homepage_view.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'NavigatorRoute')
class NavigatorView extends StatefulWidget {
  const NavigatorView({super.key});

  @override
  State<NavigatorView> createState() => _NavigatorViewState();
}

class _NavigatorViewState extends State<NavigatorView> {
  int _activePageIndex = 0;
  List<Widget> screenList = [HomePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[_activePageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined), label: '')
        ],
      ),
    );
  }
}
