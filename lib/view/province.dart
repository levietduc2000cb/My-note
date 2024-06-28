import 'package:flutter/material.dart';
import 'package:mynote/view/province_detail_page.dart';
import 'package:mynote/view/province_edit_page.dart';

class Province extends StatelessWidget {
  const Province(
      {super.key,
      required this.idProvince,
      required this.iconProvince,
      required this.province,
      required this.createdDate,
      required this.deleteProvince});

  final int idProvince;
  final IconData iconProvince;
  final String province;
  final String createdDate;
  final Future<void> Function() deleteProvince;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black87,
        margin: const EdgeInsets.only(top: 2.0),
        padding:
            const EdgeInsets.only(top: 15, left: 10, bottom: 15, right: 10),
        child: (Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(iconProvince),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => goProvinceDetail(context),
                        child: Text(province,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      Text(createdDate,
                          style: const TextStyle(color: Colors.white70))
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                      onTap: () => goProvinceEdit(context),
                      child: const Icon(Icons.edit, color: Colors.blueAccent)),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                      onTap: deleteProvince,
                      child: const Icon(Icons.delete, color: Colors.redAccent)),
                )
              ],
            )
          ],
        )));
  }

  void goProvinceEdit(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ProvinceEdit(),
            settings: RouteSettings(arguments: idProvince)));
  }

  void goProvinceDetail(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ProvinceDetailPage(),
            settings: RouteSettings(arguments: idProvince)));
  }
}
