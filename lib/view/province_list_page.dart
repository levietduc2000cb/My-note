import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mynote/controller/city.dart';
import 'package:mynote/controller/license_plate.dart';
import 'package:mynote/controller/scenic_spot.dart';
import 'package:mynote/controller/specialty.dart';
import 'package:mynote/controller/university.dart';
import 'package:mynote/model/city_model.dart';
import 'package:mynote/model/scenic_spot_model.dart';
import 'package:mynote/model/specialty_model.dart';
import 'package:mynote/model/university_model.dart';
import 'package:mynote/view/create_province_form.dart';
import 'package:mynote/view/province_list.dart';
import 'package:mynote/view/search_province_form.dart';

import '../controller/province.dart';
import '../helper/singleton_shared_preferences.dart';
import '../model/license_plate_model.dart';
import '../model/province_model.dart';
import 'confirmation_dialog.dart';
import 'login_page.dart';

class ProvinceListPage extends StatelessWidget {
  const ProvinceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'My Note', home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> provinces = [];

  int? userId;
  String? userName;

  @override
  void initState() {
    super.initState();
    initStateInPreferencesManager();
    refreshProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Note',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [TextButton(onPressed: logout, child: Text(userName ?? '', style: const TextStyle(color: Colors.white),))],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 70),
          child: Column(
            children: [
              SearchProvinceForm(handleSearch: handleSearchProvince),
              ProvinceList(
                deleteProvince: handleDeleteProvince,
                provinceList: provinces,
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(context),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  // This function is used to fetch all data from the database
  Future<void> refreshProvinces([dynamic data]) async {
    if(userId! > 0){
      data ??= await getProvincesByUserId(userId!);
      setState(() {
        provinces = data ?? [];
      });
    }
  }

  // Insert a new province to the database
  Future<void> handleAddProvince(Map<String, dynamic> province) async {
    try {
      int provinceId = await createProvince(
          ProvinceModel(
              userId: userId,
              provinceName: province['provinceName'].trim().toUpperCase())
      );
      List<String> cities = province['city'].split(",") ?? [];
      List<String> licensePlates = province['licensePlate'].split(",") ?? [];
      List<String> universities = province['university'].split(",") ?? [];
      List<String> scenicSpots = province['scenicSpot'].split(",") ?? [];
      List<String> specialties = province['specialty'].split(",") ?? [];

      for (var city in cities) {
        if(city.trim().isNotEmpty){
          await createCity(CityModel(
              city: city.trim(),
              provinceId: provinceId
          ));
        }
      }

      for (var licensePlate in licensePlates) {
        if(licensePlate.trim().isNotEmpty){
          await createLicense(LicensePlateModel(
              licensePlate: int.parse(licensePlate),
              provinceId: provinceId
          ));
        }
      }

      for (var university in universities) {
        if(university.trim().isNotEmpty){
          await createUniversity(UniversityModel(
              university: university.trim(),
              provinceId: provinceId
          ));
        }
      }

      for (var scenicSpot in scenicSpots) {
        if(scenicSpot.trim().isNotEmpty){
          await createScenicSpot(ScenicSpotModel(
              scenicSpot: scenicSpot.trim(),
              provinceId: provinceId
          ));
        }
      }

      for (var specialty in specialties) {
        if(specialty.trim().isNotEmpty){
          await createSpecialty(SpecialtyModel(
              specialty: specialty.trim(),
              provinceId: provinceId
          ));
        }
      }
      refreshProvinces();
      if(!mounted) return;
      showNotification(context, "Create province success!!!");
    } catch (e) {
      if(!mounted) return;
      showNotification(context, "Create a failed province!!!");
    }
  }

  // Search provinces from database
  Future<void> handleSearchProvince(
      String? provinceName, String? selectedSort) async {
    provinceName = provinceName ?? '';
    switch (selectedSort) {
      case 'Default':
        selectedSort = null;
        break;
      case 'High to low':
        selectedSort = 'DESC';
        break;
      case 'Low to high':
        selectedSort = 'ASC';
        break;
      default:
    }
    try{
      dynamic data = await getProvincesByProvinceNameAndUserId(provinceName, userId!, selectedSort);
      refreshProvinces(data);
    }catch (e) {
      if(!mounted) return;
      showNotification(context, "Search failed province!!!");
    }
  }

  // This function is used to fetch all data from the database
  void refreshProvincesAfterDelete(int provinceId) {
    List<Map<String, dynamic>> datas = [];
    for (int i = 0; i < provinces.length; i++ ) {
      if(provinces[i]['id'] == provinceId){
        continue;
      }
      datas.add(provinces[i]);
    }
    setState(() {
      provinces = datas;
    });
  }

  // Delete a province from database
  Future<void> handleDeleteProvince(int id) async {
    showConfirmationDialog(
        context: context,
        title: 'Delete',
        content: 'Do you want to delete this province?',
        onConfirm: () async {
          try {
            await deleteScenicSpotByProvinceId(id);
            await deleteSpecialtyByProvinceId(id);
            await deleteUniversityByProvinceId(id);
            await deleteLicensePlateByProvinceId(id);
            await deleteCityByProvinceId(id);
            await deleteProvince(id);
            refreshProvincesAfterDelete(id);
          } catch (e) {
            if(!mounted) return;
            showNotification(context, "Delete a failed province!!!");
          }
        });
  }

  void showForm(BuildContext context) {
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return CreateProvinceForm(
            cancel: () => Navigator.of(context).pop(),
            createProvince: (dynamic province) async {
              await handleAddProvince(province);
            },
          );
        });
  }

  void showNotification(BuildContext context, String? title) {
    final snackBar = SnackBar(
      content: Text("$title"),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<dynamic> logout() async{
    final preferencesManager = PreferencesManager();
    try{
      await preferencesManager.clearSharedPreferences();
      if (!mounted) return;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginPage())
      );
    }catch(err){
      const snackBar = SnackBar(
        content: Text("Logout failure"),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void initStateInPreferencesManager(){
    final preferencesManager = PreferencesManager();
    setState(() {
      userId = preferencesManager.getInt('userId');
      userName = preferencesManager.getString('userName');
    });
  }
}
