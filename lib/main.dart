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
      title: 'Your App Title',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  void signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        clientId: '908582655922-dldr6rb6e3hp98fc2n2fh68argtpemac.apps.googleusercontent.com',
      );
      GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account != null) {
        print('Google Sign In successful!');
        print('User ID: ${account.id}');
        print('User Name: ${account.displayName}');
        print('User Email: ${account.email}');
        print('User Photo URL: ${account.photoUrl}');
        showSignInSuccessToast();

        // Передача інформації про авторизованого користувача в базу даних
        Authorization(account.id, account.email, account.displayName ?? 'Default Name', account.photoUrl ?? '', 'your_token', context);
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

  void Authorization(String userId, String email, String name, String photoUrl, String token, BuildContext context) {
    print('Saving user data to database...');

    // Перевірка, чи електронна пошта закінчується на "nuwm.edu.ua"
    if (email.endsWith('@nuwm.edu.ua')) {
      print('Успішна авторизація!');
      print('User Photo URL: $photoUrl');

      // Виведення фото на екран
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Image.network(photoUrl),
          );
        },
      );
    } else {
      print('Неуспішна авторизація. Неправильний домен електронної пошти.');
    }
  }
}
