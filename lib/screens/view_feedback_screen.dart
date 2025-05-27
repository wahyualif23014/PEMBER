import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/feedback_model.dart';
import '../services/feedback_service.dart';
import 'feedback_screen.dart';

class ViewFeedbackScreen extends StatefulWidget {
  const ViewFeedbackScreen({super.key});

  @override
  State<ViewFeedbackScreen> createState() => _ViewFeedbackScreenState();
}

class _ViewFeedbackScreenState extends State<ViewFeedbackScreen> {
  List<FeedbackModel> feedbackList = [];
  bool isLoading = true;
  String? error;
  final Map<String, String> userNames = {}; // Cache for UID to name

  @override
  void initState() {
    super.initState();
    fetchFeedback();
  }

  Future<void> fetchFeedback() async {
    try {
      final data = await FeedbackService.getAllFeedback();
      setState(() {
        feedbackList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<String> getUserName(String uid) async {
    if (userNames.containsKey(uid)) return userNames[uid]!;

    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final name = userDoc.data()?['username'] ?? uid;
      userNames[uid] = name;
      return name;
    } catch (e) {
      return uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Colors.black;
    final cardColor = const Color(0xFF1C1C1E);
    final accentColor = Colors.amber[700]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('View Feedback'),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : error != null
              ? Center(
                child: Text(
                  '❌ $error',
                  style: const TextStyle(color: Colors.red),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: feedbackList.length,
                itemBuilder: (context, index) {
                  final item = feedbackList[index];
                  final controller = PageController();

                  return FutureBuilder<String>(
                    future: getUserName(item.userId),
                    builder: (context, snapshot) {
                      final name = snapshot.data ?? item.userId;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.amber,
                                  child: Text(
                                    name.isNotEmpty
                                        ? name[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "User: $name",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item.image,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SmoothPageIndicator(
                              controller: controller,
                              count: 1,
                              effect: ExpandingDotsEffect(
                                activeDotColor: accentColor,
                                dotColor: Colors.white24,
                                dotHeight: 8,
                                dotWidth: 8,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Colors.white60,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      item.createdAt.toLocal().toString().split(
                                        ' ',
                                      )[0],
                                      style: const TextStyle(
                                        color: Colors.white60,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(width: 6),
                                    SizedBox(
                                      width: 140,
                                      child: Text(
                                        item.location,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(color: Colors.white24, height: 24),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: accentColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item.desctiption,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '⭐ ${item.rating}',
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FeedbackScreen()),
          );

          if (result == true) {
            await fetchFeedback();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Feedback"),
        backgroundColor: accentColor,
      ),
    );
  }
}
