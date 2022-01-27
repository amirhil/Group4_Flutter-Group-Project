import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../models/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(51, 51, 255, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  Map<String, String> _authDetail = {
    'username': '',
    'role': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _controller; //Define the controller
  late Animation<Size> _heightAnimation; //Define the height

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _heightAnimation = Tween<Size>(
            begin: Size(double.infinity, 260), end: Size(double.infinity, 320))
        .animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'].toString(),
          _authData['password'].toString(),
        );
      } else {
        // Sign user up
        Provider.of<Auth>(context, listen: false).signupDetail(
          _authDetail['username'].toString(),
          _authDetail['role'].toString(),
        );
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'].toString(),
          _authData['password'].toString(),
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  //============== Widget ================================

  Widget _emailWidget() {
    return Stack(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontWeight: FontWeight.bold),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(173, 183, 192, 1)),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value!.isEmpty || !value.contains('@')) {
              return 'Invalid email!';
            }
          },
          onSaved: (value) {
            _authData['email'] = value as String;
          },
        ),
      ],
    );
  }

  Widget _roleWidget() {
    return Stack(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Role',
            labelStyle: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontWeight: FontWeight.bold),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(173, 183, 192, 1)),
            ),
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value!.isEmpty) {
              print('invalid Role');
              return 'Invalid Role!';
            }
          },
          onSaved: (value) {
            _authDetail['role'] = value as String;
          },
        ),
      ],
    );
  }

  Widget _nameWidget() {
    return Stack(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Name',
            labelStyle: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontWeight: FontWeight.bold),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(173, 183, 192, 1)),
            ),
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Invalid Name';
            }
          },
          onSaved: (value) {
            _authDetail['username'] = value as String;
          },
        ),
      ],
    );
  }

  Widget _passwordWidget() {
    return Stack(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontWeight: FontWeight.bold),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(173, 183, 192, 1)),
            ),
          ),
          obscureText: true,
          textInputAction: TextInputAction.next,
          controller: _passwordController,
          validator: (value) {
            if (value!.isEmpty || value.length < 5) {
              return 'Password is too short!';
            }
          },
          onSaved: (value) {
            _authData['password'] = value as String;
          },
        ),
      ],
    );
  }

  Widget _confirmPasswordWidget() {
    return Stack(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            labelStyle: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontWeight: FontWeight.bold),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(173, 183, 192, 1)),
            ),
          ),
          obscureText: true,
          textInputAction: TextInputAction.next,
          validator: _authMode == AuthMode.Signup
              ? (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match!';
                  }
                }
              : null,
        ),
      ],
    );
  }

  Widget _submitButton() {
    return RaisedButton(
      child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
      onPressed: _submit,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      color: Theme.of(context).primaryColor,
      textColor: Theme.of(context).primaryTextTheme.button!.color,
    );
  }

  Widget _sign() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: InkWell(
        child: Text(
          '${_authMode == AuthMode.Login ? 'Register' : 'Login'}',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationThickness: 2),
        ),
        onTap: _switchAuthMode,
      ),
    );
  }

  //==================== Widget Build ========================

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      height: height,
      child: Form(
        key: _formKey,
        child: Stack(
          children: [
            if (_authMode == AuthMode.Login)
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(height: height * .1),
                          Container(
                            height: 240,
                            width: 240,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(215, 117, 255, 1)
                                      .withOpacity(0.5),
                                  Color.fromRGBO(51, 51, 255, 1)
                                      .withOpacity(0.9),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0, 1],
                              ),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40),
                                topLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40),
                                bottomLeft: Radius.circular(40),
                              ),
                              border: Border.all(
                                width: 5,
                                color: Colors.deepPurpleAccent,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Image.asset(
                              'assets/images/logoDumbell1.png',
                              width: 300.0,
                              height: 300.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Text(
                            "Sport Inventory",
                            style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RobotoCondensed',
                            ),
                          ),
                          SizedBox(height: height * .05),
                          _emailWidget(),
                          SizedBox(height: 20),
                          _passwordWidget(),
                          SizedBox(height: 30),
                          _submitButton(),
                          SizedBox(height: height * .050),
                          _sign(),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else if (_authMode == AuthMode.Signup)
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Text("Sign Up"),
                          SizedBox(height: height * .2),
                          _roleWidget(),
                          SizedBox(height: 20),
                          _nameWidget(),
                          SizedBox(height: 20),
                          _emailWidget(),
                          SizedBox(height: 20),
                          _passwordWidget(),
                          SizedBox(height: 20),
                          _confirmPasswordWidget(),
                          SizedBox(height: 80),
                          _submitButton(),
                          SizedBox(height: height * .030),
                          _sign(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
