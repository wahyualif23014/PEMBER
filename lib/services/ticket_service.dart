import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:absolute_cinema/models/ticket_model.dart';
import 'notification_service.dart';

class TicketService {
  List<Ticket> tickets = [];
  final String baseUrl = 'https://pember-api-eta.vercel.app';

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
    try {
      final res = await http.get(Uri.parse('$baseUrl/users/$userId/tickets'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'];
        tickets = (data as List).map((e) => Ticket.fromJson(e)).toList();
      } else {
        debugPrint("❌ Failed: ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      debugPrint("❌ Failed to fetch tickets for user $userId: $e");
    }
  }

  Future<void> deleteTicket(String id) async {
    try {
      await http.delete(Uri.parse('$baseUrl/tickets/$id'));
      await fetchTickets();
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
        await NotificationService.awesome_notifications(
          title: 'Booking Berhasil',
          body: 'Tiket berhasil dipesan!',
        );
      } else {
        final msg = jsonDecode(res.body)['message'] ?? "Unknown error";
        debugPrint("❌ Failed to add ticket: $msg");
        throw Exception(msg);
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
      } else {
        final msg = jsonDecode(res.body)['message'] ?? "Unknown error";
        debugPrint("❌ Failed to update ticket: $msg");
        throw Exception(msg);
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
        return data.map((e) => e['seatLabel'].toString()).toList();
      }
    } catch (e) {
      debugPrint("❌ Failed to fetch seats: $e");
    }
    return [];
  }

  Future<List<String>> fetchBookedSeatsByTitleAndTime(
    String title,
    DateTime time, {
    String? excludeTicketId,
  }) async {
    final uri = Uri.parse('$baseUrl/tickets/booked').replace(
      queryParameters: {
        'title': title,
        'show_time':
            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
        if (excludeTicketId != null) 'exclude': excludeTicketId,
      },
    );

    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'] as List<dynamic>;

        final seats =
            data.map((e) => e.toString()).toList(); // Fix if data = [A1, A2]
        print("📌 Booked seats fetched: $seats");

        return seats;
      }
    } catch (e) {
      debugPrint("❌ Failed to fetch booked seats: $e");
    }

    return [];
  }
}
