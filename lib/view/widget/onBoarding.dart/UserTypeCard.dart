import 'package:flutter/material.dart';

class UserTypeCard extends StatefulWidget {
  final String title;
  final String description;
  final VoidCallback onTap;
  final IconData icon;
  final MaterialColor color;

  const UserTypeCard({
    Key? key,
    required this.title,
    required this.description,
    required this.onTap,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  _UserTypeCardState createState() => _UserTypeCardState();
}

class _UserTypeCardState extends State<UserTypeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _animationController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _animationController.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.grey[50]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: -5,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
                border: Border.all(
                  color: widget.color.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: [
                    // Icon Container
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            widget.color.withOpacity(0.8),
                            widget.color,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withOpacity(0.4),
                            spreadRadius: 0,
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Title
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: 10),
                    
                    // Description
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Action Button
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.color.withOpacity(0.8),
                            widget.color,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "ابدأ الآن",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}