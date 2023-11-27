import 'package:async/async.dart';
import 'package:auth/src/domain/sgnUp_service_contract.dart';
import '../domain/token.dart';


class SignInUseCase {
  final ISignUpService _signUpService;

  SignInUseCase(this._signUpService);

  Future<Result<Token>> execute(
    String name, 
    String email, 
    String password
    ) async {
    return await _signUpService.signUp(name,email,password);
  }
}
