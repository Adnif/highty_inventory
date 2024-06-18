import 'package:highty_inventory/domain/entities/user_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/user_repository.dart';

class SupabaseUserRepository implements UserRepository {
  final SupabaseClient client;

  SupabaseUserRepository(this.client);

  @override
  Future<UserAuth?> getUser() async {
    final user = client.auth.currentUser;
    if (user != null) {
      return UserAuth(
        id: user.id,
        fullName: user.userMetadata?['full_name'] ?? '',
        email: user.email ?? '',
      );
    }
    return null;
  }

  @override
  Future<void> updateUserFullName(String fullName) async {
    final response = await client.auth.updateUser(
      UserAttributes(data: {
        'full_name': fullName,
      }),
    );
    // if (response.error != null) {
    //   throw Exception(response.error!.message);
    // }
  }
}
