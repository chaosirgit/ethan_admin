import 'package:ethan_admin/middleware/LoginMiddleware.dart';
import 'package:ethan_admin/views/Layout.dart';
import 'package:ethan_admin/views/pages/Init.dart';
import 'package:ethan_admin/views/pages/Login.dart';
import 'package:get/get.dart';

final routes = [
  GetPage(name: "/init", page: () => Init()),
  GetPage(name: "/login", page: () => Login()),
  GetPage(name: "/", page: () => Layout(), middlewares: [LoginMiddleware(priority: 0)]),
  // GetPage(name: "/dashboard", page: () => DashBoard()),
  // GetPage(name: "/list", page: () => MyList()),
];