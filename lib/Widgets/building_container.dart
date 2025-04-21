// lib\Widgets\building_container.dart
import 'package:flutter/material.dart';

class BuildingContainer extends StatelessWidget {
  const BuildingContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/building.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
