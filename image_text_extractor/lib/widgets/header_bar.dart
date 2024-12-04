import 'package:flutter/material.dart';


class HeaderBar extends StatelessWidget {
  final String title;

  const HeaderBar({
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: Color(0xfff2f2f2),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, -5),
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
              style: TextStyle(
                  fontSize: 26
              ),
            ),
          ],
        ),
      ),
    );
  }
}