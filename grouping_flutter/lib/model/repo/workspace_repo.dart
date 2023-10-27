import 'dart:convert';

import 'package:grouping_project/model/workspace/workspace_model.dart';
import 'package:http/http.dart' as http;

const String baseURL = "http://ip"; // TODO: we need to know the django website

class WorkspaceService{
  late final String _token;
  late final Map<String, String> headers;
  http.Client _client = http.Client();

  WorkspaceService({required String token}) {
    _token = token;
    headers = {
      "ContentType": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  void setClient(http.Client client) {
    _client = client;
  }

  http.Client getClient() {
    return _client;
  }

  Future<WorkspaceModel> getWorkspace(int workspaceId) async {
    final response =
        await _client.get(Uri.parse("$baseURL/workspaces/$workspaceId"), headers: headers);

    if (response.statusCode == 200) {
      return WorkspaceModel.fromJson(data: jsonDecode(response.body));
    } else {
      // TODO: raise Error
      return WorkspaceModel.defaultWorkspace;
    }
  }

  Future<WorkspaceModel> createWorkspace(WorkspaceModel workspace) async {
    Map<String, dynamic> workspaceBody = workspace.toJson();

    final response = await _client.post(
        Uri.parse("$baseURL/workspaces"),
        headers: headers,
        body: jsonEncode(workspaceBody));

    // successfully set up new data
    if (response.statusCode == 201) {
      return WorkspaceModel.fromJson(data: jsonDecode(response.body));
    } else {
      // TODO: raise Error
      return WorkspaceModel.defaultWorkspace;
    }
  }

  Future<WorkspaceModel> updataEvent(WorkspaceModel workspace) async {
    Map<String, dynamic> eventBody = workspace.toJson();

    final response = await _client.patch(
        Uri.parse("$baseURL/workspaces/${workspace.id}"),
        headers: headers,
        body: jsonEncode(eventBody));

    // successfully set up new data
    if (response.statusCode == 200) {
      return WorkspaceModel.fromJson(data: jsonDecode(response.body));
    } else {
      // TODO: raise Error
      return WorkspaceModel.defaultWorkspace;
    }
  }

  void deleteWorkspace(int workspaceId) async {
    final response = await _client.delete(
        Uri.parse("$baseURL/workspaces/$workspaceId"),
        headers: headers);

    // successfully delete data
    if (response.statusCode == 200) {
      // do nothing
    } else {
      // TODO: raise Error
    }
  }
}