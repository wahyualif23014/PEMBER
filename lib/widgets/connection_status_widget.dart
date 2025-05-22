import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';  // jangan lupa add lottie di pubspec.yaml
import 'package:absolute_cinema/services/ConnectionService.dart';

class ConnectionStatusWidget extends StatefulWidget {
  final VoidCallback onConnected;

  const ConnectionStatusWidget({Key? key, required this.onConnected}) : super(key: key);

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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No internet connection. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ganti path ini dengan file Lottie animasi offline kamu
          Lottie.network('https://lottie.host/9b3fb559-858d-4dbb-9e00-54b0aa38e81e/hi9cNEBLpi.json', width: 200, height: 200, repeat: true),
          SizedBox(height: 20),
          _isChecking
              ? CircularProgressIndicator()
              : ElevatedButton.icon(
                  onPressed: _checkConnection,
                  icon: Icon(Icons.refresh),
                  label: Text('Refresh'),
                ),
        ],
      ),
    );
  }
}
