import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shareRIDE/app/pages/register/register_controller.dart';
import 'package:shareRIDE/app/utils/constants.dart';
import 'package:shareRIDE/data/repositories/data_authentication_repository.dart';

class RegisterPage extends View {
  RegisterPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegisterPageView createState() =>
      _RegisterPageView(RegisterController(DataAuthenticationRepository()));
}

class _RegisterPageView extends ViewState<RegisterPage, RegisterController> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _RegisterPageView(RegisterController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: appBar,
      body: Stack(
        children: <Widget>[
          background,
          ListView(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: controller.username,
                        decoration: InputDecoration(
                          hintText: 'User Name',
                        ),
                        validator: (String value) {
                          if (value.trim().isEmpty) {
                            return 'User name is required.';
                          }
                        },
                      ),

                      SizedBox(height: 20.0),

                      TextFormField(
                        controller: controller.contactNumber,
                        decoration: InputDecoration(
                          hintText: 'Contact Number',
                        ),
                        validator: (String value) {
                          if (value.trim().isEmpty) {
                            return 'Contact Number is required.';
                          }
                        },
                      ),

                      SizedBox(height: 20.0),

                      TextFormField(
                        controller: controller.email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.trim().isEmpty) {
                            return 'Email address is required.';
                          }
                        },
                      ),
                      SizedBox(height: 20.0),

                      TextFormField(
                        controller: controller.address,
                        decoration: InputDecoration(
                          hintText: 'Address',
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.trim().isEmpty) {
                            return 'Address is required.';
                          }
                        },
                      ),


                      SizedBox(height: 20.0),

                      TextFormField(
                        controller: controller.password,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                        ),
                        validator: (String value) {
                          if (value.trim().isEmpty) {
                            return 'Password is required.';
                          }
                        },
                      ),

                      SizedBox(height: 20.0),

                      TextFormField(
                        controller: controller.confirmedPassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                        ),
                        validator: (String value) {
                          if (value.trim().isEmpty ||
                              controller.confirmedPassword.text !=
                                  controller.password.text) {
                            return 'Passwords must match.';
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RawMaterialButton(
                            onPressed: () {
                              // TODO: Open the TOS for view
                            },
                            child: Text(
                              'Terms of Service',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CheckboxListTile(
                              title: Text(
                                  'I agree to the Terms of Service and Privacy Policy'),
                              value: controller.agreedToTOS,
                              onChanged: (state) {
                                callHandler(controller.setAgreedToTOS);
                              },
                              activeColor: Colors.red,
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ],
                        ),
                      ),

                      //  SizedBox(height: .0),



                      SizedBox(height: 20.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RawMaterialButton(
                            onPressed: () => callHandler(controller.checkForm,
                                    params: {
                                      'context': context,
                                      'formKey': _formKey,
                                      'globalKey': globalKey
                                    }),
                            child: Container(
                              width: 320.0,
                              height: 50.0,
                              alignment: FractionalOffset.center,
                              decoration: new BoxDecoration(
                                  color: Color.fromRGBO(230, 38, 39, 1.0),
                                  borderRadius:
                                      new BorderRadius.circular(25.0)),
                              child: new Text("Register",
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 0.4)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar get appBar => AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text('New User Registration',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            )),
      );

  Widget get background => Positioned.fill(
        child: Image.asset(
          Resources.background,
          fit: BoxFit.cover,
        ),
      );
}
