import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/app_color.dart';

class ErrorPage extends StatelessWidget {
  final String message;
  const ErrorPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              child: Image.asset('assets/images/errorimage.png'),
            ),
            Text(message,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColor.titleAppBarColor.withOpacity(0.65)))
          ]),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: TextButton(
              onPressed: () => Modular.to.navigate('/'),
              child: Text('Go Home',
                  style: TextStyle(
                      fontSize: 16, color: AppColor.blueColorButton))),
        )
      ],
    ));
  }
}
