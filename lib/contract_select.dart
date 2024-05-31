import 'package:flutter/material.dart';
import 'package:warehousecontrol/data/db_helper.dart';
import 'package:warehousecontrol/receive_doc.dart';
import 'models/contract.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContractSelectionPage extends StatefulWidget {
  final int selectedProviderId;

  ContractSelectionPage({required this.selectedProviderId});

  @override
  _ContractSelectionPageState createState() => _ContractSelectionPageState();
}

class _ContractSelectionPageState extends State<ContractSelectionPage> {
  late Future<List<Contract>> contractList;

  Future<void> saveSelectedContract(Contract contract) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedContractId', contract.id);
  }

  @override
  void initState() {
    super.initState();
    contractList = DatabaseHelper.getContracts(widget.selectedProviderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выберете договор'),
      ),
      body: FutureBuilder<List<Contract>>(
        future: contractList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          } else {
            List<Contract> contracts = snapshot.data!;
            return ListView.builder(
              itemCount: contracts.length,
              itemBuilder: (context, index) {
                Contract contract = contracts[index];
                return ListTile(
                  title: Text(contract.name),
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    int selectedWarehouseId = prefs.getInt('selectedWarehouseId') ?? 0;
                    await saveSelectedContract(contract);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReceiveDocumentPage(
                          selectedProviderId: widget.selectedProviderId,
                          selectedWarehouseId: selectedWarehouseId,
                          selectedContractId: contract.id,
                        ),
                      ),
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