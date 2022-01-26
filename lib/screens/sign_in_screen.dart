import 'package:flutter/material.dart';
import 'package:social_media_chat_flutter/bloc/auth_cubit/auth_cubit.dart';
import 'package:social_media_chat_flutter/common/ui_std.dart';
import 'package:social_media_chat_flutter/screens/sign_up_screen.dart';
import 'package:social_media_chat_flutter/widgets/custom_email_text_field.dart';
import 'package:social_media_chat_flutter/widgets/custom_password_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  static const String route = "/sign_in_screen";

  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  late final FocusNode _passwordFocusNode;

  late CustomEmailTextField emailField;
  late CustomPasswordTextField passField;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();

    emailField = CustomEmailTextField(
      nextNode: _passwordFocusNode,
    );

    passField = CustomPasswordTextField(
      focusNode: _passwordFocusNode,
      onSubmit: _submit,
    );

    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    // invalid!
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    context.read<AuthCubit>().signInWithEmail(
          email: emailField.value,
          password: passField.value,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                UIK.showError(context, state.errMessage);
              }

              if (state is AuthSignedIn) {
                if (!AuthCubit.emailVerified) {
                  UIK.showError(context, "Verify your e-mail!");
                }
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return UIK.loading;
              }

              return ListView(
                padding: const EdgeInsets.all(15),
                physics: const ClampingScrollPhysics(),
                children: [
                  // email
                  emailField,
                  // password
                  passField,

                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _submit(context),
                    child: const Text("Log in"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignUpScreen.route);
                    },
                    child: const Text("Sign up"),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
