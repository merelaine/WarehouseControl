import 'package:flutter/material.dart';
import 'models/user.dart';
import 'data/db_helper.dart';
import 'warehouse_select.dart';

class LoginPage extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void login(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;

    bool isAuthenticated = await DatabaseHelper().authenticateUser(username, password);

    if (isAuthenticated) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WarehouseSelectionPage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ошибка'),
            content: Text('Неправильное имя пользователя или пароль.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('ОК'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Вход'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Имя пользователя'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                login(context);
              },
              child: Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}