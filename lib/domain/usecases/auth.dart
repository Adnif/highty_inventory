import 'package:highty_inventory/domain/entities/auth.dart';
import 'package:highty_inventory/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<UserAuth?> call(String email, String password) {
    return repository.signIn(email, password);
  }
}


