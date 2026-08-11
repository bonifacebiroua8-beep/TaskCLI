import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import 'package:task_cli/repository/repository.dart';
import 'package:task_cli/services/task_service.dart';

void main(List<String> arguments) async {
  final filePath = p.join(Directory.current.path, 'tasks.json');
  final repo = TaskRepository(filePath);
  final service = TaskService(repo);

  final parser = ArgParser()
   ..addCommand('add')
   ..addCommand('list')
   ..addCommand('done')
   ..addCommand('delete');

  parser.commands['add']!
   ..addOption('title', abbr: 't', mandatory: true)
   ..addOption('priority', abbr: 'p', defaultsTo: 'medium')
   ..addOption('due', abbr: 'd');

  parser.commands['list']!
   ..addOption('sort', abbr: 's', defaultsTo: 'id');

  parser.commands['done']!.addOption('id', abbr: 'i', mandatory: true);
  parser.commands['delete']!.addOption('id', abbr: 'i', mandatory: true);

  try {
    final results = parser.parse(arguments);
    final command = results.command;
    if (command == null) {
      print('Usage: dart run bin/main.dart <command> [arguments]');
      print('Commandes: add, list, done, delete');
      return;
    }

    if (command.name == 'add') {
      await service.addTask(command['title'], command['priority'], command['due']);
      print('Tâche ajoutée avec succès');

    } else if (command.name == 'list') {
      final tasks = await service.listTasks(sortBy: command['sort']);
      if (tasks.isEmpty) {
        print('Aucune tâche.');
      } else {
        tasks.forEach(print);
      }

    } else if (command.name == 'done') {
      final id = int.parse(command['id']);
      await service.completeTask(id);
      print('Tâche $id marquée comme terminée');

    } else if (command.name == 'delete') {
      final id = int.parse(command['id']);
      await service.deleteTask(id);
      print('Tâche $id supprimée');
    }
  } catch (e) {
    print('Erreur: $e');
    exit(1);
  }
}