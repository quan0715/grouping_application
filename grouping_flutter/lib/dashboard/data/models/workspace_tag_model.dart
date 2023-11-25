/// ## the type for [WorkspaceModel.tags]
/// * [content] : the value for this tag
class WorkspaceTag {
  String content;
  WorkspaceTag({required this.content});

  @override
  String toString() {
    return 'WorkSpace tag: $content';
  }
}