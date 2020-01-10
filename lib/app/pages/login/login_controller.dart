import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter/material.dart';
import 'package:shareRIDE/app/components/hhDrawer/hhDrawerView.dart';
import 'package:shareRIDE/app/pages/login/login_presenter.dart';
import 'package:shareRIDE/app/utils/constants.dart';

class LoginController extends Controller {
  // Text Field controllers
  TextEditingController emailTextController;
  TextEditingController passwordTextController;

  LoginPresenter _loginPresenter;
  // DataUserRepository _dataUserRepository;

  LoginController(authRepo) : _loginPresenter = LoginPresenter(authRepo) {
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    initListeners();
  }

  /// Initializes [Presenter] listeners
  void initListeners() {
    _loginPresenter.loginOnComplete = this._loginOnComplete;
    _loginPresenter.loginOnError = this._loginOnError;
  }

  /// Login is successful
  void _loginOnComplete() {
    dismissLoading();
    HHHConstants.drawer = HhDrawer(); // refresh
    Navigator.of(getContext()).pushReplacementNamed('/home');
  }

  void _loginOnError(e) {
    dismissLoading();
    showGenericSnackbar(getStateKey(), e.message, isError: true);
  }

  /// Logs a [User] into the application
  void login() async {
    showLoading();
    _loginPresenter.login(
        email: emailTextController.text, password: passwordTextController.text);
  }
 /* void login() {
    Navigator.of(getContext()).pushNamed('/home');
  }*/

  void register() {
    Navigator.of(getContext()).pushNamed('/register');
  }
  void navigateToLogin(){
    Navigator.of(getContext()).pushNamed('/login');
  }

  void forgotPassword() {
    Navigator.of(getContext()).pushNamed('/forgotPw');
  }
}
