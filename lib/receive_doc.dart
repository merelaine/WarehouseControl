import 'package:flutter/material.dart';
import 'package:warehousecontrol/data/db_helper.dart';
import 'package:warehousecontrol/models/contract.dart';
import 'package:warehousecontrol/models/provider.dart';
import 'package:warehousecontrol/models/warehouse.dart';

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
            DataTable(
              columns: [
                DataColumn(label: Text('Item')),
                DataColumn(label: Text('Quantity')),
                DataColumn(label: Text('Actions')),
              ],
              rows: items.map((item) {
                int index = items.indexOf(item);
                return DataRow(cells: [
                  DataCell(Text(item['item'])),
                  DataCell(Text(item['quantity'])),
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
            TextField(
              controller: itemController,
              decoration: InputDecoration(labelText: 'Item'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addItem();
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}