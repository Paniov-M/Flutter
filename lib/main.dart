import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hello, World!'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              signInWithGoogle(context);
            },
            child: Text('Sign In with Google'),
          ),
        ),
      ),
    );
  }

  void signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        clientId: '908582655922-dldr6rb6e3hp98fc2n2fh68argtpemac.apps.googleusercontent.com',
      );
      GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account != null) {
        print('Google Sign In successful!');
        print('User ID: ${account.id}');
        print('User Name: ${account.displayName}');
        print('User Email: ${account.email}');
        showSignInSuccessToast();

        // Передача інформації про авторизованого користувача в базу даних
        Authorization(account.id, account.email, account.displayName ?? 'Default Name', 'your_token');

      } else {
        print('Google Sign In failed!');
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  void showSignInSuccessToast() {
    Fluttertoast.showToast(
      msg: 'Ви увійшли у систему',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void Authorization(String userId, String email, String name, String token) {
  print('Saving user data to database...');

  // Перевірка, чи електронна пошта закінчується на "nuwm.edu.ua"
  if (email.endsWith('@nuwm.edu.ua')) 
  {
    print('Успішна авторизація!');
  } 
  else {
    print('Неуспішна авторизація-> неправильний домен електронної пошти.');
  }
}

}
