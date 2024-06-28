import 'package:flutter/material.dart';
import 'package:mynote/view/province_edit_form.dart';

class ProvinceEdit extends StatelessWidget {
  const ProvinceEdit({super.key});

  @override
  Widget build(BuildContext context) {
    int idProvince = ModalRoute.of(context)?.settings.arguments as int;

    return MaterialApp(
      title: 'My Note',
      home: Scaffold(
        appBar: AppBar(
          title:
              const Text('Edit', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            color: Colors.black87,
            child: ProvinceEditForm(idProvince: idProvince)),
      ),
    );
  }
}
