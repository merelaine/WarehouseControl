import 'package:flutter/material.dart';
import 'package:warehousecontrol/data/db_helper.dart';
import 'package:warehousecontrol/models/product.dart';

class ProductListPage extends StatefulWidget {
  final int selectedContractId;

  ProductListPage({required this.selectedContractId});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late List<Map<String, dynamic>> productsWithPrices = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    List<Map<String, dynamic>> productList = await DatabaseHelper.getProductsWithPricesByContractId(widget.selectedContractId);

    print('Fetched products: $productList');

    setState(() {
      productsWithPrices = productList;
    });
  }

  void addItem(Map<String, dynamic> product) {
    // Add the selected product to the list
  }

  @override
  Widget build(BuildContext context) {
    print('Building with ${productsWithPrices.length} products');

    return Scaffold(
      appBar: AppBar(
        title: Text('Список товаров'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productsWithPrices.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(productsWithPrices[index]['name']),
                  subtitle: Text('\$${productsWithPrices[index]['price'].toStringAsFixed(2)}'),
                  onTap: () {
                    addItem(productsWithPrices[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}