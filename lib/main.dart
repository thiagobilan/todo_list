import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/database/connection.dart';
import 'package:todo_list/app/database/database_adm_connection.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/home/home_page.dart';
import 'package:todo_list/app/modules/new_task/new_task_controller.dart';
import 'package:todo_list/app/modules/new_task/new_task_page.dart';
import 'package:todo_list/app/repositories/todo_repository.dart';

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
    Connection().instace;
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
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => TodoRepository(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color(0xFFFF9129),
          buttonColor: Color(0xFFFF9129),
          textTheme: GoogleFonts.robotoTextTheme(),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          NewTaskPage.routeName: (_) => ChangeNotifierProvider(
                create: (context) {
                  var day = ModalRoute.of(_).settings.arguments;

                  return NewTaskController(
                      repository: context.read<TodoRepository>(), day: day);
                },
                child: NewTaskPage(),
              ),
        },
        home: ChangeNotifierProvider(
          create: (context) => HomeController(
            repository: context.read<TodoRepository>(),
          ),
          child: HomePage(),
        ),
      ),
    );
  }
}
