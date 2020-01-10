import 'dart:async';
import 'dart:convert';

import 'package:shareRIDE/domain/repositories/authentication_repository.dart';
import 'package:shareRIDE/domain/usecases/auth/register_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class RegisterPresenter extends Presenter {
  final JsonDecoder _decoder = new JsonDecoder();
  final JsonEncoder _encoder = new JsonEncoder();

  Map<String, String> headers = {"content-type": "Application/json"};
  Map<String, String> cookies = {};

  void _updateCookie(http.Response response) {
    String allSetCookie = response.headers['set-cookie'];

    if (allSetCookie != null) {
      var setCookies = allSetCookie.split(',');

      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');

        for (var cookie in cookies) {
          _setCookie(cookie);
        }
      }

      headers['cookie'] = _generateCookieHeader();
    }
  }

  void _setCookie(String rawCookie) {
    if (rawCookie.length > 0) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];

        // ignore keys that aren't cookies
        if (key == 'path' || key == 'expires') return;

        this.cookies[key] = value;
      }
    }
  }

  String _generateCookieHeader() {
    String cookie = "";

    for (var key in cookies.keys) {
      if (cookie.length > 0) cookie += ";";
      cookie += key + "=" + cookies[key];
    }

    return cookie;
  }

  AuthenticationRepository _authenticationRepository;
  RegisterUserCase _registerUserCase;

  Function registerOnComplete;
  Function registerOnError;

  RegisterPresenter(this._authenticationRepository) {
    _registerUserCase = RegisterUserCase(_authenticationRepository);
  }


  void dispose() {
    _registerUserCase.dispose();
  }

  void register(
      {@required String username,
      @required String email,
      @required String contactNumber,
      @required String address,
      @required String password}) async {
    var data = {"user_name": username,
                "email": email,
                "contact_no": contactNumber,
                "address": address,
                "password": password,
    };
    /*var authResponse = await http.post(
        "http://172.19.9.120/api/method/login?usr=Administrator&pwd=admin");
    _updateCookie(authResponse);

    var response = await http.post("http://172.19.9.120/api/resource/Appuser",
        headers: headers, body: json.encode(data));

    if (response.statusCode == 200) {
    } else {
      print('A network error occurred');
    }*/

    _registerUserCase.execute(_RegisterUserCaseObserver(this),
    RegisterUserCaseParams(username, email, contactNumber, address,password));
}
}

class _RegisterUserCaseObserver implements Observer<void> {
  RegisterPresenter _registerPresenter;

  _RegisterUserCaseObserver(this._registerPresenter);

  void onNext(ignore) {}

  void onComplete() {
    _registerPresenter.registerOnComplete();
  }

  void onError(e) {
    if (_registerPresenter.registerOnError != null) {
      _registerPresenter.registerOnError(e);
    }
  }
}
