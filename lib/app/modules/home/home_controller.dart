import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import 'package:todo_list/app/models/todo_model.dart';

import 'package:todo_list/app/repositories/todo_repository.dart';

class HomeController extends ChangeNotifier {
  var dateFormat = DateFormat('dd/MM/yyyy');
  DateTime startFilter;
  DateTime endsFilter;
  DateTime daySelected;
  Map<String, List<TodoModel>> listTodos;
  var selectedTab = 1;
  final TodoRepository repository;
  HomeController({
    @required this.repository,
  }) {
    findAllForWeek();
  }
  Future<void> changeSelectedTab(BuildContext context, int index) async {
    selectedTab = index;
    switch (index) {
      case 0:
        filterFinalized();
        break;
      case 1:
        findAllForWeek();
        break;
      case 2:
        var day = await showDatePicker(
          context: context,
          initialDate: daySelected,
          firstDate: DateTime.now().subtract(
            Duration(days: (365 * 3)),
          ),
          lastDate: DateTime.now().add(
            Duration(days: (365 * 10)),
          ),
        );

        if (day != null) {
          daySelected = day;
          findTodoBySelectedDay();
        }
        break;
    }
    notifyListeners();
  }

  Future<void> findAllForWeek() async {
    daySelected = DateTime.now();

    startFilter = DateTime.now();
    if (startFilter.weekday != DateTime.monday) {
      startFilter = startFilter.subtract(
        Duration(days: startFilter.weekday - 1),
      );
    }
    endsFilter = startFilter.add(Duration(days: 16));

    var todos = await repository.findByPeriod(startFilter, endsFilter);

    if (todos.isEmpty) {
      listTodos = {dateFormat.format(DateTime.now()): []};
    } else {
      listTodos = groupBy(
        todos,
        (TodoModel todo) => dateFormat.format(todo.dataHora),
      );
    }
    notifyListeners();
  }

  void checkedOrUncheck(TodoModel todo) {
    todo.finalizado = !todo.finalizado;
    this.notifyListeners();
    repository.checkOrUncheckTodo(todo);
  }

  void filterFinalized() {
    listTodos = listTodos.map((key, value) {
      var todosFinalized =
          value.where((element) => element.finalizado == true).toList();
      return MapEntry(key, todosFinalized);
    });
    notifyListeners();
  }

  Future<void> findTodoBySelectedDay() async {
    var todos = await repository.findByPeriod(daySelected, daySelected);
    if (todos.isEmpty) {
      listTodos = {dateFormat.format(daySelected): []};
    } else {
      listTodos = groupBy(
        todos,
        (TodoModel todo) => dateFormat.format(todo.dataHora),
      );
    }
    notifyListeners();
  }

  void update() {
    if (selectedTab == 1) {
      this.findAllForWeek();
    } else if (selectedTab == 2) {
      this.findTodoBySelectedDay();
    }
  }

  void deletar(TodoModel todo) {
    repository.removeTodo(todo);
    findAllForWeek();
  }
}
