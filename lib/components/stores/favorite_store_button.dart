import 'package:crust/components/confirm.dart';
import 'package:crust/components/favorite_button.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:crust/models/store.dart' as MyStore;

class FavoriteStoreButton extends StatelessWidget {
  final MyStore.Store store;
  final double size;
  final EdgeInsets padding;
  final bool confirmUnfavorite;

  FavoriteStoreButton({Key key, this.store, this.size, this.padding, this.confirmUnfavorite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (Store<AppState> store) => _Props.fromStore(store),
        builder: (context, props) => _Presenter(
            store: store,
            size: size,
            padding: padding,
            favoriteStores: props.favoriteStores,
            favoriteStore: props.favoriteStore,
            unfavoriteStore: props.unfavoriteStore,
            isLoggedIn: props.isLoggedIn,
            confirmUnfavorite: confirmUnfavorite));
  }
}

class _Presenter extends StatelessWidget {
  final MyStore.Store store;
  final double size;
  final EdgeInsets padding;
  final Set<int> favoriteStores;
  final Function favoriteStore;
  final Function unfavoriteStore;
  final bool isLoggedIn;
  final bool confirmUnfavorite;

  _Presenter({Key key, this.store, this.size, this.padding, this.favoriteStores, this.favoriteStore, this.unfavoriteStore, this.isLoggedIn, this.confirmUnfavorite})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => FavoriteButton(
            padding: padding,
            size: size,
            isFavorited: favoriteStores.contains(store.id),
            onFavorite: () {
              if (isLoggedIn) {
                favoriteStore(store.id);
                snack(context, 'Added to favourites');
              } else {
                snack(context, 'Login now to favourite store');
              }
            },
            onUnfavorite: () {
              if (confirmUnfavorite == true) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Confirm(
                      title: 'Remove Store',
                      description: 'This store will be removed from favorites',
                      action: 'Remove',
                      onTap: () {
                        unfavoriteStore(store.id);
                        Navigator.of(context, rootNavigator: true).pop(true);
                      });
                  }
                );
              } else {
                unfavoriteStore(store.id);
                snack(context, 'Removed from favourites');
              }
            },
          ),
    );
  }
}

class _Props {
  final Set<int> favoriteStores;
  final Function favoriteStore;
  final Function unfavoriteStore;
  final bool isLoggedIn;

  _Props({
    this.favoriteStores,
    this.favoriteStore,
    this.unfavoriteStore,
    this.isLoggedIn,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      favoriteStores: store.state.me.favoriteStores ?? Set<int>(),
      favoriteStore: (storeId) => store.dispatch(FavoriteStoreRequest(storeId)),
      unfavoriteStore: (storeId) => store.dispatch(UnfavoriteStoreRequest(storeId)),
      isLoggedIn: store.state.me.user != null,
    );
  }
}
