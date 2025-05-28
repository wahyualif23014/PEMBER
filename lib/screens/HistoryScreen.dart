import 'package:flutter/material.dart';
import '../widgets/PurchaseCard.dart';
import '../dummy_data/dummy_purchase_data.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

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
      body: dummyPurchaseHistory.isEmpty
          ? const Center(
              child: Text(
                "Belum ada riwayat pembelian.",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: dummyPurchaseHistory.length,
              itemBuilder: (context, index) {
                return PurchaseCard(data: dummyPurchaseHistory[index]);
              },
            ),
    );
  }
}
