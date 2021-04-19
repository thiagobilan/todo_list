import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:todo_list/app/repositories/todo_repository.dart';

class NewTaskController extends ChangeNotifier {
  final formkey = GlobalKey<FormState>();
  final TodoRepository repository;
  static final DateFormat dateformat = DateFormat('dd/MM/yyyy');
  DateTime daySelected;
  TextEditingController nomeTaskController = TextEditingController();
  bool saved = false;
  bool loading = false;
  String error;

  NewTaskController({@required this.repository, String day})
      : daySelected = dateformat.parse(day);

  String get dayFormated => dateformat.format(daySelected);

  Future<void> save() async {
    try {
      if (formkey.currentState.validate()) {
        loading = true;
        saved = false;
        await repository.saveTodo(daySelected, nomeTaskController.text);
        saved = true;
        loading = false;
      }
    } catch (e) {
      error = 'Erro ao salvar';
    }
    notifyListeners();
  }

  
}
