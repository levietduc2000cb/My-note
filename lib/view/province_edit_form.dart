import 'package:flutter/material.dart';
import 'package:mynote/controller/license_plate.dart';
import 'package:mynote/model/city_model.dart';
import 'package:mynote/model/license_plate_model.dart';
import 'package:mynote/model/scenic_spot_model.dart';
import 'package:mynote/model/specialty_model.dart';
import 'package:mynote/model/university_model.dart';
import 'package:mynote/view/province_detail_page.dart';
import 'package:mynote/view/province_infor_edit_list.dart';
import 'package:mynote/view/province_list_page.dart';

import '../controller/city.dart';
import '../controller/province.dart';
import '../controller/scenic_spot.dart';
import '../controller/specialty.dart';
import '../controller/university.dart';
import '../model/province_model.dart';
import 'input_form.dart';

class ProvinceEditForm extends StatefulWidget {
  const ProvinceEditForm({super.key, required this.idProvince});

  final int idProvince;

  @override
  State<ProvinceEditForm> createState() => _ProvinceEditForm();
}

class _ProvinceEditForm extends State<ProvinceEditForm> {
  final _editProvinceFormKey = GlobalKey<FormState>();

  TextEditingController provinceName = TextEditingController();

  @override
  void initState() {
    super.initState();
    renderProvince();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: SingleChildScrollView(
          child: Column(
        children: [
          Form(
              key: _editProvinceFormKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: InputForm(
                          keyboardType: TextInputType.text,
                          controller: provinceName,
                          labelText: 'Province',
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your province';
                            }
                            return null;
                          })),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        // Thay đổi màu nền
                        foregroundColor: Colors.black,
                        // Thay đổi màu chữ
                        side: const BorderSide(
                          color: Colors.white, // Thay đổi màu viền
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), // Độ cong của viền
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8)),
                    onPressed: submit,
                    child: const Text('Rename'),
                  )
                ],
              )),
          ProvinceInforEditList(
            idProvince: widget.idProvince,
            titleForm: 'City',
            idKey: 'id',
            nameKey: 'city',
            render: getCities,
            handleDelete: deleteACity,
            handleCreate: createANewCity,
          ),
          ProvinceInforEditList(
            idProvince: widget.idProvince,
            titleForm: 'License plate',
            idKey: 'id',
            nameKey: 'licensePlate',
            render: getLicensePlates,
            handleDelete: deleteALicensePlate,
            handleCreate: createANewLicensePlate,
          ),
          ProvinceInforEditList(
            idProvince: widget.idProvince,
            titleForm: 'University',
            idKey: 'id',
            nameKey: 'university',
            render: getUniversities,
            handleDelete: deleteAUniversity,
            handleCreate: createANewUniversity,
          ),
          ProvinceInforEditList(
            idProvince: widget.idProvince,
            titleForm: 'Scenic spot',
            idKey: 'id',
            nameKey: 'scenicSpot',
            render: getScenicSpots,
            handleDelete: deleteAScenicSpot,
            handleCreate: createANewScenicSpot,
          ),
          ProvinceInforEditList(
            idProvince: widget.idProvince,
            titleForm: 'Specialty',
            idKey: 'id',
            nameKey: 'specialty',
            render: getSpecialties,
            handleDelete: deleteASpecialty,
            handleCreate: createANewSpecialty,
          ),
          Container(
            margin: const EdgeInsets.only(top: 40, bottom: 20),
            child: Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProvinceListPage()));
                  },
                  child: const Text('Home'),
                )),
                const SizedBox(width: 10.0),
                Expanded(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white70,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProvinceDetailPage(),
                            settings:
                                RouteSettings(arguments: widget.idProvince)));
                  },
                  child: const Text('Detail'),
                ))
              ],
            ),
          )
        ],
      )),
    );
  }

  Future<void> renderProvince() async {
    dynamic data = await getProvince(widget.idProvince);
    provinceName.text = data[0]['provinceName'];
  }

  void goBackHomePage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ProvinceListPage()));
  }

  Future<bool> isExistNameProvince(String nameProvince) async {
    nameProvince = nameProvince.trim().toUpperCase();
    List<dynamic> data = await getProvinceByName(nameProvince);
    return data.isNotEmpty ? true : false;
  }

  Future<void> submit() async {
    if (_editProvinceFormKey.currentState!.validate()) {
      try {
        bool isExist = await isExistNameProvince(provinceName.text);
        if (isExist == false) {
          await updateProvince(ProvinceModel(
            id: widget.idProvince,
            provinceName: provinceName.text.trim().toUpperCase(),
          ));
          if (!mounted) return;
          provinceName.text = provinceName.text.trim().toUpperCase();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Province updated successfully"),
            duration: Duration(seconds: 3),
          ));
        } else {
          await renderProvince();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("The province name exists!!!"),
            duration: Duration(seconds: 3),
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Province update failed"),
          duration: Duration(seconds: 3),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill input')),
      );
    }
  }

  Future<dynamic> getCities() async {
    dynamic data = await getCitiesByProvinceId(widget.idProvince);
    return data;
  }

  Future<dynamic> createANewCity(data) async {
    await createCity(CityModel(
      city: data['otherValue'],
      provinceId: data['provinceId'],
    ));
  }

  Future<dynamic> deleteACity(id) async {
    await deleteCity(id);
  }

  Future<dynamic> getLicensePlates() async {
    dynamic data = await getLicensePlatesByProvinceId(widget.idProvince);
    return data;
  }

  Future<dynamic> createANewLicensePlate(data) async {
    await createLicense(LicensePlateModel(
      licensePlate: int.parse(data['otherValue']),
      provinceId: data['provinceId'],
    ));
  }

  Future<dynamic> deleteALicensePlate(id) async {
    await deleteLicensePlate(id);
  }

  Future<dynamic> getUniversities() async {
    dynamic data = await getUniversitiesByProvinceId(widget.idProvince);
    return data;
  }

  Future<dynamic> createANewUniversity(data) async {
    await createUniversity(UniversityModel(
      university: data['otherValue'],
      provinceId: data['provinceId'],
    ));
  }

  Future<dynamic> deleteAUniversity(id) async {
    await deleteUniversity(id);
  }

  Future<dynamic> getScenicSpots() async {
    dynamic data = await getScenicSpotsByProvinceId(widget.idProvince);
    return data;
  }

  Future<dynamic> createANewScenicSpot(data) async {
    await createScenicSpot(ScenicSpotModel(
      scenicSpot: data['otherValue'],
      provinceId: data['provinceId'],
    ));
  }

  Future<dynamic> deleteAScenicSpot(id) async {
    await deleteScenicSpot(id);
  }

  Future<dynamic> getSpecialties() async {
    dynamic data = await getSpecialtiesByProvinceId(widget.idProvince);
    return data;
  }

  Future<dynamic> createANewSpecialty(data) async {
    await createSpecialty(SpecialtyModel(
      specialty: data['otherValue'],
      provinceId: data['provinceId'],
    ));
  }

  Future<dynamic> deleteASpecialty(id) async {
    await deleteSpecialty(id);
  }
}
