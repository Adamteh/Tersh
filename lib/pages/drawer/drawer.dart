import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main.dart';

import '../settings/settings.dart';

import '../main_pages/auth.dart';
import '../main_pages/page_detail/timer.dart';
import '../main_pages/barcode_qrcode.dart/barcode_scanner.dart';
import '../../main.dart';

class TershDrawer {
  int selectedIndex = 0;

  drawer(homeActive, productActive, accommodationActive, jobActive, eventActive,
      darkMode, changeDarkMode) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      model.fetchAgent();
      model.fetchAgents();
      var profileImage;
      if (model.userPhoto != null) {
        profileImage = NetworkImage(model.userPhoto.userPhotoUrl);
      } else {
        profileImage = AssetImage('assets/person-placeholder-portrait.png');
      }

      return Drawer(
        child: InkWell(
          splashColor: MyAppState.darkmode == false
              ? Colors.black
              : Colors.white.withOpacity(.8),
          onLongPress: () {
            //change darkMode when drawer is long pressed
            changeDarkMode();
          },
          child: ListView(
            children: <Widget>[
              GestureDetector(
                child: UserAccountsDrawerHeader(
                  accountName:
                      Text(model.iUser != null ? model.iUser.userName : ''),
                  accountEmail: Text(model.user.email),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: profileImage,
                  ),
                  otherAccountsPictures: <Widget>[Icon(Icons.settings)],
                ),
                onTap: () {
                  Navigator.pop(context); // close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsPage(model.agent)),
                  );
                },
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(
                  Icons.home,
                  size: 26,
                ),
                title: Text(
                  'All',
                ),
                onTap: () {
                  homeActive();
                  selectedIndex = 0;
                  Navigator.pop(context); // close the drawer
                },
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(
                  Icons.shopping_basket,
                  size: 26,
                ),
                title: Text(
                  'Products',
                ),
                onTap: () {
                  productActive();
                  selectedIndex = 0;
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(
                  Icons.hotel,
                  size: 26,
                ),
                title: Text(
                  'Accomodation',
                ),
                onTap: () {
                  accommodationActive();
                  selectedIndex = 0;
                  Navigator.pop(context); // close the drawer
                },
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(
                  Icons.work,
                  size: 26,
                ),
                title: Text(
                  'Internship & Jobs',
                ),
                onTap: () {
                  jobActive();
                  selectedIndex = 0;
                  Navigator.pop(context); // close the drawer
                },
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(
                  Icons.event,
                  size: 26,
                ),
                title: Text(
                  'Events',
                ),
                onTap: () {
                  eventActive();
                  selectedIndex = 0;
                  Navigator.pop(context); // close the drawer
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.timer,
                  size: 26,
                ),
                title: Text(
                  'Timer',
                ),
                onTap: () {
                  Navigator.pop(context); // close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Timer()),
                  );
                },
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(
                  Icons.scanner,
                  size: 26,
                ),
                title: Text(
                  'BarCode Scanner',
                ),
                onTap: () {
                  Navigator.pop(context); // close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BarcodeScannerPage()),
                  );
                },
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  size: 26,
                ),
                title: Text(
                  'Logout',
                ),
                onTap: () {
                  model.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AuthPage()),
                  );
                },
              ),
              Divider(),
              darkMode(),
            ],
          ),
        ),
      );
    });
  }
}
