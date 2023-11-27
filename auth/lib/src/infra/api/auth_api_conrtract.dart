import '../../domain/credentinal.dart';
import 'package:async/async.dart';

abstract class IAuthApi {
  Future<Result<Stirng>> signIn(Credential credential);
  Future<Result<Stirng>> signUp(Credential credential);
}
