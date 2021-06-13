import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/repositories/repositories.dart';
import 'package:instagram_clone/screens/login/cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/login";

  static Route route() {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      transitionDuration: Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
        create: (_) => LoginCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();

    void _submitForm(BuildContext context, bool isSubmitting) {
      if (_fromKey.currentState.validate() && !isSubmitting) {
        context.read<LoginCubit>().loginWithCredentials();
      }
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Error'),
                  content: Text(state.failure.message),
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
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
                              onChanged: (value) => context
                                  .read<LoginCubit>()
                                  .emailChanged(value),
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
                              onChanged: (value) => context
                                  .read<LoginCubit>()
                                  .passwordChanged(value),
                            ),
                            SizedBox(height: 28.0),
                            ElevatedButton(
                                onPressed: () {
                                  _submitForm(context,
                                      state.status == LoginStatus.submitting);
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
            );
          },
        ),
      ),
    );
  }
}
