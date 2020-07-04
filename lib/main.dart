
import 'package:flutter/material.dart';
import 'package:mytodo/Widget/taskInput.dart';
import 'package:mytodo/Widget/todo.dart';
import 'package:mytodo/Widget/done.dart';
import 'package:mytodo/Models/model.dart' as Model;
import 'package:mytodo/Db/dbHelper_wrapper.dart';
import 'package:mytodo/utils.dart';
import 'package:mytodo/Widget/popup.dart';

void main() => runApp(TodosApp());

class TodosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        backgroundColor: Color(0xfffff5eb),
      ),
      title: "Todo",
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String welcomeMsg;
  List<Model.Todo> todos;
  List<Model.Todo> dones;

  String selectedTabCategory = "Today";

  @override
  void initState() {
    super.initState();
    getTodosAndDones(selectedTabCategory);
    //welcomeMsg = Utils.getWelcomeMessage();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todo",
            style: TextStyle(
              fontSize: 20.0,
            ),),
          backgroundColor: Colors.blueGrey,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: FlatButton(
                    child: Text(
                      "Today",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    color: Colors.white,
                    textColor: Colors.blueGrey,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.redAccent,
                    onPressed: (){
                      selectedTabCategory='Today';
                      getTodosAndDones(selectedTabCategory);},
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: FlatButton(
                    child: Text(
                      "Tomorrow",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    color: Colors.white,
                    textColor: Colors.blueGrey,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.redAccent,
                    onPressed: (){
                      selectedTabCategory='Tomorrow';
                      getTodosAndDones(selectedTabCategory);},
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: FlatButton(
                    child: Text(
                      "Week",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    color: Colors.white,
                    textColor: Colors.blueGrey,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.redAccent,
                    onPressed: (){
                      selectedTabCategory = 'Week';
                      getTodosAndDones(selectedTabCategory);},
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: FlatButton(
                    child: Text(
                      "Month",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    color: Colors.white,
                    textColor: Colors.blueGrey,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.redAccent,
                    onPressed: (){
                      selectedTabCategory = 'Month';
                      getTodosAndDones(selectedTabCategory);},
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.blueGrey,
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              Utils.hideKeyboard(context);
            },
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.blueGrey,
                  floating: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        height: 0,
                                        child: Popup(
                                          getTodosAndDones: getTodosAndDones,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 2.0),
                                  child: TaskInput(
                                    onSubmitted: addTaskInTodo,
                                    categoryName: selectedTabCategory,
                                  ), // Add Todos
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  expandedHeight: 100,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      switch (index) {
                        case 0:
                          return TodoWidget(
                            todos: todos,
                            onTap: markTodoAsDone,
                            onDeleteTask: deleteTask,
                          ); // Active todos
                        case 1:
                          return SizedBox(
                            height: 30,
                          );
                        case 2:
                          return Done(
                            dones: dones,
                            onTap: markDoneAsTodo,
                            onDeleteTask: deleteTask,
                          );
                        default:
                          return FlatButton(
                            color: Colors.white,
                            textColor: Colors.redAccent,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.black,
                            padding: EdgeInsets.all(8.0),
                            splashColor: Colors.redAccent,
                            child: Text("Uygulama Hakkında"),
                            onPressed: () {
                              return showDialog<void>(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text("'Todo Eklemek için': Add Todo kutusuna yazıp ekleyebilirsiniz,"
                                              "Silmek için': sola doğru kaydırmanız yeterli,"
                                        "İş yapıldıysa 'Done kutusuna eklemek için': Todo kutusunda biten işin üstene basın."),
                                  );
                                }
                              );
                            },
                          );
                      }
                    },
                    childCount: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void getTodosAndDones(String selectedCategory) async {
    final _todos = await DBWrapper.sharedInstance.getTodos(selectedCategory);
    final _dones = await DBWrapper.sharedInstance.getDones(selectedCategory);

    setState(() {
      todos = _todos;
      dones = _dones;
    });
  }

  void addTaskInTodo({@required TextEditingController controller}) {
    final inputText = controller.text.trim();

    if (inputText.length > 0) {
      // Add todos
      Model.Todo todo = Model.Todo(
          title: inputText,
          created: DateTime.now(),
          updated: DateTime.now(),
          status: Model.TodoStatus.active.index,
          category:selectedTabCategory
      );

      DBWrapper.sharedInstance.addTodo(todo);
      getTodosAndDones(selectedTabCategory);
    } else {
      Utils.hideKeyboard(context);
    }

    controller.text = '';
  }

  void markTodoAsDone({@required int pos}) {
    DBWrapper.sharedInstance.markTodoAsDone(todos[pos]);
    getTodosAndDones(selectedTabCategory);
  }

  void markDoneAsTodo({@required int pos}) {
    DBWrapper.sharedInstance.markDoneAsTodo(dones[pos]);
    getTodosAndDones(selectedTabCategory);
  }

  void deleteTask({@required Model.Todo todo}) {
    DBWrapper.sharedInstance.deleteTodo(todo);
    getTodosAndDones(selectedTabCategory);
  }
}
