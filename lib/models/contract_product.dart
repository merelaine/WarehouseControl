class ContractProduct {
  final int id;
  final int contractId;
  final int productId;
  final double price;

  ContractProduct({required this.id, required this.contractId, required this.productId, required this.price});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contract_id': contractId,
      'product_id': productId,
      'price': price,
    };
  }
}