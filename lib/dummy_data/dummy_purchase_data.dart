import '../models/purchase_history.dart';

final List<PurchaseHistoryModel> dummyPurchaseHistory = [
  PurchaseHistoryModel(
    id: 'TCK12345',
    movieTitle: 'Inception',
    dateTime: DateTime(2025, 5, 29, 19, 30),
    seats: ['C5', 'C6'],
    totalPrice: 100000,
    status: 'Sukses',
  ),
  PurchaseHistoryModel(
    id: 'TCK67890',
    movieTitle: 'Oppenheimer',
    dateTime: DateTime(2025, 4, 22, 20, 0),
    seats: ['D2'],
    totalPrice: 50000,
    status: 'Dibatalkan',
  ),
];
