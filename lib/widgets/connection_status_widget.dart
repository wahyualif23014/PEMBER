import 'package:flutter/material.dart';
import 'package:absolute_cinema/services/ConnectionService.dart';

class ConnectionStatusWidget extends StatefulWidget {
  final VoidCallback onConnected;

  const ConnectionStatusWidget({Key? key, required this.onConnected})
    : super(key: key);

  @override
  State<ConnectionStatusWidget> createState() => _ConnectionStatusWidgetState();
}

class _ConnectionStatusWidgetState extends State<ConnectionStatusWidget> {
  bool _isChecking = false;

  Future<void> _checkConnection() async {
    setState(() {
      _isChecking = true;
    });

    bool isConnected = await ConnectionService.checkConnection();

    setState(() {
      _isChecking = false;
    });

    if (isConnected) {
      widget.onConnected();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 100, color: Colors.white54),
          const SizedBox(height: 20),
          const Text(
            'No Internet Connection',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Please check your connection and try again.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 30),
          _isChecking
              ? const CircularProgressIndicator(color: Colors.amber)
              : ElevatedButton.icon(
                onPressed: _checkConnection,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
