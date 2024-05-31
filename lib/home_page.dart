import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Складские операции'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          _buildMenuItem(context, 'Поступление', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReceivingPage()),
            );
          }),
          _buildMenuItem(context, 'Отгрузка', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShippingPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}