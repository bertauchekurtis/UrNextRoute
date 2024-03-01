import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:ur_next_route/main.dart';

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

void debugSign() {
  if (FirebaseAuth.instance.currentUser != null) {
    //print("Signed in");
  } else {
    //print("Signed out");
  }
}

void signInProcess(context, appState) async {
  await signInWithGoogle();
  if (FirebaseAuth.instance.currentUser != null) {
    appState.getPins();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MyHomePage()));
  } else {
    // do nothing for now
  }
}

void checkUserAndPush(context) {
  if (FirebaseAuth.instance.currentUser != null) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MyHomePage()));
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => checkUserAndPush(context));
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      body: Center(
        child: SizedBox.expand(
          child: Container(
            color: const Color.fromARGB(255, 4, 30, 66),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/appstore.png',
                  height: 400,
                  width: 400,
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () =>
                        {debugSign(), signInProcess(context, appState)},
                    child: const Text("Sign in with Google")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
