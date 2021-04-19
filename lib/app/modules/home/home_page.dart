import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/models/todo_model.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/new_task/new_task_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, __) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Atividades',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            backgroundColor: Colors.white,
          ),
          bottomNavigationBar: FFNavigationBar(
            selectedIndex: controller.selectedTab,
            onSelectTab: (index) =>
                controller.changeSelectedTab(context, index),
            theme: FFNavigationBarTheme(
              itemWidth: 60,
              barHeight: 70,
              barBackgroundColor: Theme.of(context).primaryColor,
              unselectedItemIconColor: Colors.white,
              unselectedItemLabelColor: Colors.white,
              selectedItemBorderColor: Colors.white,
              selectedItemIconColor: Colors.white,
              selectedItemBackgroundColor: Theme.of(context).primaryColor,
              selectedItemLabelColor: Colors.black,
            ),
            items: [
              FFNavigationBarItem(
                iconData: Icons.check_circle,
                label: 'Finalizados',
              ),
              FFNavigationBarItem(
                iconData: Icons.view_week,
                label: 'Semanal',
              ),
              FFNavigationBarItem(
                iconData: Icons.calendar_today,
                label: 'Selecionar Data',
              ),
            ],
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: controller.listTodos?.keys?.length ?? 0,
              itemBuilder: (context, index) {
                var dateFormat = DateFormat('dd/MM/yyyy');
                var listTodos = controller.listTodos;
                var dayKey = listTodos.keys.elementAt(index);
                var day = dayKey;
                var todos = listTodos[dayKey];
                var today = DateTime.now();

                if (todos.isEmpty && controller.selectedTab == 0) {
                  return SizedBox.shrink();
                }

                if (dayKey == dateFormat.format(today)) {
                  day = 'Hoje';
                } else if (dayKey ==
                    dateFormat.format(
                      today.add(
                        Duration(days: 1),
                      ),
                    )) {
                  day = 'Amanhã';
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 20,
                        left: 20,
                        top: 20,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () async {
                              await Navigator.of(context).pushNamed(
                                  NewTaskPage.routeName,
                                  arguments: dayKey);
                              controller.update();
                            },
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      itemCount: todos.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var todo = todos[index];
                        return Dismissible(
                          onDismissed: (direction) => controller.deletar(todo),
                          direction: DismissDirection.startToEnd,
                          child: ListTile(
                            leading: Checkbox(
                                value: todo.finalizado,
                                onChanged: (value) =>
                                    controller.checkedOrUncheck(todo),
                                activeColor: Theme.of(context).primaryColor),
                            title: Text(
                              todo.descricao,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                decoration: todo.finalizado
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: Text(
                              '${todo.dataHora.hour.toString().padLeft(2, "0")}:${todo.dataHora.minute.toString().padLeft(2, "0")}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                decoration: todo.finalizado
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                          background: Container(
                            color: Colors.red,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          key: ValueKey<TodoModel>(todo),
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Excluir"),
                                  content: Text(
                                      "Deseja excluir a task ${todo.descricao}"),
                                  actions: [
                                    FlatButton(
                                        child: Text("Cancelar"),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        }),
                                    FlatButton(
                                      child: Text("Excluir"),
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  //configura o AlertDialog

  //exibe o diálogo

}
