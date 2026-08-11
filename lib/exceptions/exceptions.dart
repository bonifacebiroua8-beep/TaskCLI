class TaskException implements Exception {
  final String message;
  TaskException(this.message);
  @override
  String toString() => 'TaskException: $message';
}

class TaskNotFoundException extends TaskException {
  TaskNotFoundException(int id) : super('Tâche avec id $id introuvable');
}

class InvalidPriorityException extends TaskException {
  InvalidPriorityException(String priority)
    : super('Priorité invalide: $priority. Valeurs: low, medium, high');
}