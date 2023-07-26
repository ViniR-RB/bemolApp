import 'package:bemol/app/modules/home/home_controller.dart';
import 'package:bemol/app/modules/home/widgets/card_product.dart';
import 'package:bemol/app/modules/home/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller;
  @override
  void initState() {
    super.initState();
    _controller = Modular.get<HomeController>();
    WidgetsBinding.instance.addPostFrameCallback(handleCallBack);
  }

  void handleCallBack(Duration timeStamp) {
    _controller.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
        ),
        actions: [
          IconButton(
              onPressed: () => Modular.to.pushNamed('/favoriteProducts'),
              icon: const Icon(
                Icons.favorite_outline,
              ))
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SearchTextField(),
          ValueListenableBuilder(
            valueListenable: _controller.notifier,
            builder: (context, value, child) {
              if (value is HomeGetAllProductsLoadedState) {
                return Expanded(
                  child: LayoutBuilder(
                    builder: (p0, size) {
                      return SizedBox(
                        width: size.maxWidth,
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          itemCount: value.products.length,
                          itemBuilder: (context, index) {
                            return CardProduct(
                              product: value.products[index],
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              } else if (value is HomeGetAllProductsLoadingState) {
                return LayoutBuilder(
                  builder: (p0, size) {
                    return SizedBox(
                        width: size.maxWidth,
                        height: size.maxWidth,
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ));
                  },
                );
              } else if (value is HomeGetAllProductsErrorState) {
                Modular.to.navigate('/error', arguments: value.message);
                return const SizedBox.shrink();
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
