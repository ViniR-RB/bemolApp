import 'package:flutter/material.dart';

import '../../../core/app_color.dart';
import '../../../core/entitys/product.dart';

class CardProductFavorite extends StatelessWidget {
  final Product product;
  const CardProductFavorite({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 26.0, left: 18),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(children: [
              Container(
                width: 126,
                height: 121,
                padding: const EdgeInsets.only(left: 18),
                child: Image.network(
                  product.image,
                ),
              ),
              const SizedBox(
                width: 18,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.title,
                        maxLines: 3,
                        textWidthBasis: TextWidthBasis.parent,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColor.titleAppBarColor,
                            letterSpacing: 0.6)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  color: AppColor.titleAppBarColor
                                      .withOpacity(0.65),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '\$${product.price}',
                          style: TextStyle(
                              color: AppColor.moneyColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
