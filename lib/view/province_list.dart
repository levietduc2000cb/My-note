import 'package:flutter/material.dart';
import 'package:mynote/view/province.dart';

import '../model/province_model.dart';

class ProvinceList extends StatelessWidget {
  const ProvinceList({super.key, required this.provinceList, required this.deleteProvince});

  final dynamic provinceList;
  final Future<void> Function(int) deleteProvince;

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        for (dynamic province in provinceList)
          Province(
              idProvince: province['id'],
              iconProvince: Icons.local_activity,
              province: province['provinceName'],
              createdDate: province['createdAt'],
              deleteProvince: () => deleteProvince(province['id']),
          ),
      ]
    );
  }
}
