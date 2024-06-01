import 'package:flutter/material.dart';
import 'package:warehousecontrol/data/db_helper.dart';
import 'package:warehousecontrol/models/contract.dart';
import 'package:warehousecontrol/models/provider.dart';
import 'package:warehousecontrol/models/warehouse.dart';
import 'package:warehousecontrol/product_select.dart';
import 'package:warehousecontrol/models/product.dart';

class ReceiveDocumentPage extends StatefulWidget {
  final int selectedProviderId;
  final int selectedWarehouseId;
  final int selectedContractId;

  ReceiveDocumentPage({required this.selectedProviderId, required this.selectedWarehouseId, required this.selectedContractId});

  @override
  _ReceiveDocumentPageState createState() => _ReceiveDocumentPageState();
}

class _ReceiveDocumentPageState extends State<ReceiveDocumentPage> {
  late String warehouseName;
  late String providerName = '';
  late String contractName = '';
  late DateTime dateTime = DateTime.now();
  late List<Map<String, dynamic>> items = [];
  late TextEditingController itemController;
  late TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    itemController = TextEditingController();
    quantityController = TextEditingController();
    fetchWarehouseName();
    fetchProviderAndContractInfo();
  }

  @override
  void dispose() {
    itemController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  Future<void> fetchWarehouseName() async {
    Warehouse warehouse = await DatabaseHelper.getWarehouseById(widget.selectedWarehouseId);
    setState(() {
      warehouseName = warehouse.name;
    });
  }

  Future<void> fetchProviderAndContractInfo() async {
    List<Provider> providers = await DatabaseHelper.getProviders();
    Provider selectedProvider = providers.firstWhere((provider) => provider.id == widget.selectedProviderId);
    setState(() {
      providerName = selectedProvider.name;
    });

    List<Contract> contracts = await DatabaseHelper.getContracts(widget.selectedProviderId);
    Contract selectedContract = contracts.firstWhere((contract) => contract.id == widget.selectedContractId);
    setState(() {
      contractName = selectedContract.name;
    });
  }

  Future<void> saveReceiveDocument() async {
    // Save receive document to database
  }

  void addItem() {
    setState(() {
      items.add({
        'item': itemController.text,
        'quantity': quantityController.text,
      });
      itemController.clear();
      quantityController.clear();
    });
  }

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void addProductToDocument(Product product, String quantity, double price) {
    setState(() {
      items.add({
        'product': product,
        'quantity': quantity,
        'price': price,
      });
      quantityController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Документ поступления'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Номер: ${DateTime.now().millisecondsSinceEpoch}'),
            Text('Дата: ${dateTime.toString()}'),
            Text('Склад: $warehouseName'),
            Text('Поставщик: $providerName'),
            Text('Договор: $contractName'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductListPage(selectedContractId: widget.selectedContractId),
                  ),
                ).then((selectedProduct) {
                  if (selectedProduct != null) {
                    double price = selectedProduct['price'];
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String quantity = '';
                        return AlertDialog(
                          title: Text('Введите количество'),
                          content: TextField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Количество'),
                            onChanged: (value) {
                              quantity = value;
                            },
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                addProductToDocument(selectedProduct, quantity, price); // Add selected product to the document with quantity and price
                                Navigator.pop(context);
                              },
                              child: Text('Добавить'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                });},
              child: Text('Добавить товар'),
            ),
            SizedBox(height: 20),
            DataTable(
              columns: [
                DataColumn(label: Text('Item')),
                DataColumn(label: Text('Quantity')),
                DataColumn(label: Text('Actions')),
              ],
              rows: items.asMap().entries.map((entry) {
                int index = entry.key;
                var item = entry.value;
                return DataRow(cells: [
                  DataCell(Text(item['product']['name'].toString())),
                  DataCell(Text(item['quantity'].toString())),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => removeItem(index),
                    ),
                  ),
                ]);
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                saveReceiveDocument();
              },
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}