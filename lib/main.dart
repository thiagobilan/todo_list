import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list/app/database/database_adm_connection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DatabaseAdmConnection databaseAdmConnection = DatabaseAdmConnection();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(databaseAdmConnection);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(databaseAdmConnection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFFFF9129),
        buttonColor: Color(0xFFFF9129),
        textTheme: GoogleFonts.robotoTextTheme(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text(''),
          ),
          body: Container()),
    );
  }
}
