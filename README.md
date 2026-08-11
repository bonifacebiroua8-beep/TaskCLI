# task_cli

CLI de gestion de tâches en Dart.

## Description

Ce projet fournit une application en ligne de commande pour créer, lister, compléter et supprimer des tâches. Il est structuré autour de:

- `lib/models/task.dart` : définition des tâches et des types de tâches.
- `lib/repository/repository.dart` : stockage des tâches dans un fichier JSON.
- `lib/services/task_service.dart` : logique métier pour gérer les tâches.
- `test/task_test.dart` : tests unitaires pour valider le comportement.

## Prérequis

- Dart SDK 3.x

## Installation

1. Ouvrir un terminal dans le dossier du projet.
2. Installer les dépendances :

```bash
dart pub get
```

## Exécution des tests

Pour exécuter les tests unitaires :

```bash
dart test
```

## Structure du projet

- `bin/main.dart` : point d’entrée de l’application CLI.
- `lib/models/task.dart` : classes `Task`, `UrgentTask`, `NormalTask` et conversion JSON.
- `lib/repository/repository.dart` : repository pour lire et écrire les tâches dans un fichier.
- `lib/services/task_service.dart` : service de gestion des tâches.
- `lib/exceptions/exceptions.dart` : exceptions personnalisées.
- `test/task_test.dart` : scénarios de test pour l’ajout, la complétion et la suppression de tâches.

## Fonctionnalités

- Ajouter une tâche avec un titre, une priorité et une date d’échéance optionnelle.
- Marquer une tâche comme terminée.
- Supprimer une tâche par son identifiant.
- Lister les tâches triées par id, priorité ou date.

## Personnalisation

Tu peux adapter le stockage en modifiant le chemin de fichier dans `TaskRepository` et étendre les options utilisateur dans `bin/main.dart`.

## Contribution

1. Créer une branche feature.
2. Faire tes modifications.
3. Ajouter des tests.
4. Proposer une PR.
