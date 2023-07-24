import 'package:bemol/app/core/app_color.dart';
import 'package:bemol/app/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../widgets/card_product_favorite.dart';
import '../widgets/search_field.dart';

class FavoriteProductsPage extends StatefulWidget {
  const FavoriteProductsPage({super.key});

  @override
  State<FavoriteProductsPage> createState() => _FavoriteProductsPageState();
}

class _FavoriteProductsPageState extends State<FavoriteProductsPage> {
  late final HomeController _controller;
  @override
  void initState() {
    super.initState();
    _controller = Modular.get<HomeController>();
    _controller.getAllFavoritesProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          ValueListenableBuilder(
            valueListenable: _controller.productsFavorite,
            builder: (context, value, child) {
              return value.isNotEmpty
                  ? Expanded(
                      child: LayoutBuilder(
                        builder: (p0, size) {
                          return SizedBox(
                            width: size.maxWidth,
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                              itemCount: value.length,
                              itemBuilder: (context, index) {
                                return CardProductFavorite(
                                  product: value[index],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Column(children: [
                        SizedBox(
                          width: 160,
                          height: 160,
                          child: Image.asset('assets/images/emptylist.png'),
                        ),
                        Text(
                          'The list is empty',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color:
                                  AppColor.titleAppBarColor.withOpacity(0.65)),
                        )
                      ]),
                    );
            },
            child: const SearchTextField(),
          )
        ],
      ),
    );
  }
}
