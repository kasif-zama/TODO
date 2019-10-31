// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './locale/local.dart';
import './models/itemModal.dart';

// Code written in Dart starts exectuting from the main function. runApp is part of
// Flutter, and requires the component which will be our app's container. In Flutter,
// every component is known as a "widget".
void main() => runApp(MaterialApp(localizationsDelegates: [
      const AppLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ], supportedLocales: [
      const Locale('en', ''),
      const Locale('hi', ''),
    ], 
    
    
    debugShowCheckedModeBanner: false, home: TodoApp()));

// Every component in Flutter is a widget, even the whole app itself
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: ValueKey('enterItemName'),
      appBar:
          AppBar(title: Text(AppLocalizations.of(context).getval("apptitle"))),
       body: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _todoItems = [];

  void _addTodoItem(String task) {
    // Only add the task if the user actually entered something
    if (task.length > 0) {
      // Putting our code inside "setState" tells the app that our state has changed, and
      // it will automatically re-render the list
      setState(() => _todoItems.add(task));
    }
  }

  void _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
  }

  void _promptRemoveTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Mark "${_todoItems[index]}" as done?'),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('CANCEL'),
                    // The alert is actually part of the navigation stack, so to close it, we
                    // need to pop it.
                    onPressed: () => Navigator.of(context).pop()),
                 FlatButton(
                    child: new Text('MARK AS DONE'),
                    onPressed: () {
                      _removeTodoItem(index);
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  // Build the whole list of todo items
  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of todo items we have. So, we need to check the index is OK.
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index], index);
        }
        return null;
      },
    );
  }

  // Build a single todo item
  Widget _buildTodoItem(String todoText, int index) {
    return new ListTile(
        title: new Text(todoText), onTap: () => _promptRemoveTodoItem(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
          key: ValueKey("add some item"),
          onPressed: _pushAddTodoScreen,
          tooltip: 'Add task',
          child: new Icon(Icons.add)),
    );
  }

  void _pushAddTodoScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(
        // MaterialPageRoute will automatically animate the screen entry, as well as adding
        // a back button to close it
        new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(title: new Text(
           // 'Add a new task'
            AppLocalizations.of(context).getval('secondScreenTitle')
            
            
            )),
          key: ValueKey("addSomeTask"),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addTodoItem(val);
              Navigator.pop(context); // Close the add todo screen
            },
            decoration: new InputDecoration(
                hintText: 
                 
          
            AppLocalizations.of(context).getval('secondScreenItem'),
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));

// Much like _addTodoItem, this modifies the array of todo strings and
// notifies the app that the state has changed by using setState
    void _removeTodoItem(int index) {
      setState(() => _todoItems.removeAt(index));
    }

// Show an alert dialog asking the user to confirm that the task is done
    void _promptRemoveTodoItem(int index) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
                title: new Text('Mark "${_todoItems[index]}" as done?'),
                actions: <Widget>[
                  new FlatButton(
                      child: new Text('CANCEL'),
                      onPressed: () => Navigator.of(context).pop()),
                  new FlatButton(
                      child: new Text('MARK AS DONE'),
                      onPressed: () {
                        _removeTodoItem(index);
                        Navigator.of(context).pop();
                      })
                ]);
          });
    }

    Widget _buildTodoList() {
      return new ListView.builder(
        itemBuilder: (context, index) {
          if (index < _todoItems.length) {
            _buildTodoItem(_todoItems[index], index);
          }
          return null;
        },
      );
    }

    Widget _buildTodo(String todoText, int index) {
      return ListTile(
          title: new Text(todoText), onTap: () => _promptRemoveTodoItem(index));
    }
  }
}
