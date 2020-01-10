import 'package:shareRIDE/domain/repositories/authentication_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shareRIDE/domain/entities/user.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

/// A `UseCase` for registering a new `User` in the application
class RegisterUserCase extends CompletableUseCase<RegisterUserCaseParams> {

  // Members
  AuthenticationRepository _authenticationRepository;

  // Constructors
  RegisterUserCase(this._authenticationRepository);

  
  @override
  Future<Observable<User>> buildUseCaseObservable(RegisterUserCaseParams params) async {
    final StreamController<User> controller = StreamController();
    try {
      await _authenticationRepository.register(username: params.username, email: params.email, contactNumber: params.contactNumber,address: params.address, password: params.password);
      controller.close();
    } catch (e) {
      logger.severe('RegisterUseCase unsuccessful.', e);
      controller.addError(e);
    }
    return Observable(controller.stream);
  }
}

/// The parameters required for the [RegisterUseCase]
class RegisterUserCaseParams {
  String username;
  String email;
  String contactNumber;
  String address;
  String password;

  RegisterUserCaseParams(this.username, this.email, this.contactNumber, this.address,this.password);
}
