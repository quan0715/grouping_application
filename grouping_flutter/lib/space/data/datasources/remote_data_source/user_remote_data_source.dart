import 'dart:convert';
import 'package:grouping_project/core/config/config.dart';
import 'package:grouping_project/core/exceptions/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:image_picker/image_picker.dart';

/// The server backend IP of the database
/// ## 這個 UserService 主要是負責處理 user 的功能操作
///
/// 此 service 可以 get, update user

abstract class UserRemoteDataSource {
  UserRemoteDataSource({String token = ""});
  Future<UserModel> getUserData({required int uid});
  Future<UserModel> updateUserData({required UserModel account});
  Future<UserModel> updateUserProfileImage({required UserModel account, required XFile image});
}

class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  late final String _token;
  late final Map<String, String> headers;
  http.Client _client = http.Client();

  /// ## 這個 UserService 主要是負責處理 user 的功能操作
  /// r
  /// 此 service 可以 get, update user
  ///
  /// * [token] : 使用者的認證碼
  ///
  /// ### Example
  /// ```dart
  /// UserService service = UserService(token: userToken);
  /// ```
  ///
  UserRemoteDataSourceImpl({required String token}) {
    _token = token;
    headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $_token",
    };
    // debugPrint(_token);
    // debugPrint(headers.toString());
  }

  // / 設定當前 UserService 要對後端傳遞的**客戶(client)**
  void setClient(http.Client client) {
    _client = client;
  }

  /// 獲取當前 UserService 要對後端傳遞的**客戶(client)**
  http.Client getClient() {
    return _client;
  }

  /// ## 獲取想要的 user 的資訊
  ///
  /// 傳入 [uid] 來獲取 [UserModel]\
  /// 若未出錯則回傳 [UserModel]\
  /// 若 [uid] 有格式錯誤則會丟出 [Exception]\
  /// 若 [uid] 所對應的 [UserModel] 不存在則會丟出 [Exception]
  ///
  /// ### Example
  /// ```dart
  /// AccountModel account = await UserService.getUserData(uid: -1);
  /// ```

  @override
  Future<UserModel> getUserData({required int uid}) async {
    final apiUri = Uri.parse("${Config.baseUriWeb}/api/users/$uid/");
    final response = await _client.get(apiUri, headers: headers);
    // debugPrint(response.body);
    switch (response.statusCode) {
      case 200:
        // To avoid chinese character become unicode, we need to decode response.bodyBytes to utf-8 format first
          return UserModel.fromJson(data: jsonDecode(utf8.decode(response.bodyBytes)));
        case 400:
          throw ServerException(exceptionMessage: "Invalid Syntax");
        case 404:
          throw ServerException(exceptionMessage: "The requesting data was not found");
        default:
          return UserModel.defaultUser;
    }
  }

  /// ## 更新 user 的資訊
  ///
  /// 傳入 [UserModel] 來更新資料\
  /// 若未出錯則回傳更新後的 [UserModel]\
  /// 若 [account] 有格式錯誤則會丟出 [Exception]\
  /// 若 [account] 所對應的 [UserModel] 不存在則會丟出 [Exception]
  ///
  /// ### Example
  /// ```dart
  /// AccountModel account = await UserService.updateUserData(account: updateModelOfAccount);
  /// ```
  ///
  @override
  Future<UserModel> updateUserData({required UserModel account}) async {
    final apiUri = Uri.parse("${Config.baseUriWeb}/api/users/${account.id}/");
    // debugPrint("before update---------------------------");
    // debugPrint(jsonEncode(account.toJson()).toString());
    final response = await _client.patch(apiUri, headers: headers, body: jsonEncode(account.toJson()));
    // debugPrint("after update---------------------------");
    // debugPrint(jsonDecode(utf8.decode(response.bodyBytes)).toString());
    switch (response.statusCode) {
      case 200:

        return UserModel.fromJson(data: jsonDecode(utf8.decode(response.bodyBytes)));
      case 400:
        throw ServerException(exceptionMessage: "Invalid Syntax");
      case 404:
        throw ServerException(
            exceptionMessage: "The requesting data was not found");
      default:
        return UserModel.defaultUser;
    }
  }

  @override
  Future<UserModel> updateUserProfileImage({required UserModel account,required XFile image}) async {
    final apiUri = Uri.parse("${Config.baseUriWeb}/api/users/${account.id}/");
    
    // request.fields[] = productId.toString();
    // request.files.add(await http.MultipartFile.fromPath('photo_data', imageURL));
    var request = http.MultipartRequest("PATCH", apiUri);

    request.files.add(
      http.MultipartFile.fromBytes(
        'photo_data',
        await image.readAsBytes(),
    //  contentType: MediaType('application', 'octet-stream'),
        filename: '${account.id}_profile.jpg',
      ),
    );
    // fields.forEach((k, v) => request.fields[k] = v);
    request.headers.addAll(headers);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    // debugPrint(response.body);
    switch (response.statusCode) {
      case 200:
        // debugPrint(jsonDecode(utf8.decode(response.bodyBytes)).toString());
        return UserModel.fromJson(data: jsonDecode(utf8.decode(response.bodyBytes)));
      case 400:
        throw ServerException(exceptionMessage: "Invalid Syntax");
      case 404:
        throw ServerException(
            exceptionMessage: "The requesting data was not found");
      default:
        return UserModel.defaultUser;
    }
  }
}
