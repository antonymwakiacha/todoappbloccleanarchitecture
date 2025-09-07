/*
TO DO VIEW: responsible for UI

-use BlocBuilder

*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoappbloccleanarchitecture/domain/models/todo.dart';
import 'package:todoappbloccleanarchitecture/presentation/todo_cubit.dart';

class TodoView extends StatelessWidget {
  const TodoView({super.key});

  // show dialog box for user to type
  void _showAddTodoBox(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: textController),
        actions: [
          //cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('cancel'),
          ),

          //add button
          TextButton(
            onPressed: () {
              todoCubit.addTodo(textController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  //BUILD UI
  @override
  Widget build(BuildContext context) {

    //todo cubit
    final todoCubit = context.read<TodoCubit>();

    //SCAFFOLD
    return Scaffold(
      //FAB
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddTodoBox(context),
      ),

      //BLOC BUILDER
      body: BlocBuilder<TodoCubit, List<Todo>>(
        builder: (context, todos) {
          //List View
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              //get individual todo from todos list
              final todo = todos[index];

              //list Tile UI
              return ListTile(
                //text
                title: Text(todo.text),

                //check box
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (value) => todoCubit.toggleCompletion(todo),
                ),

                //delete button
                trailing: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () => todoCubit.deleteTodo(todo),
                ),
                
              );
            },
          );
        },
      ),
    );
  }
}
