import 'package:flutter/material.dart';

class ExperienceGraph extends StatelessWidget {
  const ExperienceGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(213, 213, 218, 1.0),
      ),
      child: Center(
        child: Text(
          'Graphique de progression\n(À implémenter)',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
