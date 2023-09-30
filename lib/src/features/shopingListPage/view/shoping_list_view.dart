import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'ListRoute')
class ShopingListPage extends StatefulWidget {
  const ShopingListPage({super.key});

  @override
  State<ShopingListPage> createState() => _ShopingListPageState();
}

class _ShopingListPageState extends State<ShopingListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("List Page"),
      ),
    );
  }
}
