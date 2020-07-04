
import 'package:mytodo/Models/model.dart';
import 'package:mytodo/Db/dbHelper.dart';

class DBWrapper {
  static final DBWrapper sharedInstance = DBWrapper._();

  DBWrapper._();

  Future<List<Todo>> getTodos(String category) async {
    List list = await DB.sharedInstance.retrieveTodos(status: TodoStatus.active,category: category);
    return list;
  }

  Future<List<Todo>> getDones(String category) async {
    List list = await DB.sharedInstance.retrieveTodos(status: TodoStatus.done,category: category);
    return list;
  }

  void addTodo(Todo todo) async {
    await DB.sharedInstance.createTodo(todo);
  }

  void markTodoAsDone(Todo todo) async {
    todo.status = TodoStatus.done.index;
    todo.updated = DateTime.now();
    await DB.sharedInstance.updateTodo(todo);
  }

  void markDoneAsTodo(Todo todo) async {
    todo.status = TodoStatus.active.index;
    todo.updated = DateTime.now();
    await DB.sharedInstance.updateTodo(todo);
  }

  void deleteTodo(Todo todo) async {
    await DB.sharedInstance.deleteTodo(todo);
  }

  void deleteAllDoneTodos() async {
    await DB.sharedInstance.deleteAllTodos();
  }
}
