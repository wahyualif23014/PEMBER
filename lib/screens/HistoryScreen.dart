import 'package:absolute_cinema/widgets/PurchaseCard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/ticket_service.dart';
import '../models/ticket_log_model.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  List<TicketLog> ticketLogs = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    loadTicketLogs();
  }

  Future<void> loadTicketLogs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      return;
    }

    try {
      final logs = await TicketService().fetchTicketLogsByUserId(user.uid);
      setState(() {
        ticketLogs = logs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Purchase History",
          style: TextStyle(color: Colors.amber),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              )
              : hasError
              ? const Center(
                child: Text(
                  "Gagal memuat data riwayat.",
                  style: TextStyle(color: Colors.redAccent),
                ),
              )
              : ticketLogs.isEmpty
              ? const Center(
                child: Text(
                  "Belum ada riwayat pembelian.",
                  style: TextStyle(color: Colors.white70),
                ),
              )
              : RefreshIndicator(
                onRefresh: loadTicketLogs,
                color: Colors.amber,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: ticketLogs.length,
                  itemBuilder: (context, index) {
                    return PurchaseCard(data: ticketLogs[index], index: index);
                  },
                ),
              ),
    );
  }
}
