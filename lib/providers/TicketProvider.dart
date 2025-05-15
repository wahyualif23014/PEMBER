// lib/providers/ticket_provider.dart
import 'package:flutter/foundation.dart';
import '../models/ticket_model.dart';

class TicketProvider with ChangeNotifier {
  final List<Ticket> _tickets = [];

  List<Ticket> get tickets => _tickets;

  void addTicket(Ticket ticket) {
    _tickets.add(ticket);
    notifyListeners();
  }

  void updateTicket(Ticket updatedTicket) {
    final index = _tickets.indexWhere((t) => t.id == updatedTicket.id);
    if (index != -1) {
      _tickets[index] = updatedTicket;
      notifyListeners();
    }
  }

  void deleteTicket(String ticketId) {
    _tickets.removeWhere((t) => t.id == ticketId);
    notifyListeners();
  }
}