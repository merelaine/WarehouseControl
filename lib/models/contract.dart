class Contract {
  final int id;
  final String name;
  final int providerId;

  Contract({required this.id, required this.name, required this.providerId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'provider_id': providerId,
    };
  }

}