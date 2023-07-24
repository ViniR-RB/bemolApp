import 'package:flutter/material.dart';

import '../../../core/app_color.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 19.0, right: 14),
      child: Container(
        decoration: const BoxDecoration(color: Color(0xFFF0F1F2)),
        child: TextField(
          decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                size: 28,
              ),
              fillColor: const Color(0xFFF0F1F2),
              prefixIconColor: AppColor.titleAppBarColor,
              label: const Text('Search Anything'),
              border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
        ),
      ),
    );
  }
}
