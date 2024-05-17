import 'package:flutter/material.dart';
import 'package:proequity/app_pages/site_visit_form/site_visit_form.dart';

import '../app_pages/index.dart';
import '../app_pages/site_visit_form/view_site_visit_form/view_site_visit_form.dart';

class AppRoute {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) {
      switch (settings.name) {
        case "splash":
          return const SplashScreen();
        case "login":
          return const LoginPage();
        case "mainPage":
          int index = settings.arguments as int;
          return MainPage(index: index);
        case "askPermission":
          return const AskPermissionPage();
        case "siteVisitForm":
          String id = settings.arguments as String;
          return SiteVisitForm(propId: id);
        case "reimbursementForm":
          Map args = settings.arguments as Map;
          return ReimbursementForm(args: args);
        case "viewReimbursement":
          String id = settings.arguments as String;
          return ViewReimbursement(id: id);
        case "settings":
          return const SettingsPage();
        case "onlineReimbursement":
          return const OnlineReimbursementPage();
        case "ViewSiteVisit":
          String id = settings.arguments as String;
          return ViewSiteVisitForm(propId: id);
          // return ViewSiteVisit(id: id);
      }
      return const DashboardPage();
    });
  }
}
