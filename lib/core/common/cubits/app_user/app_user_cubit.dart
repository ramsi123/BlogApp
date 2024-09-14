import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_out.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_user_state.dart';

/// why we still need to do another AppUserInitial() when user == null in updateUser function? even though we already did that
/// 'AppUserCubit() : super(AppUserInitial());'. the reason is because when the user logs out from the app, the user is
/// going to be null, and therefore we need to send them back to their initial state. because initial state represents
/// the logged out state.
///
/// cubit doesn't work on the concept of events, bloc does. in cubit, you can directly call the function.

class AppUserCubit extends Cubit<AppUserState> {
  final UserSignOut userSignOut;
  AppUserCubit(this.userSignOut) : super(AppUserInitial());

  void updateUser(User? user) {
    if (user == null) {
      emit(AppUserInitial());
    } else {
      emit(AppUserLoggedIn(user));
    }
  }

  void signOut() async {
    emit(AppUserLoading());
    final res = await userSignOut(NoParams());

    res.fold(
      (l) => emit(AppUserFailure(l.message)),
      (r) => emit(AppUserSignOutSuccess()),
    );
  }
}
