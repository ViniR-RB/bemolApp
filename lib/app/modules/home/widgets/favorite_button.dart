import 'package:bemol/app/core/app_color.dart';
import 'package:bemol/app/core/models/product_model.dart';
import 'package:bemol/app/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/entitys/product.dart';
import '../../../core/snackbar_manager/snackbar_manager.dart';

class FavoriteButton extends StatefulWidget {
  final Product product;
  const FavoriteButton({super.key, required this.product});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late final HomeController _controller;
  late final ValueNotifier<bool> _isFavorite;
  @override
  void initState() {
    super.initState();
    _controller = Modular.get<HomeController>();
    _isFavorite = _controller.getProductFavoriteNotifier(widget.product);
    checkIsFavoriteIcon();
  }

  Future<void> addOrRemoveProductInShared() async {
    await _controller.addOrRemoveFavoriteProduct(
      ProductModel.productFromModel(widget.product),
    );
  }

  Future<void> checkIsFavoriteIcon() async {
    bool responseFavorite = await _controller
        .checkExistingProduct(ProductModel.productFromModel(widget.product));
    _isFavorite.value = responseFavorite;
  }

  showSnackActionInButton() {
    if (_isFavorite.value == true) {
      SnackBarManager.show(
          message: 'Adicionado com Sucesso',
          icon: Icons.add_circle,
          iconColor: AppColor.dailyPlusGreenColor);
    } else {
      SnackBarManager.show(
          message: 'Removido com Sucesso',
          icon: Icons.remove_circle,
          iconColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _controller.getProductFavoriteNotifier(widget.product),
      builder: (context, value, child) {
        return IconButton(
            icon: _isFavorite.value == true
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_border,
                  ),
            onPressed: () async {
              await addOrRemoveProductInShared();
              await checkIsFavoriteIcon();
              showSnackActionInButton();
            });
      },
    );
  }
}
