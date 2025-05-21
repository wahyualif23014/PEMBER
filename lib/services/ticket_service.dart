import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:absolute_cinema/models/ticket_model.dart';

class TicketService {
  List<Ticket> tickets = [];

  final String baseUrl = 'http://localhost:3000';

  Future<void> fetchTickets() async {

    try {
      final res = await http.get(Uri.parse('$baseUrl/tickets'));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'];
        tickets = (data as List).map((e) => Ticket.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("❌ Failed to fetch tickets: $e");
    }
  }

  Future<void> fetchTicketsByUserId(String userId) async {
    print("enter this function");
    try {
      final res = await http.get(Uri.parse('$baseUrl/users/$userId/tickets'));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'];

        print(data);
        tickets = (data as List).map((e) => Ticket.fromJson(e)).toList();
      } else {
        print("❌ Failed to fetch tickets for user $userId: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ Failed to fetch tickets for user $userId: $e");
    }
  }

  Future<void> deleteTicket(String id) async {
    try {
      await http.delete(Uri.parse('$baseUrl/tickets/$id'));
      await fetchTickets(); // reload manual
    } catch (e) {
      debugPrint("❌ Failed to delete ticket: $e");
    }
  }

  Future<void> addTicketToServer(Ticket ticket, String userId) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/tickets'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(ticket.toJson(userId: userId)),
      );

      if (res.statusCode == 201) {
        await fetchTickets();
      }
    } catch (e) {
      debugPrint("❌ Failed to add ticket: $e");
    }
  }

  Future<void> updateTicketOnServer(Ticket updated) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/tickets/${updated.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updated.toJson(userId: "ignored")),
      );

      if (res.statusCode == 200) {
        await fetchTickets();
      }
    } catch (e) {
      debugPrint("❌ Failed to update ticket: $e");
    }
  }

  Future<List<String>> fetchAllSeats() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/seats'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'] as List<dynamic>;
        return data.map((e) => e['seat_label'].toString()).toList();
      }
    } catch (e) {
      debugPrint("❌ Failed to fetch seats: $e");
    }
    return [];
  }

  Future<List<String>> fetchBookedSeatsByTitleAndTime(
    String title,
    String time,
  ) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/tickets/booked?title=$title&show_time=$time'),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'] as List<dynamic>;
        return data.map((e) => e['seat_label'].toString()).toList();
      }
    } catch (e) {
      debugPrint("❌ Failed to fetch booked seats: $e");
    }
    return [];
  }
}
