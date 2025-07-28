import 'package:flutter/material.dart';

import '../app_pages/index.dart';

class AppRoute {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) {
      switch (settings.name) {
        case "splash":
          return const SplashScreen();
        case "permission":
          return const AppPermission();
        case "login":
          return const LoginPage();
        case "mainPage":
          int index = settings.arguments as int;
          return MainPage(index: index);
          case "site_visit_form":
            String id = settings.arguments as String;
            return SiteVisitFormPage(propId: id);
        case "addReimbursement":
          Map args = settings.arguments as Map;
          return AddReimbursement(args: args);
        case "view_reimbursement_details":
          List id = settings.arguments as List;
          return ViewReimbursementDetails(id: id);
        case "local_view_details":
          List list = settings.arguments as List;
          return LocalViewDetails(list: list);
        case "settings":
          return const Settings();
        case "view_reimbursement":
          return const ViewReimbursement();
          case "view_site_visit_form_data":
            String id = settings.arguments as String;
            return ViewSiteVisitFormData(propId: id);
      }
      return const LoginPage();
    });
  }
}
