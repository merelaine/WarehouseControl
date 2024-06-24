import 'package:flutter/material.dart';
import 'package:warehousecontrol/data/db_helper.dart';
import 'models/warehouse.dart';
import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WarehouseSelectionPage extends StatefulWidget {
  @override
  _WarehouseSelectionPageState createState() => _WarehouseSelectionPageState();
}

class _WarehouseSelectionPageState extends State<WarehouseSelectionPage> {
  late Future<List<Warehouse>> warehouseList;

  Future<void> saveSelectedWarehouse(Warehouse warehouse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedWarehouseId', warehouse.id);
  }

  @override
  void initState() {
    super.initState();
    warehouseList = DatabaseHelper.getWarehouses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выберите склад '),
      ),
      body: FutureBuilder<List<Warehouse>>(
        future: warehouseList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Произошла ошибка: ${snapshot.error}'));
          } else {
            List<Warehouse> warehouses = snapshot.data!;
            return ListView.builder(
              itemCount: warehouses.length,
              itemBuilder: (context, index) {
                Warehouse warehouse = warehouses[index];
                return ListTile(
                  title: Text(warehouse.name),
                  subtitle: Text(warehouse.address),
                  onTap: () async {
                    await saveSelectedWarehouse(warehouse);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}