import 'package:flutter/material.dart';
import 'package:warehousecontrol/data/db_helper.dart';
import 'package:warehousecontrol/shipping_page.dart';
import 'models/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderSelectionPage extends StatefulWidget {
  @override
  _ProviderSelectionPageState createState() => _ProviderSelectionPageState();
}

class _ProviderSelectionPageState extends State<ProviderSelectionPage> {
  late Future<List<Provider>> providerList;

  Future<void> saveSelectedProvider(Provider provider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedProviderId', provider.id);
  }

  @override
  void initState() {
    super.initState();
    providerList = DatabaseHelper.getProviders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выберите поставщика'),
      ),
      body: FutureBuilder<List<Provider>>(
        future: providerList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Произошла ошибка: ${snapshot.error}'));
          } else {
            List<Provider> providers = snapshot.data!;
            return ListView.builder(
              itemCount: providers.length,
              itemBuilder: (context, index) {
                Provider provider = providers[index];
                return ListTile(
                  title: Text(provider.name),
                  onTap: () async {
                    await saveSelectedProvider(provider);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ShippingPage()),
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