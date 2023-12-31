import 'package:bemol/app/core/snackbar_manager/snackbar_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/app_color.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Application Name',
      scaffoldMessengerKey: SnackBarManager.snackKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: AppColor.scaffoldBackgroundColor,
          appBarTheme: AppBarTheme(
              color: AppColor.scaffoldBackgroundColor,
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: 0,
              titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColor.titleAppBarColor)),
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}
