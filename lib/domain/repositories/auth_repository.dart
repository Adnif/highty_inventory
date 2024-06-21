import 'package:highty_inventory/domain/entities/auth.dart';

abstract class AuthRepository {
  Future<UserAuth?> signIn(String email, String password);
}
