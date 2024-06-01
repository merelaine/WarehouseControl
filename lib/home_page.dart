import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehousecontrol/models/warehouse.dart';
import 'package:warehousecontrol/data/db_helper.dart';
import 'package:warehousecontrol/provider_select.dart';
import 'order_page.dart';

class HomePage extends StatelessWidget {
  Future<String> getSelectedWarehouseName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int selectedWarehouseId = prefs.getInt('selectedWarehouseId') ?? 0;

    List<Warehouse> warehouses = await DatabaseHelper.getWarehouses();
    Warehouse selectedWarehouse = warehouses.firstWhere((warehouse) => warehouse.id == selectedWarehouseId, orElse: () => Warehouse(id: 0, name: 'Default Warehouse', address: 'Default Address'));

    return selectedWarehouse.name;
  }

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
              MaterialPageRoute(builder: (context) => ProviderSelectionPage()),
            );
          }),
          _buildMenuItem(context, 'Сборка заказов', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderPage()),
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