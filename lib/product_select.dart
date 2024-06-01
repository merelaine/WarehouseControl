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
  late List<Product> productsWithPrices = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    print(widget.selectedContractId);
    List<Product> productList = await DatabaseHelper.getProductsWithPricesByContractId(widget.selectedContractId);

    print('Fetched products: $productList');

    setState(() {
      productsWithPrices = productList;
    });
  }

  void addItem(Product product) {
    Navigator.pop(context, product);
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
                  title: Text(productsWithPrices[index].name),
                  subtitle: Text('\$${productsWithPrices[index].price.toStringAsFixed(2)}'),
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