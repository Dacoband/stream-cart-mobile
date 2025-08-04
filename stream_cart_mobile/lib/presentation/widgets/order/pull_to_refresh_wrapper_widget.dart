import 'package:flutter/material.dart';

// Pull to refresh wrapper widget
class PullToRefreshWrapperWidget extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? refreshIndicatorColor;
  final Color? backgroundColor;

  const PullToRefreshWrapperWidget({
    Key? key,
    required this.child,
    required this.onRefresh,
    this.refreshIndicatorColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: refreshIndicatorColor ?? Theme.of(context).primaryColor,
      backgroundColor: backgroundColor ?? Colors.white,
      strokeWidth: 2.5,
      displacement: 40,
      child: child,
    );
  }
}

// Custom pull to refresh - CLEANED UP VERSION
class CustomPullToRefreshWidget extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final String refreshText;
  final Color? indicatorColor;

  const CustomPullToRefreshWidget({
    Key? key,
    required this.child,
    required this.onRefresh,
    this.refreshText = 'Đang làm mới...',
    this.indicatorColor,
  }) : super(key: key);

  @override
  State<CustomPullToRefreshWidget> createState() => _CustomPullToRefreshWidgetState();
}

class _CustomPullToRefreshWidgetState extends State<CustomPullToRefreshWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    _animationController.forward();
    try {
      await widget.onRefresh();
    } finally {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: widget.indicatorColor ?? Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
      strokeWidth: 2.5,
      displacement: 50,
      child: widget.child,
    );
  }
}

class AdvancedPullToRefreshWidget extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final String refreshText;
  final double triggerDistance;

  const AdvancedPullToRefreshWidget({
    Key? key,
    required this.child,
    required this.onRefresh,
    this.refreshText = 'Đang làm mới...',
    this.triggerDistance = 80.0,
  }) : super(key: key);

  @override
  State<AdvancedPullToRefreshWidget> createState() => _AdvancedPullToRefreshWidgetState();
}

class _AdvancedPullToRefreshWidgetState extends State<AdvancedPullToRefreshWidget> {
  bool _isRefreshing = false;
  double _pullDistance = 0.0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          setState(() {
            _pullDistance = 0.0;
          });
        } else if (notification is ScrollUpdateNotification) {
          if (notification.metrics.pixels < 0) {
            setState(() {
              _pullDistance = -notification.metrics.pixels;
            });
          }
        } else if (notification is ScrollEndNotification) {
          if (_pullDistance >= widget.triggerDistance && !_isRefreshing) {
            _handleRefresh();
          }
          setState(() {
            _pullDistance = 0.0;
          });
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Stack(
          children: [
            widget.child,
            if (_pullDistance > 0)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: _pullDistance.clamp(0.0, 60.0),
                  color: Colors.blue.withOpacity(0.1),
                  child: Center(
                    child: Text(
                      _pullDistance >= widget.triggerDistance
                          ? 'Thả để làm mới'
                          : 'Kéo để làm mới',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    
    setState(() {
      _isRefreshing = true;
    });

    try {
      await widget.onRefresh();
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }
}