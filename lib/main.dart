import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:social_media_chat_flutter/bloc/auth_cubit/auth_cubit.dart';
import 'package:social_media_chat_flutter/screens/chat_Screen.dart';
import 'package:social_media_chat_flutter/screens/create_post_screen.dart';
import 'package:social_media_chat_flutter/screens/posts_screen.dart';
import 'package:social_media_chat_flutter/screens/sign_in_screen.dart';
import 'package:social_media_chat_flutter/screens/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // initialize crashlytics
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://example@sentry.io/add-your-dsn-here';
    },
    // Init your App.
    appRunner: () => runApp(const MyApp()),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // check auth state
  Widget _buildHomeScreen() {
    return StreamBuilder<User?>(
      stream: AuthCubit.streamAuth,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.emailVerified) {
            return const PostScreen();
          }
        }
        return const SignInScreen();
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: _buildHomeScreen(),
        routes: {
          SignInScreen.route: (context) => const SignInScreen(),
          SignUpScreen.route: (context) => const SignUpScreen(),
          PostScreen.route: (context) => const PostScreen(),
          CreatePostScreen.route: (context) => const CreatePostScreen(),
          ChatScreen.route: (context) => ChatScreen(),
        },
      ),
    );
  }
}
