class InSaleItem {
  final String vegetableName;
  final bool isOnSale;
  final int quantity;
  final DateTime timestamp;
  final DateTime collectionDate;
  final String email;
  final String username;

  InSaleItem({
    required this.vegetableName,
    required this.isOnSale,
    required this.quantity,
    required this.timestamp,
    required this.collectionDate,
    required this.email,
    required this.username,
  });

  // Add a factory constructor to convert Firestore data to the model
  factory InSaleItem.fromFirestore(Map<String, dynamic> data) {
    return InSaleItem(
      vegetableName: data['vegetable_name'],
      isOnSale: data['isOnSale'],
      quantity: data['quantity'],
      timestamp: data['timestamp'].toDate(),
      collectionDate: data['collection_date'].toDate(),
      email: data['email'],
      username: data['username'],
    );
  }
}
