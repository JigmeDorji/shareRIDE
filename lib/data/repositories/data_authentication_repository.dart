import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shareRIDE/domain/repositories/authentication_repository.dart';
import 'package:shareRIDE/data/utils/constants.dart';
import 'package:shareRIDE/domain/entities/user.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shareRIDE/data/utils/http_helper.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

/// `DataAuthenticationRepository` is the implementation of `AuthenticationRepository` present
/// in the Domain layer. It communicates with the server, making API calls to register, login, logout, and
/// store a `User`.
class DataAuthenticationRepository implements AuthenticationRepository {
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

  // Members
  /// Singleton object of `DataAuthenticationRepository`
  static DataAuthenticationRepository _instance =
      DataAuthenticationRepository._internal();
  Logger _logger;

  // Constructors
  DataAuthenticationRepository._internal() {
    _logger = Logger('DataAuthenticationRepository');
  }

  factory DataAuthenticationRepository() => _instance;

  // AuthenticationRepository Methods

  /// Registers a `User` using a [email] and a [password] by making an API call to the server.
  /// It is asynchronous and can throw an `APIException` if the statusCode is not 200.
  Future<void> register(
      {@required String username,
      @required String email,
      @required String contactNumber,
      @required String address,
      @required String password}) async {
    var data = {
      "user_name": username,
      "email": email,
      "contact_no": contactNumber,
      "address": address,
      "password": password,
    };
    var authResponse = await http.post(
        "http://192.168.43.162/api/method/login?usr=Administrator&pwd=admin");
    _updateCookie(authResponse);

    /*var response = await http.post("http://172.19.9.120/api/resource/Appuser",
        headers: headers, body: json.encode(data));

    if (response.statusCode == 200) {
    } else {
      print('A network error occurred');
    }*/

    try {
      await HttpHelper.invokeHttp(Constants.usersRoute, RequestType.post,
          headers: headers, body: json.encode(data));
      _logger.finest('Registration is successful');
    } catch (error) {
      _logger.warning('Could not register new user.', error);
      rethrow;
    }
  }

  /// Logs in a `User` using a [email] and a [password] by making an API call to the server.
  /// It is asynchronous and can throw an `APIException` if the statusCode is not 200.
  /// When successful, it attempts to save the credentials of the `User` to local storage by
  /// calling [_saveCredentials]. Throws an `Exception` if an Internet connection cannot be
  /// established. Throws a `ClientException` if the http object fails.
  Future<void> authenticate(
      {@required String email, @required String password}) async {
    try {
      var authResponse = await http.post(
          "http://192.168.43.162/api/method/login?usr=Administrator&pwd=admin");
      _updateCookie(authResponse);

      // invoke http request to login and convert body to map
      Map<String, dynamic> body = await HttpHelper.invokeHttp(
          'http://192.168.43.162/api/resource/Appuser?fields=["user_name","name","email", "password"]&&filters=[["email", "=", "jigme@gmail.com"], ["password", "=", "123"]]',
          RequestType.get,
          headers: headers);
      _logger.finest('Login Successful.');

      // convert json to User and save credentials in local storage

//      User user = User.fromJson(body['data']);
//      _saveCredentials(token: body['token'], user: user);
      _saveCredentials();
    } catch (error) {
      _logger.warning(error.message);
      rethrow;
    }
  }

  /// Returns whether the current `User` is authenticated.
  Future<bool> isAuthenticated() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      bool isAuthenticated = preferences.getBool(Constants.isAuthenticatedKey);
      return isAuthenticated ?? false;
    } catch (error) {
      return false;
    }
  }

  Future<void> forgotPassword(String email) async {
    Uri uri = Uri.http(Constants.baseUrlNoPrefix, Constants.forgotPasswordPath,
        {'email': email});

    try {
      await HttpHelper.invokeHttp(uri, RequestType.get);
    } catch (error) {
      _logger.warning('Could not send reset password request.', error);
      rethrow;
    }
  }

  /// Logs the current `User` out by clearing credentials.
  Future<void> logout() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.remove(Constants.isAuthenticatedKey);
      preferences.remove(Constants.tokenKey);
      _logger.finest('Logout successful.');
    } catch (error) {
      _logger.warning('Could not log out.', error);
    }
  }

  /// Returns the current authenticated `User` from `SharedPreferences`.
  Future<User> getCurrentUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user =
        User.fromJson(jsonDecode(preferences.getString(Constants.userKey)));
    return user;
  }

  /// Saves the [token] and the [user] in `SharedPreferences`.
//  void _saveCredentials({@required String token, @required User user}) async {
  void _saveCredentials() async {
    try {
//      SharedPreferences preferences = await SharedPreferences.getInstance();
      await Future.wait([
//        preferences.setString(Constants.tokenKey, token),
//        preferences.setBool(Constants.isAuthenticatedKey, true),
//        preferences.setString(Constants.userKey, jsonEncode(user))
      ]);
      _logger.finest('Credentials successfully stored.');
    } catch (error) {
      _logger.warning('Credentials could not be stored.');
    }
  }
}
