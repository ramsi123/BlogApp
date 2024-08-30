import 'package:blog_app/core/constants/supabase_constants.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );

      if (response.user == null) {
        throw const ServerException('User is null!');
      }

      /// obtain name from database
      final accountName = await supabaseClient
          .from(SupabaseConstants.profilesDatabase)
          .select('name')
          .eq('id', currentUserSession!.user.id);

      return UserModel.fromJson(response.user!.toJson()).copyWith(
        name: accountName[0]['name'] ?? '',
      );
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
        },
      );

      if (response.user == null) {
        throw const ServerException('User is null!');
      }

      /// obtain name from database
      final accountName = await supabaseClient
          .from(SupabaseConstants.profilesDatabase)
          .select('name')
          .eq('id', currentUserSession!.user.id);

      return UserModel.fromJson(response.user!.toJson()).copyWith(
        name: accountName[0]['name'] ?? '',
      );
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        /// make sure to use await. if not, you will get PostgrestFilterBuilder as a return.
        final userData = await supabaseClient
            .from(SupabaseConstants.profilesDatabase)
            .select()
            .eq('id', currentUserSession!.user.id);

        /// why using first in userData.first?
        /// because, in default i will get list of data from userData if i don't mention the eq(). but, since i mention
        /// the eq() to only get the user with certain id, then i will retrieve only one user. That is why i'm using
        /// .first to take the first data of the list.
        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
        );
      }

      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
