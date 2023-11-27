import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import '../../domain/credentinal.dart';
import 'auth_api_conrtract.dart';
import 'mapper.dart';
import '../../domain/token.dart';
import 'package:http/http.dart' as http;

class AuthApi implements IAuthApi {
  final http.Client _client; //  http.Client вместо HttpClient
  String baseUrl;

  AuthApi(this.baseUrl, this._client); 

  @override
  Future<Result<String>> signIn(Credential credential) async {
    var endpoint = Uri.parse(
        '$baseUrl/auth/signin'); //  Uri.parse для создания URL
    return await _postCredential(endpoint, credential);
  }

  @override
  Future<Result<String>> signUp(Credential credential) async {
    var endpoint = Uri.parse(
        '$baseUrl/auth/signup'); //  Uri.parse для создания URL
    return await _postCredential(endpoint, credential);
  }

  Future<Result<String>> _postCredential(
      Uri endpoint, Credential credential) async {
    var response =
        await _client.post(endpoint, body: Mapper.toJson(credential));
    if (response.statusCode != 200) return Result.error('Server error');

    var json = jsonDecode(response.body);

    return json['auth_token'] != null
        ? Result.value(json['auth_token'])
        : Result.error(json['message']);
  }
@override
  Future<Result<bool>> signOut(Token token) async {
    try {
      var url = Uri.parse(baseUrl + '/auth/signout');
      var headers = {
        "Content-type": "application/json",
        "Authorization": token.value
      };
      var response = await _client.post(url, headers: headers);

      if (response.statusCode == 200) {
        return Result.value(true);
      } else {
        // Обработка ошибок на сервере
        var errorMessage = jsonDecode(response.body)['message'];
        return Result.error('Sign-out failed: $errorMessage');
      }
    } catch (e) {
      // Обработка ошибок сети или других исключений
      return Result.error('Error during sign-out: $e');
    }
  }


}
