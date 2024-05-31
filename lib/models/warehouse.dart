class Warehouse {
  final int id;
  final String name;
  final String address;

  Warehouse({required this.id, required this.name, required this.address});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
    };
  }
}