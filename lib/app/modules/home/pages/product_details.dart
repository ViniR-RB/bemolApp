import 'package:bemol/app/core/utils/string_extensions.dart';
import 'package:bemol/app/modules/home/widgets/favorite_button.dart';
import 'package:flutter/material.dart';

import '../../../core/app_color.dart';
import '../../../core/entitys/product.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [FavoriteButton(product: product)],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 45.0, right: 45, top: 9, bottom: 18),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 309,
              child: Image(
                image: NetworkImage(product.image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 2,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 20),
                ),
                const SizedBox(
                  height: 22,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star_sharp,
                          color: AppColor.starColor,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${product.rate} (${product.count} reviews)',
                          style: TextStyle(
                              color:
                                  AppColor.titleAppBarColor.withOpacity(0.65),
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Text(
                      '\$${product.price}',
                      style: TextStyle(
                          color: AppColor.dailyPlusGreenColor,
                          fontWeight: FontWeight.w600,
                          height: 1,
                          fontSize: 29),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 44,
                ),
                Row(
                  children: [
                    const Icon(Icons.category),
                    const SizedBox(
                      width: 13,
                    ),
                    Text(product.category.capitalize(),
                        style: TextStyle(
                            color: AppColor.descriptionColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500))
                  ],
                ),
                const SizedBox(
                  height: 33,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.category,
                    ),
                    const SizedBox(
                        width: 13), // Espaçamento entre o ícone e o texto
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            product.description.capitalize(),
                            maxLines: 4,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: AppColor.descriptionColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
