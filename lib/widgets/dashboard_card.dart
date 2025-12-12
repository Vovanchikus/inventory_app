import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DashboardCard extends StatefulWidget {
  final String title;
  final int? animateValue;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    this.animateValue,
    required this.icon,
    required this.color,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation =
        IntTween(begin: 0, end: widget.animateValue ?? 0).animate(_controller);

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant DashboardCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animateValue != widget.animateValue) {
      _animation = IntTween(
        begin: 0,
        end: widget.animateValue ?? 0,
      ).animate(_controller);

      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, size: 32, color: widget.color),
            const SizedBox(height: 8),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Text(
                  _animation.value.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: widget.color,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
