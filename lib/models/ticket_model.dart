import 'movie_model.dart';

class Ticket {
  final String id;
  final Movie movie;
  final List<String> seats;
  final String showtime;
  final int totalPrice;

  Ticket({
    required this.id,
    required this.movie,
    required this.seats,
    required this.showtime,
    required this.totalPrice,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['ticket_id'].toString(),
      movie: Movie.basic(json['movie_title']),
      seats: (json['seats'] as String).split(','),
      showtime: json['show_time'],
      totalPrice: json['price'],
    );
  }

  Map<String, dynamic> toJson({required String userId}) {
    return {
      'user_id': userId,
      'movie_title': movie.title,
      'seats': seats,
      'show_time': showtime,
      'price': totalPrice,
    };
  }
}
