import 'package:flutter/material.dart';
import 'package:social_media_chat_flutter/bloc/auth_cubit/auth_cubit.dart';
import 'package:social_media_chat_flutter/common/ui_std.dart';
import 'package:social_media_chat_flutter/widgets/custom_email_text_field.dart';
import 'package:social_media_chat_flutter/widgets/custom_password_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  static const String route = "/sign_up_screen";

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  late final FocusNode _usernameFocusNode;
  late final FocusNode _passwordFocusNode;

  late CustomEmailTextField emailField;
  late CustomPasswordTextField passField;

  String _username = "";

  @override
  void initState() {
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    emailField = CustomEmailTextField(
      nextNode: _usernameFocusNode,
    );

    passField = CustomPasswordTextField(
      focusNode: _passwordFocusNode,
      onSubmit: _submit,
    );
    super.initState();
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
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

    context.read<AuthCubit>().signUpWithEmail(
          username: _username,
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

              if (state is AuthSignedUp) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        "E-mail verification ling has been sent,\nverify your email and login"),
                    duration: Duration(seconds: 5),
                  ),
                );
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return UIK.loading;
              }
              return ListView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(15),
                children: [
                  // email
                  emailField,
                  // user name
                  TextFormField(
                    decoration: UIK.kAuthTextFieldDecoration
                        .copyWith(labelText: "Username"),
                    focusNode: _usernameFocusNode,
                    textInputAction: TextInputAction.next,
                    onSaved: (newValue) => _username = newValue!,
                    onFieldSubmitted: (value) =>
                        FocusScope.of(context).requestFocus(_passwordFocusNode),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide username";
                      }

                      if (value.length < 2) {
                        return "Username is to short";
                      }

                      return null;
                    },
                  ),
                  // password
                  passField,

                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      _submit(context);
                    },
                    child: const Text("Sign up"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Sign in instead"),
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
