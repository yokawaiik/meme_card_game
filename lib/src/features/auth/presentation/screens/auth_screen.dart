import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common_widgets/default_text_field.dart';
import '../../../../common_widgets/password_text_field.dart';
import '../../../../common_widgets/rounded_button.dart';
import '../../../../models/supabase_exception.dart';
import '../../application/auth_api_service.dart';
import '../cubit/authentication_cubit.dart';

import '../../utils/auth_validators.dart' as auth_validators;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String? _loginText;
  String? _emailText;
  String? _passwordText;

  var _isSignIn = true;

  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _loginText = '';
    _emailText = '';
    _passwordText = '';
    _formKey = GlobalKey<FormState>();

    super.initState();
  }

  void _changeAuthMode() {
    setState(() {
      _isSignIn = !_isSignIn;
    });
  }

  bool _validateFields() {
    return _formKey.currentState!.validate();
  }

  Future<void> _signIn(BuildContext context) async {
    try {
      final authCubit = context.read<AuthenticationCubit>();

      if (!_validateFields()) return;

      await authCubit.signIn(_emailText!, _passwordText!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unexpected error'),
        ),
      );
    }
  }

  Future<void> _signUp(BuildContext context) async {
    try {
      final authCubit = context.read<AuthenticationCubit>();

      if (!_validateFields()) return;

      await authCubit.signUp(_loginText!, _emailText!, _passwordText!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          // final authCubit = context.read<AuthCubit>();

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 40,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isSignIn ? "Sign in" : "Sign up",
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      child: Column(
                        children: !_isSignIn
                            ? [
                                const SizedBox(
                                  height: 20,
                                ),
                                DefaultTextField(
                                  labelText: "Login",
                                  autofillHints: const [AutofillHints.nickname],
                                  validator: auth_validators.checkLogin,
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  onChanged: (v) {
                                    _loginText = v;
                                  },
                                ),
                              ]
                            : [],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DefaultTextField(
                      labelText: "Email",
                      autofillHints: const [AutofillHints.email],
                      prefixIcon: Icon(
                        Icons.alternate_email,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      validator: auth_validators.checkEmail,
                      onChanged: (v) {
                        _emailText = v;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PasswordTextField(
                      labelText: "Password",
                      validator: auth_validators.checkPassword,
                      autofillHints: const [AutofillHints.email],
                      prefixIcon: Icon(
                        Icons.password,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onChanged: (v) {
                        _passwordText = v;
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    _buildRoundedButton(),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: _changeAuthMode,
                      child: Text(
                        !_isSignIn
                            ? "Have you already an account?"
                            : "Don't have an account?",
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  RoundedButton _buildRoundedButton() {
    final authCubit = context.read<AuthenticationCubit>();

    final colorScheme = Theme.of(context).colorScheme;

    return RoundedButton(
      onPressed: authCubit.state is AuthenticationLoadingState
          ? null
          : () => _isSignIn ? _signIn(context) : _signUp(context),
      child: authCubit.state is AuthenticationLoadingState
          ? SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                color: colorScheme.onSecondary,
              ),
            )
          : Text(
              (_isSignIn ? "Sign in" : "Sign up").toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
    );
  }
}
