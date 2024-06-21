import 'package:highty_inventory/domain/entities/auth.dart';
import 'package:highty_inventory/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient supabase;

  AuthRepositoryImpl(this.supabase);

  @override
  Future<UserAuth?> signIn(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(email: email, password: password);
    String displayName = '';
    if (response.session != null) {
      final user = supabase.auth.currentUser;
      displayName = user?.userMetadata?['full_name'] ?? 'No display name set';
      return UserAuth(id: response.user?.id ?? '', email: email, fullName: displayName);
    }
    return null;
  }
}
