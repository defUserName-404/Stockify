import 'package:flutter/material.dart';

class InfoCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final int index;
  final VoidCallback onTap;

  const InfoCard(
      {super.key,
      required this.title,
      required this.value,
      required this.icon,
      required this.color,
      required this.index,
      required this.onTap});

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  int _hoveredCardIndex = -1;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredCardIndex = widget.index),
      onExit: (_) => setState(() => _hoveredCardIndex = -1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(_hoveredCardIndex == widget.index ? 1.02 : 1.0),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.color.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: _hoveredCardIndex == widget.index
                      ? widget.color.withAlpha(30)
                      : Colors.black.withAlpha(10),
                  blurRadius: _hoveredCardIndex == widget.index ? 20 : 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.color.withAlpha(50),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.color,
                        size: 30,
                      ),
                    ),
                    if (_hoveredCardIndex == widget.index)
                      Icon(
                        Icons.arrow_forward_ios,
                        color: widget.color,
                        size: 20,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: widget.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
