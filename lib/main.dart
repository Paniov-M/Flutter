import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql1/mysql1.dart' as mysql;

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

        // Підключення до бази даних
        final settings = mysql.ConnectionSettings(
          host: '127.0.0.1',
          port: 3306,
          user: 'root',
          db: 'authorization',
          password: 'your_password',
        );

        try {
          final connection = await mysql.MySqlConnection.connect(settings);

          // Збереження інформації про авторизованого користувача в базу даних

          await connection.query(
            'INSERT INTO users (user_id, email, name, token) VALUES (?, ?, ?)',
            [account.id, 'your_email', 'your_token'],
          );
          await connection.close();
        } catch (e) {
          print('Error connecting to database: $e');
        }
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
}
