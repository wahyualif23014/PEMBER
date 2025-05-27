import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:absolute_cinema/widgets/connection_status_widget.dart';

class ConnectionOverlayWrapper extends StatefulWidget {
  final Widget child;

  const ConnectionOverlayWrapper({super.key, required this.child});

  @override
  State<ConnectionOverlayWrapper> createState() =>
      _ConnectionOverlayWrapperState();
}

class _ConnectionOverlayWrapperState extends State<ConnectionOverlayWrapper> {
  bool _hasConnection = true;
  late StreamSubscription<InternetStatus> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = InternetConnection().onStatusChange.listen((status) {
      if (!mounted) return;
      setState(() {
        _hasConnection = status == InternetStatus.connected;
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _retryConnection() async {
    bool connected = await InternetConnection().hasInternetAccess;
    if (mounted) {
      setState(() {
        _hasConnection = connected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (!_hasConnection)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.8),
              child: ConnectionStatusWidget(onConnected: _retryConnection),
            ),
          ),
      ],
    );
  }
}
