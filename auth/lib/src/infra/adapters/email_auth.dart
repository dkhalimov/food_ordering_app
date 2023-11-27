import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';

import '../../domain/credentinal.dart';
import '../../domain/auth_service_contract.dart';
import '../../domain/token.dart';
import '../api/auth_api_conrtract.dart';

class EmailAuth implements IAuthService {
  final IAuthApi _api;
  late Credential _credential;
  EmailAuth(this._api);

  void credential({
    required String email,
    required String password,
  }) {
    _credential = Credential(
      type: AuthType.email,
      email: email,
      password: password,
    );
  }

@override
  Future<Result<Token>> signIn() async {
    assert(_credential != null);
    var result = await _api.signIn(_credential);
    if (result.isError) {
      // Переместите тип аргумента после имени типа
      return Result<Token>.error('Сообщение об ошибке: ${result.asError}');
    }
    return Result<Token>.value(Token(result.asValue!.value));
  }



  @override
  Future<Result<bool>> signOut(Token token) async {
    return await _api.signOut(token);
  }
}
