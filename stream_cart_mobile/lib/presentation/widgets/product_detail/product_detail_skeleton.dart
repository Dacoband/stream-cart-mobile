import 'package:flutter/material.dart';

class ProductDetailSkeleton extends StatefulWidget {
  const ProductDetailSkeleton({super.key});

  @override
  State<ProductDetailSkeleton> createState() => _ProductDetailSkeletonState();
}

class _ProductDetailSkeletonState extends State<ProductDetailSkeleton>
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
    _animation = Tween(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image skeleton
              _buildSkeletonBox(
                width: double.infinity,
                height: 300,
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name skeleton
                    _buildSkeletonBox(
                      width: double.infinity,
                      height: 28,
                    ),
                    const SizedBox(height: 8),
                    _buildSkeletonBox(
                      width: 200,
                      height: 20,
                    ),
                    const SizedBox(height: 16),
                    
                    // Price skeleton
                    Row(
                      children: [
                        _buildSkeletonBox(
                          width: 120,
                          height: 32,
                        ),
                        const SizedBox(width: 12),
                        _buildSkeletonBox(
                          width: 80,
                          height: 20,
                        ),
                        const SizedBox(width: 8),
                        _buildSkeletonBox(
                          width: 40,
                          height: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Stats skeleton
                    Row(
                      children: [
                        _buildSkeletonBox(width: 80, height: 16),
                        const SizedBox(width: 16),
                        _buildSkeletonBox(width: 60, height: 16),
                        const SizedBox(width: 16),
                        _buildSkeletonBox(width: 100, height: 16),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Description skeleton
                    _buildSkeletonBox(
                      width: 120,
                      height: 20,
                    ),
                    const SizedBox(height: 8),
                    _buildSkeletonBox(
                      width: double.infinity,
                      height: 16,
                    ),
                    const SizedBox(height: 4),
                    _buildSkeletonBox(
                      width: double.infinity,
                      height: 16,
                    ),
                    const SizedBox(height: 4),
                    _buildSkeletonBox(
                      width: 250,
                      height: 16,
                    ),
                    const SizedBox(height: 24),
                    
                    // Variants skeleton
                    _buildSkeletonBox(
                      width: 100,
                      height: 20,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildSkeletonBox(width: 100, height: 60),
                        const SizedBox(width: 8),
                        _buildSkeletonBox(width: 100, height: 60),
                        const SizedBox(width: 8),
                        _buildSkeletonBox(width: 100, height: 60),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Shop info skeleton
                    _buildSkeletonBox(
                      width: double.infinity,
                      height: 120,
                    ),
                    const SizedBox(height: 16),
                    
                    // Product details skeleton
                    _buildSkeletonBox(
                      width: double.infinity,
                      height: 150,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkeletonBox({
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300.withOpacity(_animation.value),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
