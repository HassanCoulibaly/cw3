import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TaskListScreen(),
    );
  }
}

class Task {
  String name;
  bool isCompleted;
  String priority;

  Task({required this.name, this.isCompleted = false, required this.priority});
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  final List<Task> _tasks = [];
  String _selectedPriority = "Low";

  final Map<String, int> _priorityOrder = {"High": 1, "Medium": 2, "Low": 3};

  void _addTask() {
    if (_taskController.text.isEmpty) return;

    setState(() {
      _tasks.add(Task(name: _taskController.text, priority: _selectedPriority));
      _taskController.clear();
      _sortTasks();
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _sortTasks() {
    _tasks.sort((a, b) =>
        _priorityOrder[a.priority]!.compareTo(_priorityOrder[b.priority]!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Task Management App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              "This is the Task Management Application",
              style: TextStyle(color: Colors.cyan, fontSize: 35.0),
            ),
            SizedBox(
              width: 20,
              height: 20,
            ),
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Task',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: _selectedPriority,
                  items: ["Low", "Medium", "High"]
                      .map((priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPriority = value!;
                    });
                  },
                ),
                ElevatedButton.icon(
                  style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll<Color>(Colors.orange),
                  ),
                  onPressed: _addTask,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Task"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: _tasks[index].isCompleted,
                        onChanged: (_) => _toggleTaskCompletion(index),
                      ),
                      title: Text(_tasks[index].name),
                      subtitle: Text("Priority: ${_tasks[index].priority}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTask(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
