import 'package:flutter/material.dart';

class ProvinceInformation extends StatelessWidget {

  const ProvinceInformation({super.key, required this.title, required this.information});

  final String? title;
  final String? information;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title!,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
          ),
          Container(
            margin: const EdgeInsets.only(top:7),
            child: Text(information!, style: const TextStyle(color: Colors.white, fontSize: 16)),
          )
        ],
      ),
    );
  }
}