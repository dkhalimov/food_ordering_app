import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import '../../domain/credentinal.dart';
import '../api/auth_api_conrtract.dart';
import '../../domain/auth_service_contract.dart';
import '../../domain/sgnUp_service_contract.dart';
import '../../domain/token.dart';

class EmailAuth implements IAuthService, ISignUpService {
  final IAuthApi _api;
  Credential _credential;
  EmailAuth(this._api);

  void credential({
    @required String email,
    @required String password,
  }) {
    _credential = Credential(type: AuthType.email, email: email, password: password);
  }


  @override
  Future<Result<Token>> signIn() async {
    assert(_credential != null);
    var result = await _api.signIn(_credential);
    if (result.isError) return result.asError();
    return Result.value(Token(result.asValue.value));

  }



  @override
  Future<Result<Token>> signOut() {
    throw UnimplementedError();
  }



  @override
  Future<Result<Token>> signUp(String name, String email, String password) {
    Credential credential = Credential(
      type: AuthType.email,
      email: email,
      password: password
    );

    var result = await _api.signUp(credential);
    if(result.isError) return result.asError;
    return Result.value(Token(result.asValue.value));
  }
}
