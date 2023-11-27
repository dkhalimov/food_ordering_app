import 'package:async/async.dart';
import 'package:auth/src/domain/credentinal.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/auth_service_contract.dart';
import '../../domain/credentinal.dart';
import '../../domain/token.dart';
import '../../infra/api/auth_api_conrtract.dart';

class GoogleAuth implements IAuthService {
  final IAuthApi _authApi;
  late GoogleSignIn _googleSignIn;
  late GoogleSignInAccount _currentUser;

  GoogleAuth(this._authApi, [GoogleSignIn? googleSignIn])
      : this._googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: ['email', 'profile'],
            );

  // @override
  // Future<Result<Token>> signIn() async {
  //   await _handleGoogleSignIn();
  //   if (_currentUser == null)
  //     return Result.error('Failed to signin with Google');

  //   // Проверяем на null перед использованием
  //   Credential credential = Credential(
  //       type: AuthType.google,
  //       email: _currentUser!.email,
  //       name: _currentUser!.displayName);
  //   var result = await _authApi.signIn(credential);
  //   if (result.isError) return result.asError;

  //   return Result.value(Token(result.asValue.value));
  // }

@override
  Future<Result<Token>> signIn() async {
    await _handleGoogleSignIn();

    if (_currentUser == null) {
      return Future.value(Result.error('Ошибка при входе через Google'));
    }

    String? userEmail = _currentUser!.email;
    String? userName = _currentUser!.displayName;

    if (userEmail == null || userName == null) {
      return Future.value(
          Result.error('Не удалось получить информацию о пользователе'));
    }

    Credential credential =
        Credential(type: AuthType.google, email: userEmail, name: userName);
    var result = await _authApi.signIn(credential);
    if (result != null && result.isError) {
      return Future.value(
          Result.error(result.asError?.toString() ?? 'Неизвестная ошибка'));
    }

    return Future.value(Result.value(Token(result!.asValue.value)));

  }


  @override
  Future<Result<bool>> signOut(Token token) async {
    var res = await _authApi.signOut(token);
    if (res.asValue.value) _googleSignIn.disconnect();
    return res;
  }

  _handleGoogleSignIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
    } catch (error) {
      return;
    }
  }
}
