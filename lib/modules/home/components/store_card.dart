import 'package:crust/modules/home/models/store.dart';
import 'package:flutter/material.dart';

class StoreCard extends StatelessWidget {
  final Store store;

  StoreCard(this.store);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Hero(
        tag: '${store.id}__heroTag',
        child: Text('${store.name}'),
      ),
    );
  }
}
