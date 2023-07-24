import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ErrorPage extends StatelessWidget {
  final String message;
  const ErrorPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Center(
          child: Column(children: [
            Container(
              child: Image.asset('assets/images/errorimage.png'),
            ),
            Text(message)
          ]),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: TextButton(
              onPressed: () => Modular.to.navigate('/home'),
              child: const Text('Go Home')),
        )
      ],
    ));
  }
}
