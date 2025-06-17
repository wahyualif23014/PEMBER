class TicketLog {
  final String movieTitle;
  final String showTime;
  final List<String> seats;
  final int total;
  final String status;

  TicketLog({
    required this.movieTitle,
    required this.showTime,
    required this.seats,
    required this.total,
    required this.status,
  });

  factory TicketLog.fromJson(Map<String, dynamic> json) {
    return TicketLog(
      movieTitle: json['movie_title'],
      showTime: json['show_time'],
      seats: List<String>.from(json['seats']),
      total: json['total'],
      status: json['status'],
    );
  }
}
