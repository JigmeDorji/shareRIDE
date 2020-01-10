import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shareRIDE/app/pages/register/register_presenter.dart';
import 'package:shareRIDE/app/utils/constants.dart';
import 'package:flutter/material.dart';

class RegisterController extends Controller {
  TextEditingController username;
  TextEditingController email;
  TextEditingController address;
  TextEditingController password;
  TextEditingController confirmedPassword;
  TextEditingController contactNumber;

  bool agreedToTOS;
  RegisterPresenter _registerPresenter;

  RegisterController(authRepo)
      : _registerPresenter = RegisterPresenter(authRepo) {
    username = TextEditingController();
    email = TextEditingController();
    contactNumber = TextEditingController();
    address = TextEditingController();
    password = TextEditingController();
    confirmedPassword = TextEditingController();
    agreedToTOS = false;

    initListeners();
  }

  void initListeners() {
    _registerPresenter.registerOnComplete = () {
      logger.finest("Complete: Registration success.");
//      showGenericSnackbar(getStateKey(), Strings.registrationSuccessful);
      Navigator.of(getContext()).pop();
    };

    _registerPresenter.registerOnError = (e) {
      showGenericSnackbar(getStateKey(), e.message, isError: true);
    };
  }

  void register() {
    _registerPresenter.register(
        username: username.text,
        email: email.text,
        contactNumber: contactNumber.text,
        address: address.text,
        password: password.text);
  }

  void setAgreedToTOS() {
    agreedToTOS = !agreedToTOS;
  }

  void checkForm(Map<String, dynamic> params) {
    dynamic formKey = params['formKey'];

    // Validate params
    assert(formKey is GlobalKey<FormState>);

    if (formKey.currentState.validate()) {
      if (agreedToTOS) {
        register();
      } else {
        showGenericSnackbar(getStateKey(), Strings.tosNotAccepted,
            isError: true);
      }
    } else {
      logger.shout('Registration failed');
      showGenericSnackbar(getStateKey(), Strings.registrationFormIncomplete,
          isError: true);
    }
  }

  @override
  void dispose() {
    _registerPresenter.dispose();
    super.dispose();
  }
}
