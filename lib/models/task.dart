import 'dart:convert';

// Interface
abstract class Identifiable {
  int get id;
}

// Classe abstraite
abstract class Task implements Identifiable {
  @override
  final int id;
  String title;
  String priority; // low, medium, high
  DateTime? dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.dueDate,
    this.isCompleted = false,
  });

  void markCompleted() => isCompleted = true;

  Map<String, dynamic> toJson();
  @override
  String toString();
}

// Héritage 1
class UrgentTask extends Task {
  UrgentTask({
    required super.id,
    required super.title,
    super.dueDate,
  }) : super(priority: 'high');

  @override
  Map<String, dynamic> toJson() => {
    'type': 'UrgentTask',
    'id': id,
    'title': title,
    'priority': priority,
    'dueDate': dueDate?.toIso8601String(),
    'isCompleted': isCompleted,
  };

  @override
  String toString() =>
    '[URGENT] #$id: $title ${isCompleted? "(Terminé)" : ""} - Echéance: ${dueDate?.toLocal().toString().split(' ')[0]?? "Aucune"}';
}

// Héritage 2
class NormalTask extends Task {
  NormalTask({
    required super.id,
    required super.title,
    required super.priority,
    super.dueDate,
  });

  @override
  Map<String, dynamic> toJson() => {
    'type': 'NormalTask',
    'id': id,
    'title': title,
    'priority': priority,
    'dueDate': dueDate?.toIso8601String(),
    'isCompleted': isCompleted,
  };

  @override
  String toString() =>
    '[${priority.toUpperCase()}] #$id: $title ${isCompleted? "(Terminé)" : ""} - Echéance: ${dueDate?.toLocal().toString().split(' ')[0]?? "Aucune"}';
}

// Factory pour charger depuis JSON
Task taskFromJson(Map<String, dynamic> json) {
  final dueDate = json['dueDate']!= null? DateTime.parse(json['dueDate']) : null;

  if (json['type'] == 'UrgentTask') {
    return UrgentTask(
      id: json['id'],
      title: json['title'],
      dueDate: dueDate,
    )..isCompleted = json['isCompleted'];
  } else {
    return NormalTask(
      id: json['id'],
      title: json['title'],
      priority: json['priority'],
      dueDate: dueDate,
    )..isCompleted = json['isCompleted'];
  }
}