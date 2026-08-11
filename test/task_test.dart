import 'dart:io';
import 'package:test/test.dart';
import 'package:task_cli/models/task.dart';
import 'package:task_cli/repository/repository.dart';
import 'package:task_cli/services/task_service.dart';
import 'package:task_cli/exceptions/exceptions.dart';

void main() {
  late TaskService service;
  final testFile = 'test_tasks.json';

  setUp(() async {
    final repo = TaskRepository(testFile);
    service = TaskService(repo);
    final file = File(testFile);
    if (await file.exists()) await file.delete();
  });

  tearDown(() async {
    final file = File(testFile);
    if (await file.exists()) await file.delete();
  });

  test('Ajouter une tâche NormalTask', () async {
    await service.addTask('Apprendre Dart', 'medium', null);
    final tasks = await service.listTasks();
    expect(tasks.length, 1);
    expect(tasks.first.title, 'Apprendre Dart');
    expect(tasks.first.priority, 'medium');
  });

  test('Ajouter une tâche UrgentTask si high + date', () async {
    await service.addTask('Projet urgent', 'high', '2026-08-30');
    final tasks = await service.listTasks();
    expect(tasks.first, isA<UrgentTask>());
  });

  test('Marquer une tâche comme terminée', () async {
    await service.addTask('Test', 'low', null);
    await service.completeTask(1);
    expect((await service.listTasks()).first.isCompleted, true);
  });

  test('Supprimer une tâche', () async {
    await service.addTask('Test', 'low', null);
    await service.deleteTask(1);
    expect((await service.listTasks()).length, 0);
  });

  test('Lancer TaskNotFoundException si id inexistant', () async {
    expect(() => service.deleteTask(99), throwsA(isA<TaskNotFoundException>()));
  });
}