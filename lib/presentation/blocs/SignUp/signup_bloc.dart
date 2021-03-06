import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logss/presentation/blocs/cubit/navigation_cubit.dart';
import 'package:logss/presentation/blocs/cubit/session_cubit.dart';
import 'package:logss/data/repositary/auth_repo.dart';
import '../../../FormSubmissionStatus.dart';
part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepo _authRepo = AuthRepo();
  final NavigationCubit navigationCubit;
  final SessionCubit sessionCubit;
  SignupBloc({required this.navigationCubit, required this.sessionCubit})
      : super(SignupState());

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is SignUpNameChanged) {
      yield state.copyWith(username: event.userName);
    }
    //email updated
    else if (event is SignUpEmailChanged) {
      yield state.copyWith(email: event.email);
    }
    //password updated
    else if (event is SignUpPasswordChanged) {
      yield state.copyWith(password: event.password);
    }
    //conf password updated
    else if (event is SignUpConfPassChanged) {
      yield state.copyWith(confPassword: event.confPassword);
    }
    //sign up button clicked
    else if (event is SignUpSubmitted) {
      //form submitting status
      yield state.copyWith(status: FormSubmitting());
      try {
        await _authRepo.signUp(
          email: state.email.trim(),
          password: state.password.trim(),
          name: state.username.trim(),
        );
        yield state.copyWith(status: SubmissionSuccess());
        navigationCubit.showLogIn();
      } catch (e) {
        yield state.copyWith(
          status: SubmissionFailed(
            exception: e.toString(),
          ),
        );
      }
    } else if (event is GoogleSignedIn) {
      yield state.copyWith(status: FormSubmitting());
      try {
        await _authRepo.googleSignIn();
        yield state.copyWith(status: SubmissionSuccess());
        sessionCubit.showAuth();
      } catch (e) {
        print(e.toString());
        yield state.copyWith(status: SubmissionFailed(exception: e.toString()));
      }
    }
  }
}


// 