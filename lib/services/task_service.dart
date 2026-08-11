import '../repository/repository.dart';
import '../models/task.dart';
import '../exceptions/exceptions.dart';

class TaskService {
  final TaskRepository _repository;
  TaskService(this._repository);

  Future<List<Task>> listTasks({String sortBy = 'id'}) async {
    var tasks = await _repository.getAll();

    if (sortBy == 'priority') {
      const order = {'high': 0, 'medium': 1, 'low': 2};
      tasks.sort((a, b) => order[a.priority]!.compareTo(order[b.priority]!));
    } else if (sortBy == 'date') {
      tasks.sort((a, b) => (a.dueDate?? DateTime(2100)).compareTo(b.dueDate?? DateTime(2100)));
    } else {
      tasks.sort((a, b) => a.id.compareTo(b.id));
    }
    return tasks;
  }

  Future<void> addTask(String title, String priority, String? dueDateStr) async {
    if (!['low', 'medium', 'high'].contains(priority)) {
      throw InvalidPriorityException(priority);
    }

    final tasks = await _repository.getAll();
    final newId = tasks.isEmpty? 1 : tasks.map((e) => e.id).reduce((a, b) => a > b? a : b) + 1;
    final dueDate = dueDateStr!= null? DateTime.tryParse(dueDateStr) : null;

    Task newTask;
    if (priority == 'high' && dueDate!= null) {
      newTask = UrgentTask(id: newId, title: title, dueDate: dueDate);
    } else {
      newTask = NormalTask(id: newId, title: title, priority: priority, dueDate: dueDate);
    }
    await _repository.add(newTask);
  }

  Future<void> completeTask(int id) async {
    final tasks = await _repository.getAll();
    final task = tasks.firstWhere((t) => t.id == id, orElse: () => throw TaskNotFoundException(id));
    task.markCompleted();
    await _repository.update(task);
  }

  Future<void> deleteTask(int id) async {
    await _repository.delete(id);
  }
}