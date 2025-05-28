// widgets/StatusChip.dart
import 'package:flutter/material.dart';

class StatusChip extends StatefulWidget {
  final String status;

  const StatusChip({Key? key, required this.status}) : super(key: key);

  @override
  _StatusChipState createState() => _StatusChipState();
}

class _StatusChipState extends State<StatusChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Only pulse for active statuses
    if (_isActiveStatus()) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  bool _isActiveStatus() {
    return widget.status.toLowerCase() == 'active' || 
           widget.status.toLowerCase() == 'confirmed' ||
           widget.status.toLowerCase() == 'processing';
  }

  Color _getStatusColor() {
    switch (widget.status.toLowerCase()) {
      case 'confirmed':
      case 'success':
      case 'completed':
        return Colors.green;
      case 'pending':
      case 'processing':
        return Colors.amberAccent;
      case 'cancelled':
      case 'failed':
        return Colors.red;
      case 'refunded':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (widget.status.toLowerCase()) {
      case 'confirmed':
      case 'success':
      case 'completed':
        return Icons.check_circle;
      case 'pending':
      case 'processing':
        return Icons.schedule;
      case 'cancelled':
      case 'failed':
        return Icons.cancel;
      case 'refunded':
        return Icons.replay;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final statusIcon = _getStatusIcon();

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: statusColor.withOpacity(_isActiveStatus() ? _pulseAnimation.value : 0.5),
              width: 1.5,
            ),
            boxShadow: _isActiveStatus() ? [
              BoxShadow(
                color: statusColor.withOpacity(_pulseAnimation.value * 0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ] : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                statusIcon,
                color: statusColor,
                size: 14,
              ),
              SizedBox(width: 6),
              Text(
                widget.status.toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}