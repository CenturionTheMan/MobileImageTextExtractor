import 'package:flutter/material.dart';


class HeaderBar extends StatelessWidget {
  final String title;

  const HeaderBar({super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: const Color(0xfff2f2f2),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 2),
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                spreadRadius: 8
            )
          ]
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 8, left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 26
              ),
            ),
          ],
        ),
      ),
    );
  }
}