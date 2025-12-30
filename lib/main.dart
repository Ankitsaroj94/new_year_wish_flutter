import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_year_wish_flutter/app/modules/splash/views/splash_view.dart';
import 'package:new_year_wish_flutter/app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GetMaterialApp(
      unknownRoute: GetPage(name: '/splash', page: () => const SplashView()),
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,

      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      supportedLocales: const [Locale('en', 'US')],
    ),
  );
}
