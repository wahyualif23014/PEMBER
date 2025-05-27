import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'feedback_screen.dart';

class ViewFeedbackScreen extends StatelessWidget {
  const ViewFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.black;
    final Color cardColor = const Color(0xFF1C1C1E);
    final Color accentColor = Colors.amber[700]!;

    final List<Map<String, dynamic>> dummyFeedback = [
      {
        'name': 'Dewa Arya',
        'date': '25 Mei 2025',
        'location': 'Pantai Batu Bolong, Bali',
        'title': 'Tempat Healing Terbaik',
        'content':
            'Pantainya sangat indah dan suasananya tenang. Cocok untuk melepas penat dan menikmati sunset.',
        'rating': '★★★★★',
        'images': [
          'https://images.unsplash.com/photo-1572240046450-775a7ef69386?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D,1',
          'https://images.unsplash.com/photo-1572240046450-775a7ef69386?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D2',
        ],
      },
      {
        'name': 'Ayu Lestari',
        'date': '24 Mei 2025',
        'location': 'Pantai Batu Bolong, Bali',
        'title': 'Spot Foto Keren',
        'content':
            'Banyak spot bagus buat foto. Tempat bersih dan terawat. Sangat Instagramable!',
        'rating': '★★★★☆',
        'images': [
          'https://images.unsplash.com/photo-1657690230087-7ad267699528?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D,3',
          'https://images.unsplash.com/photo-1657690230087-7ad267699528?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D,4',
        ],
      },
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('View Feedback'),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyFeedback.length,
        itemBuilder: (context, index) {
          final item = dummyFeedback[index];
          final PageController controller = PageController();

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Avatar dan Nama di Tengah
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.person, color: Colors.black, size: 30),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Carousel Gambar
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 180,
                    child: PageView.builder(
                      controller: controller,
                      itemCount: item['images'].length,
                      itemBuilder: (context, i) {
                        return Image.network(
                          item['images'][i],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SmoothPageIndicator(
                  controller: controller,
                  count: item['images'].length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: accentColor,
                    dotColor: Colors.white24,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
                const SizedBox(height: 16),

                // Tanggal & Lokasi
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
                          item['date'],
                          style: const TextStyle(color: Colors.white60),
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
                        Text(
                          item['location'],
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, height: 24),

                // Judul
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Isi Feedback
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item['content'],
                    style: const TextStyle(color: Colors.white70, height: 1.5),
                  ),
                ),

                // Rating
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    item['rating'],
                    style: TextStyle(color: accentColor, fontSize: 18),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FeedbackScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Feedback"),
        backgroundColor: accentColor,
      ),
    );
  }
}
