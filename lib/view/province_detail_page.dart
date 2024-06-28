import 'package:flutter/material.dart';
import 'package:mynote/controller/city.dart';
import 'package:mynote/view/province_edit_page.dart';
import 'package:mynote/view/province_information.dart';
import 'package:mynote/view/province_list_page.dart';

import '../controller/license_plate.dart';
import '../controller/province.dart';
import '../controller/scenic_spot.dart';
import '../controller/specialty.dart';
import '../controller/university.dart';

class ProvinceDetailPage extends StatelessWidget {
  const ProvinceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    int idProvince = ModalRoute.of(context)?.settings.arguments as int;

    return MaterialApp(
      home: Scaffold(
        body: ProvinceDetail(idProvince: idProvince),
      ),
    );
  }
}

class ProvinceDetail extends StatefulWidget {
  const ProvinceDetail({super.key, required this.idProvince});

  final int idProvince;

  @override
  State<ProvinceDetail> createState() => _ProvinceDetail();
}

class _ProvinceDetail extends State<ProvinceDetail> {
  String? provinceInfor;
  String? citiesInfor;
  String? licensePlatesInfor;
  String? universitiesInfor;
  String? scenicSpotsInfor;
  String? specialtiesInfor;
  String? createAtInfor;

  @override
  void initState() {
    super.initState();
    renderProvince();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        color: Colors.black87,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              margin: const EdgeInsets.only(top: 12),
              child: const Center(
                child: Text(
                  'Province Detail',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              )),
          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProvinceInformation(
                    title: 'Province', information: provinceInfor ?? ''),
                ProvinceInformation(
                    title: 'City', information: citiesInfor ?? ''),
                ProvinceInformation(
                    title: 'License plate',
                    information: licensePlatesInfor ?? ''),
                ProvinceInformation(
                    title: 'University', information: universitiesInfor ?? ''),
                ProvinceInformation(
                    title: 'Scenic spot', information: scenicSpotsInfor ?? ''),
                ProvinceInformation(
                    title: 'Specialty', information: specialtiesInfor ?? ''),
                ProvinceInformation(
                    title: 'Created at', information: createAtInfor ?? '')
              ]),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ProvinceListPage()));
                      },
                      child: const Text('Home')),
                )),
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.only(left: 6),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProvinceEdit(),
                              settings:
                                  RouteSettings(arguments: widget.idProvince)));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6))),
                    child: const Text('Edit'),
                  ),
                ))
              ],
            ),
          )
        ]));
  }

  Future<void> renderProvince() async {
    List<dynamic> province = await getProvince(widget.idProvince);
    List<dynamic> cities = await getCitiesByProvinceId(widget.idProvince);
    cities = cities
        .whereType<Map<String, dynamic>>()
        .map((city) => city['city'].toString())
        .toList();

    List<dynamic> licensePlates =
        await getLicensePlatesByProvinceId(widget.idProvince);
    licensePlates = licensePlates
        .whereType<Map<String, dynamic>>()
        .map((licensePlate) => licensePlate['licensePlate'].toString())
        .toList();

    List<dynamic> universities =
        await getUniversitiesByProvinceId(widget.idProvince);
    universities = universities
        .whereType<Map<String, dynamic>>()
        .map((university) => university['university'].toString())
        .toList();

    List<dynamic> scenicSpots =
        await getScenicSpotsByProvinceId(widget.idProvince);
    scenicSpots = scenicSpots
        .whereType<Map<String, dynamic>>()
        .map((scenicSpot) => scenicSpot['scenicSpot'].toString())
        .toList();

    List<dynamic> specialties =
        await getSpecialtiesByProvinceId(widget.idProvince);
    specialties = specialties
        .whereType<Map<String, dynamic>>()
        .map((specialty) => specialty['specialty'].toString())
        .toList();

    setState(() {
      provinceInfor = province[0]['provinceName'];
      createAtInfor = province[0]['createdAt'];
      citiesInfor = cities.join(", ");
      licensePlatesInfor = licensePlates.join(", ");
      universitiesInfor = universities.join(", ").isNotEmpty
          ? universities.join(", ")
          : 'Empty';
      scenicSpotsInfor =
          scenicSpots.join(", ").isNotEmpty ? universities.join(", ") : 'Empty';
      specialtiesInfor =
          specialties.join(", ").isNotEmpty ? universities.join(", ") : 'Empty';
    });
  }
}
