import 'package:flutter/material.dart';

class ShopShimmer extends StatefulWidget {
  const ShopShimmer({super.key});

  @override
  State<ShopShimmer> createState() => _ShopShimmerState();
}

class _ShopShimmerState extends State<ShopShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6, // Show 6 shimmer cards
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shop Header
                      Row(
                        children: [
                          // Shop Avatar
                          _buildShimmerContainer(60, 60, 12),
                          const SizedBox(width: 12),
                          
                          // Shop Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildShimmerContainer(double.infinity, 18, 4),
                                const SizedBox(height: 8),
                                _buildShimmerContainer(MediaQuery.of(context).size.width * 0.6, 14, 4),
                                const SizedBox(height: 4),
                                _buildShimmerContainer(MediaQuery.of(context).size.width * 0.4, 14, 4),
                              ],
                            ),
                          ),
                          
                          // Status Badge
                          _buildShimmerContainer(60, 20, 12),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Shop Stats
                      Row(
                        children: [
                          // Rating
                          _buildShimmerContainer(60, 24, 8),
                          const SizedBox(width: 12),
                          
                          // Products
                          _buildShimmerContainer(80, 24, 8),
                          const Spacer(),
                          
                          // View Shop Button
                          _buildShimmerContainer(80, 28, 8),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Created Date
                      _buildShimmerContainer(120, 12, 4),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerContainer(double width, double height, double borderRadius) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment(-1.0 + _animation.value, 0.0),
          end: Alignment(_animation.value, 0.0),
          colors: const [
            Color(0xFFE0E0E0),
            Color(0xFFF5F5F5),
            Color(0xFFE0E0E0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}
