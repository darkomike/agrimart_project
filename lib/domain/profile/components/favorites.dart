import 'package:block_agri_mart/domain/domain.dart';
import 'package:block_agri_mart/hive/boxes.dart';
import 'package:block_agri_mart/hive/favourites_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../app/app.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
          showCart: true,
          showProfilePic: true,
          title: 'Favorites',
          showAddProduct: false,
          isDashboard: false,
          showNotification: true,
          onTransparentBackground: false),
      floatingActionButton: ValueListenableBuilder<Box<FavoriteModel>>(
          valueListenable: Boxes.getFavorites().listenable(),
          builder: (context, box, _) {
            return box.values.toList().isNotEmpty
                ? FloatingActionButton.extended(
                    onPressed: () {
                      AppUtils.deleteAllFavorite();
                    },
                    backgroundColor: ColorConstants.primaryColor,
                    label: const CustomText(label: 'Clear All'),
                    icon: const Icon(Icons.clear_all),
                  )
                : const SizedBox();
          }),
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: ValueListenableBuilder<Box<FavoriteModel>>(
              valueListenable: Boxes.getFavorites().listenable(),
              builder: (context, box, _) {
                final favorites = box.values.toList().cast<FavoriteModel>();
                return favorites.isNotEmpty
                    ? ListView.builder(
                        itemCount: favorites.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title:
                                CustomText(label: favorites[index].productName),
                            trailing: IconButton(
                                onPressed: () {
                                  AppUtils.deleteFavoriteAt(
                                      favoriteModel: favorites[index]);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Theme.of(context).iconTheme.color,
                                )),
                          );
                        })
                    : const NoFavorites();
              })),
    );
  }
}

class NoFavorites extends StatefulWidget {
  const NoFavorites({Key? key}) : super(key: key);

  @override
  State<NoFavorites> createState() => _NoFavoritesState();
}

class _NoFavoritesState extends State<NoFavorites> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CustomText(
        label: 'No Favorites',
        fontSize: 20, fontWeight: FontWeight.bold,
      ),
    );
  }
}
