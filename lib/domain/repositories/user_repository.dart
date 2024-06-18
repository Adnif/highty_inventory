import 'package:highty_inventory/domain/entities/user_auth.dart';

abstract class UserRepository {
  Future<UserAuth?> getUser();
  Future<void> updateUserFullName(String fullName);
}
