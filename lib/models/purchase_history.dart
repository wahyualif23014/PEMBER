class PurchaseHistoryModel {
  final String id;
  final String movieTitle;
  final DateTime dateTime;
  final List<String> seats;
  final double totalPrice;
  final String status;

  PurchaseHistoryModel({
    required this.id,
    required this.movieTitle,
    required this.dateTime,
    required this.seats,
    required this.totalPrice,
    required this.status,
  });
}
