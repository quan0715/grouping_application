import 'package:grouping_project/core/data/models/simple_workspace.dart';

abstract class SimpleActivity {
  final int id;
  String title;
  SimpleWorkspace belongWorkspace;

  SimpleActivity({required this.id, required this.title, required this.belongWorkspace});
}