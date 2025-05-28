// widgets/purchase_card.dart
import 'package:flutter/material.dart';
import '../models/purchase_history.dart';
import 'StatusChip.dart';
import 'package:intl/intl.dart';

class PurchaseCard extends StatefulWidget {
  final PurchaseHistoryModel data;
  final int index;

  const PurchaseCard({
    Key? key,
    required this.data,
    this.index = 0,
  }) : super(key: key);

  @override
  _PurchaseCardState createState() => _PurchaseCardState();
}

class _PurchaseCardState extends State<PurchaseCard>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _hoverController;
  late AnimationController _glowController;
  
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    // Slide in animation
    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _hoverController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    
    // Glow animation
    _glowController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Start animations with delay based on index
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      _slideController.forward();
    });

    // Continuous glow animation
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _hoverController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() {
      _isHovered = hovering;
    });
    
    if (hovering) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _glowAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _isPressed ? 0.98 : _scaleAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  // Outer glow effect
                  BoxShadow(
                    color: Colors.amberAccent.withOpacity(
                      _isHovered ? _glowAnimation.value * 0.3 : 0.1
                    ),
                    blurRadius: _isHovered ? 20 : 8,
                    spreadRadius: _isHovered ? 2 : 0,
                  ),
                  // Dark shadow for depth
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                child: MouseRegion(
                  onEnter: (_) => _onHover(true),
                  onExit: (_) => _onHover(false),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1A1A1A),
                          Color(0xFF0D0D0D),
                        ],
                      ),
                      border: Border.all(
                        color: _isHovered 
                          ? Colors.amberAccent.withOpacity(0.5)
                          : Colors.grey.withOpacity(0.2),
                        width: _isHovered ? 1.5 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          // Animated background pattern
                          if (_isHovered)
                            Positioned.fill(
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 300),
                                opacity: 0.1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.amberAccent.withOpacity(0.1),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          
                          // Main content
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header row with movie title and status
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.data.movieTitle,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            DateFormat('dd MMM yyyy • HH:mm')
                                                .format(widget.data.dateTime),
                                            style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    StatusChip(status: widget.data.status),
                                  ],
                                ),
                                
                                SizedBox(height: 16),
                                
                                // Seats information with icon
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.amberAccent.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.event_seat,
                                        color: Colors.amberAccent,
                                        size: 16,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Seats: ${widget.data.seats.join(', ')}',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: 12),
                                
                                // Price information with icon
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.amberAccent.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.payments,
                                        color: Colors.amberAccent,
                                        size: 16,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Total: ',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      'Rp ${NumberFormat('#,###').format(widget.data.totalPrice)}',
                                      style: TextStyle(
                                        color: Colors.amberAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          // Shimmer effect on hover
                          if (_isHovered)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: AnimatedBuilder(
                                  animation: _glowAnimation,
                                  builder: (context, child) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment(-1.0 + _glowAnimation.value * 2, 0),
                                          end: Alignment(1.0 + _glowAnimation.value * 2, 0),
                                          colors: [
                                            Colors.transparent,
                                            Colors.amberAccent.withOpacity(0.1),
                                            Colors.transparent,
                                          ],
                                          stops: [0.0, 0.5, 1.0],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}