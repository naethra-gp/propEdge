import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proequity/app_widgets/app_common/app_button_widget.dart';
import '../../app_storage/secure_storage.dart';

const Color profileInfoBackground = Color(0xFF3775FD);
const Color profileInfoCategoriesBackground = Color(0xFFF6F5F8);
const Color profileInfoAddress = Color(0xFF8D7AEE);
const Color profileInfoPrivacy = Color(0xFFF369B7);
const Color profileInfoGeneral = Color(0xFFFFC85B);
const Color profileInfoNotification = Color(0xFF5DD1D3);
const Color profileItemColor = Color(0xFFC4C5C9);

class PermissionList {
  String? title;
  String? description;
  IconData? icon;
  Color? iconColor;
  PermissionList({this.icon, this.title, this.iconColor, this.description});
}

List<PermissionList> profileMenuList = [
  PermissionList(
    title: 'Camera Permission',
    description: 'Your application must request',
    iconColor: profileInfoAddress,
    icon: LineAwesome.camera_retro_solid,
  ),
  PermissionList(
    title: 'Location Permission',
    description: 'Ensure your harvesting address',
    iconColor: profileInfoNotification,
    icon: LineAwesome.location_arrow_solid,
  ),
  PermissionList(
    title: 'Storage Permission',
    description: 'Ensure your harvesting address',
    iconColor: profileInfoPrivacy,
    icon: Icons.storage_outlined,
  ),
  // PermissionList(
  //   title: 'Media Permission',
  //   description: 'Ensure your harvesting address',
  //   iconColor: profileInfoGeneral,
  //   icon: LineAwesome.photo_video_solid,
  // ),
  // PermissionList(
  //   title: 'Notification Permission',
  //   description: 'Ensure your harvesting address',
  //   iconColor: profileInfoBackground,
  //   icon: LineAwesome.bell,
  // ),
];

class AskPermissionPage extends StatefulWidget {
  const AskPermissionPage({super.key});

  @override
  State<AskPermissionPage> createState() => _AskPermissionPageState();
}

class _AskPermissionPageState extends State<AskPermissionPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: permissionCard(),
        ),
      ),
    );
  }

  permissionCard() {
    return ListView(
      children: [
        const SizedBox(height: 90),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "We require following permissions",
            textAlign: TextAlign.left,
            style: GoogleFonts.archivoBlack().copyWith(fontSize: 30),
          ),
        ),
        const SizedBox(height: 20),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            for (var menu in profileMenuList) permissionMenuItem(menu),
          ],
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: AppButton(
            title: "Proceed",
            onPressed: () async {
              bool permitted = await tryPermission(Permission.storage) || await tryPermission(Permission.manageExternalStorage); // for android <13 and 13+
              await checkPermission(context);
              // await _checkAndRequestStoragePermission();
              // Navigator.pushNamed(context, 'mainPage');
            },
          ),
        ),
      ],
    );
  }

  permissionMenuItem(menu) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFD1DCFF),
                blurRadius: 5.0,
                spreadRadius: 2.0,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: menu.iconColor,
                      ),
                      child: Icon(
                        menu.icon,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            menu.title!,
                            style: GoogleFonts.poppins().copyWith(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,),
                          ),
                          Text(
                            menu.description.toString(),
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: profileItemColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _checkAndRequestStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;

    if (status.isGranted) {
    } else if (status.isDenied) {
      status = await Permission.storage.request();
      if (status.isGranted) {
      } else {
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
  tryPermission(Permission permission) async {
    var status = await permission.request();
    if (status.isGranted) {
      print('granted');
      return true;
    } else if (status.isDenied) {
      print('requesting permission');
      status = await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        print('newly granted');
        return true;
      } else {
        print('User denied ${permission.runtimeType} request'); // @fixme generalize
      }
    } else if (status.isPermanentlyDenied) {
      print('permanently denied');
    }
      return false;
  }

  checkPermission(BuildContext ctx) async {
    debugPrint("---->> Check Permission <<----");
    BoxStorage secureStorage = BoxStorage();
    await [
      Permission.location,
      Permission.camera,
      Permission.photos,
      Permission.mediaLibrary,
      Permission.notification,
      Permission.storage,
      Permission.manageExternalStorage,
    ].request();
    secureStorage.save("setPermission", true);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, "login", (route) => false);
  }
}
