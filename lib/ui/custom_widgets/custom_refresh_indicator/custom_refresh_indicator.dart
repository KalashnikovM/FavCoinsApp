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
  double _dragOffset = 0.0;
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          _dragOffset += details.primaryDelta ?? 0.0;
        });
        debugPrint("Drag update: $_dragOffset");
      },
      onVerticalDragEnd: (details) async {
        debugPrint("Drag end: $_dragOffset");
        if (_dragOffset > 150 && !_isRefreshing) {
          setState(() {
            _isRefreshing = true;
          });
          debugPrint("Refreshing...");
          await widget.onRefresh();
          setState(() {
            _isRefreshing = false;
          });
          debugPrint("Refresh complete");
        }
        setState(() {
          _dragOffset = 0.0;
        });
      },
      child: Stack(
        children: [
          widget.child,
          if (_isRefreshing)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}