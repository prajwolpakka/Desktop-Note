import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'Providers/CreditProvider.dart';
import 'Providers/ThemeProvider.dart';
import 'Screens/NoteScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CreditProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desktop Note',
      debugShowCheckedModeBanner: false,
      home: NoteScreen(),
      theme: Provider.of<ThemeProvider>(context).darkTheme
          ? ThemeData.dark().copyWith(
              appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              textTheme: TextTheme(headline6: TextStyle(color: Colors.white, fontSize: 24)),
            ))
          : ThemeData.light().copyWith(
              appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Colors.black),
              textTheme: TextTheme(headline6: TextStyle(color: Colors.black, fontSize: 24)),
            )),
    );
  }
}
