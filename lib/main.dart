import 'package:app/api/firebase_api.dart';
import 'package:app/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  // dx0xBkZySWiIbSdE41ZXWP:APA91bHJuuXbMJO-B5dg4G0R5pNYOwDpn5CqZwWWuG1BxmwwupQsQQ_ieG_kT3tZqURRleKZEPDRFOYQNz3Ddt8QyGTy_1QTWaaX3EtjDFAgdiCMOERy8w1xCeE1qj4thzTD9I3Q70pG

  bool granted = await Permission.location.request().isGranted;
  if (granted) {
    runApp(
        MaterialApp(
          theme: ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: Colors.white10)),
          home: HomeView(),
        ));
  } else {
    runApp(
      const MaterialApp(
        home: SafeArea(
          child: Center(
            child: Text("Надо было доступ дать"),
          ),
        ),
      )
    );
  }
}