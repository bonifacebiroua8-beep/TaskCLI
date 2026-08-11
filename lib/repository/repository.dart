import 'dart:convert';
import 'dart:io';
import '../models/task.dart';
import '../exceptions/exceptions.dart';

// Générique
abstract class Repository<T extends Identifiable> {
  Future<List<T>> getAll();
  Future<void> add(T item);
  Future<void> update(T item);
  Future<void> delete(int id);
}

class TaskRepository implements Repository<Task> {
  final String filePath;
  TaskRepository(this.filePath);

  Future<File> _getFile() async => File(filePath);

  @override
  Future<List<Task>> getAll() async {
    final file = await _getFile();
    if (!await file.exists()) return [];
    final content = await file.readAsString();
    if (content.isEmpty) return [];
    final List jsonList = jsonDecode(content);
    return jsonList.map((e) => taskFromJson(e)).toList();
  }

  Future<void> _saveAll(List<Task> tasks) async {
    final file = await _getFile();
    final jsonList = tasks.map((e) => e.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  @override
  Future<void> add(Task task) async {
    final tasks = await getAll();
    tasks.add(task);
    await _saveAll(tasks);
  }

  @override
  Future<void> update(Task task) async {
    final tasks = await getAll();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index == -1) throw TaskNotFoundException(task.id);
    tasks[index] = task;
    await _saveAll(tasks);
  }

  @override
  Future<void> delete(int id) async {
    final tasks = await getAll();
    final initialLength = tasks.length;
    tasks.removeWhere((t) => t.id == id);
    if (tasks.length == initialLength) throw TaskNotFoundException(id);
    await _saveAll(tasks);
  }
}