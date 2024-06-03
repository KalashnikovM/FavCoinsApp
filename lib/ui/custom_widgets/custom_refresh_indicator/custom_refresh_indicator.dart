import 'package:flutter/material.dart';

class CustomRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const CustomRefreshIndicator({
    Key? key,
    required this.child,
    required this.onRefresh,
  }) : super(key: key);

  @override
  _CustomRefreshIndicatorState createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  bool _isRefreshing = false;

  Future<void> _refresh() async {
    setState(() {
      _isRefreshing = true;
    });
    await widget.onRefresh();
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification &&
            notification.metrics.pixels <= -100.0 &&
            !_isRefreshing) {
          _refreshIndicatorKey.currentState?.show();
        }
        return false;
      },
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        displacement: 40.0,
        child: widget.child,
        color: Colors.blue, // Customize the color here
        backgroundColor: Colors.transparent, // Customize the background color here
        strokeWidth: 2.0, // Customize the stroke width here
      ),
    );
  }
}