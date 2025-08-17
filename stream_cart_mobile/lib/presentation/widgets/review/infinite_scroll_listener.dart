import 'package:flutter/material.dart';

class InfiniteScrollListener extends StatefulWidget {
  final Widget child;
  final VoidCallback onEndReached;
  const InfiniteScrollListener({super.key, required this.child, required this.onEndReached});

  @override
  State<InfiniteScrollListener> createState() => _InfiniteScrollListenerState();
}

class _InfiniteScrollListenerState extends State<InfiniteScrollListener> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final max = _controller.position.maxScrollExtent;
    final current = _controller.position.pixels;
    if (current >= max - 200) {
      widget.onEndReached();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: _controller,
      child: widget.child,
    );
  }
}
