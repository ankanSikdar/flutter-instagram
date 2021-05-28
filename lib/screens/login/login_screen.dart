import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/login";

  static Route route() {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      transitionDuration: Duration(seconds: 0),
      pageBuilder: (_, __, ___) => LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();

    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Form(
                    key: _fromKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Instagram',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Email cannot be empty';
                            } else if (value.contains(' ')) {
                              return 'Email must not contain whitespace';
                            } else if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onChanged: (value) => print(value),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(hintText: 'Password'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password cannot be empty';
                            } else if (value.contains(' ')) {
                              return 'Password must not contain whitespace';
                            } else if (value.length < 6) {
                              return 'Password must be atleast 6 characters long';
                            }
                            return null;
                          },
                          onChanged: (value) => print(value),
                        ),
                        SizedBox(height: 28.0),
                        ElevatedButton(
                            onPressed: () {
                              print('Login Pressed');
                            },
                            child: Text('Login')),
                        SizedBox(height: 12.0),
                        OutlinedButton(
                            onPressed: () {
                              print('Register Button Pressed');
                            },
                            child: Text('No account? Sign Up')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
