import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logss/common/constants/text.dart';
import 'package:logss/data/repositary/auth_repo.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepo _authRepo = AuthRepo();
  SessionCubit() : super(UnknownState()) {
    checkSession();
  }

  void checkSession() async {
    var status = await _authRepo.isLogIn();
    print(status);
    if (status) {
      showAuth();
    } else {
      showUnAuth();
    }
  }

  void showAuth() {
    var _user = getUserInfo();
    TextConstant.displayName = _user!.email;
    emit(
      Authenticated(user: _user),
    );
  }

  void showUnAuth() => emit(UnAuthenticated());

  void logOut() {
    _authRepo.logOut();
    showUnAuth();
    print("logged out");
  }

  User? getUserInfo() {
    User? user = _authRepo.getUser();
    return user;
  }
}
