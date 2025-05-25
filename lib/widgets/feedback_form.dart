import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  double _rating = 3.0;
  late AnimationController _animController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = Colors.white;
    final Color fieldColor = const Color(0xFF2C2C2E);
    final Color accentColor = Colors.amber[700]!;

    return FadeTransition(
      opacity: _fadeIn,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🎞️ Lottie animation
          Center(
            child: SizedBox(
              height: 200,
              child: Lottie.network(
                'https://lottie.host/e29f12b9-a29a-452a-a327-1c57185061bf/HSXGvkO0Im.json',
                repeat: true,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 🌟 Bintang Penilaian
          Text(
            "give an assessment",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),

          Center(
            child: RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              unratedColor: Colors.grey[600],
              itemCount: 5,
              itemSize: 36,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(Icons.star, color: accentColor),
              onRatingUpdate: (rating) {
                setState(() => _rating = rating);
              },
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              _rating.toStringAsFixed(1),
              style: TextStyle(color: Colors.white70),
            ),
          ),

          const SizedBox(height: 24),

          // 📝 Tulis Feedback
          Text(
            "give your feedback",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),

          TextField(
            controller: _controller,
            maxLines: 4,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'enter your experience',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: fieldColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
        ],
      ),
    );
  }
}
