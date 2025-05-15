import 'package:absolute_cinema/models/movie_model.dart';

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
}
